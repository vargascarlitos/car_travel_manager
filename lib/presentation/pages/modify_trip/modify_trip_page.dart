import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/repositories/trip_repository.dart';
import '../../../app_config/utils/currency_formatter.dart';

class ModifyTripPage extends StatefulWidget {
  const ModifyTripPage({super.key});

  static const String routeName = '/trip-modify';

  @override
  State<ModifyTripPage> createState() => _ModifyTripPageState();
}

class _ModifyTripPageState extends State<ModifyTripPage> {
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  ServiceType _serviceType = ServiceType.economy;
  Trip? _trip;
  bool _loading = true;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _load();
    }
  }

  Future<void> _load() async {
    final args = ModalRoute.of(context)!.settings.arguments;
    final tripId = (args is Map && args['tripId'] is String) ? args['tripId'] as String : null;
    final repo = RepositoryProvider.of<TripRepository>(context);
    final trip = tripId != null ? await repo.getTripById(tripId) : null;
    if (!mounted) return;
    setState(() {
      _trip = trip;
      if (trip != null) {
        _nameCtrl.text = trip.passengerName;
        _amountCtrl.text = CurrencyFormatter.formatNumberOnly(trip.totalAmount.toString());
        _serviceType = trip.serviceType;
      }
      _loading = false;
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_trip == null) return;
    final repo = RepositoryProvider.of<TripRepository>(context);
    final digits = _amountCtrl.text.replaceAll(RegExp(r'[^\d]'), '');
    final amount = int.tryParse(digits) ?? _trip!.totalAmount;
    final updated = _trip!.copyWith(
      passengerName: _nameCtrl.text.trim().isEmpty ? _trip!.passengerName : _nameCtrl.text.trim(),
      totalAmount: amount,
      serviceType: _serviceType,
      updatedAt: DateTime.now(),
    );
    await repo.updateTrip(updated);
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modificar viaje'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nombre del pasajero', style: theme.textTheme.labelLarge),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(hintText: 'Nombre del pasajero'),
                        ),
                        const SizedBox(height: 16),
                        Text('Monto (Gs)', style: theme.textTheme.labelLarge),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _amountCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            _GsThousandsInputFormatter(),
                          ],
                          decoration: const InputDecoration(prefixText: 'Gs '),
                        ),
                        const SizedBox(height: 16),
                        Text('Tipo de servicio', style: theme.textTheme.labelLarge),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<ServiceType>(
                          value: _serviceType,
                          items: const [
                            DropdownMenuItem(value: ServiceType.economy, child: Text('Económico')),
                            DropdownMenuItem(value: ServiceType.uberX, child: Text('UberX')),
                            DropdownMenuItem(value: ServiceType.aireAc, child: Text('Aire AC')),
                          ],
                          onChanged: (v) => setState(() => _serviceType = v ?? _serviceType),
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: _save,
                          child: const Text('Guardar cambios'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _GsThousandsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final formatted = CurrencyFormatter.formatNumberOnly(digits);
    return TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
  }
}



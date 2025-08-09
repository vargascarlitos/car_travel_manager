import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app_config/theme_config.dart';

/// Pantalla de Nuevo Viaje - Primera pantalla del flujo
/// 
/// Implementa el diseño según screen_1_design.md con Bolt Dark Theme.
/// Permite cargar datos del pasajero, tarifa y tipo de servicio.
class NewTripPage extends StatefulWidget {
  const NewTripPage({super.key});

  /// Ruta estática de la página
  static const String route = '/';

  @override
  State<NewTripPage> createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {
  // ========================================
  // CONTROLADORES DE FORMULARIO
  // ========================================

  final _formKey = GlobalKey<FormState>();
  final _passengerController = TextEditingController();
  final _fareController = TextEditingController();
  final _passengerFocusNode = FocusNode();
  final _fareFocusNode = FocusNode();

  // ========================================
  // ESTADO DEL FORMULARIO
  // ========================================

  String _selectedServiceType = 'economy';
  bool _isFormValid = false;

  // Cantidades rápidas para chips
  final List<int> _quickAmounts = [10000, 20000, 50000];
  int? _selectedQuickAmount;

  @override
  void initState() {
    super.initState();
    
    // Listeners para validación en tiempo real
    _passengerController.addListener(_validateForm);
    _fareController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _passengerController.dispose();
    _fareController.dispose();
    _passengerFocusNode.dispose();
    _fareFocusNode.dispose();
    super.dispose();
  }

  // ========================================
  // VALIDACIÓN DEL FORMULARIO
  // ========================================

  void _validateForm() {
    final passengerValid = _passengerController.text.trim().isNotEmpty;
    final fareValid = _fareController.text.isNotEmpty && 
                     int.tryParse(_fareController.text.replaceAll(RegExp(r'[^\d]'), '')) != null &&
                     int.parse(_fareController.text.replaceAll(RegExp(r'[^\d]'), '')) > 0;

    setState(() {
      _isFormValid = passengerValid && fareValid;
    });
  }

  void _onQuickAmountSelected(int amount) {
    setState(() {
      _selectedQuickAmount = amount;
      _fareController.text = _formatCurrency(amount);
    });
    _validateForm();
  }

  void _onServiceTypeChanged(String serviceType) {
    setState(() {
      _selectedServiceType = serviceType;
    });
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]}.',
    );
  }

  void _onStartTrip() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implementar navegación a previsualización
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Iniciando viaje para ${_passengerController.text}',
            style: AppTextStyles.bodyMedium,
          ),
          backgroundColor: AppColors.primaryContainer,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ========================================
      // TOP APP BAR - DARK THEME
      // ========================================
      appBar: AppBar(
        title: Text(
          'Nuevo Viaje',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.onSurface,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 4,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: AppColors.onSurface),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/history'),
            icon: const Icon(Icons.history),
            tooltip: 'Historial',
            iconSize: 24,
          ),
        ],
      ),

      // ========================================
      // CUERPO DE LA PÁGINA
      // ========================================
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ========================================
                  // TRIP COUNTER - DARK THEME
                  // ========================================
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Próximo viaje',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Viaje #124',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: AppColors.onPrimaryContainer,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ========================================
                  // UNIFIED FORM CARD - DARK THEME
                  // ========================================
                  Card(
                    elevation: 4,
                    color: AppColors.surfaceVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: AppColors.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ========================================
                          // PASSENGER INPUT
                          // ========================================
                          Text(
                            'Nombre del pasajero',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passengerController,
                            focusNode: _passengerFocusNode,
                            decoration: InputDecoration(
                              hintText: 'Nombre del pasajero',
                              hintStyle: TextStyle(
                                color: AppColors.onSurfaceVariant,
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              filled: true,
                              fillColor: AppColors.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.outline,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.outline,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.error,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                            ),
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.onSurface,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El nombre del pasajero es obligatorio';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // ========================================
                          // FARE INPUT WITH QUICK AMOUNTS
                          // ========================================
                          Text(
                            'Tarifa',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _fareController,
                            focusNode: _fareFocusNode,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              _ThousandsSeparatorInputFormatter(),
                            ],
                            decoration: InputDecoration(
                              hintText: '0',
                              hintStyle: TextStyle(
                                color: AppColors.onSurfaceVariant,
                              ),
                              prefixIcon: Icon(
                                Icons.payments,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              prefixText: 'Gs ',
                              prefixStyle: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                              filled: true,
                              fillColor: AppColors.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.outline,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.outline,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.error,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                            ),
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.onSurface,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El monto es obligatorio';
                              }
                              final amount = int.tryParse(value.replaceAll(RegExp(r'[^\d]'), ''));
                              if (amount == null || amount <= 0) {
                                return 'Ingrese un monto válido';
                              }
                              return null;
                            },
                          ),

              
                          const SizedBox(height: 24),

                          // ========================================
                          // SERVICE TYPE SELECTOR
                          // ========================================
                          Text(
                            'Tipo de servicio',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Wrap(
                            spacing: 12,
                            children: [
                              _ServiceTypeChip(
                                label: 'Económico',
                                value: 'economy',
                                selectedValue: _selectedServiceType,
                                onChanged: _onServiceTypeChanged,
                              ),
                              _ServiceTypeChip(
                                label: 'Aire\nAcondicionado',
                                value: 'aire_ac',
                                selectedValue: _selectedServiceType,
                                onChanged: _onServiceTypeChanged,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ========================================
                  // ACTION BUTTON - DARK THEME
                  // ========================================
                  FilledButton(
                    onPressed: _isFormValid ? _onStartTrip : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      disabledBackgroundColor: AppColors.onSurface.withValues(alpha: 0.12),
                      disabledForegroundColor: AppColors.onSurface.withValues(alpha: 0.38),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Iniciar Viaje',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget para chips de tipo de servicio
class _ServiceTypeChip extends StatelessWidget {
  const _ServiceTypeChip({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onChanged,
  });

  final String label;
  final String value;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;
    
    return FilterChip(
      label: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isSelected 
              ? AppColors.onPrimary
              : AppColors.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          onChanged(value);
        }
      },
      backgroundColor: AppColors.surfaceVariant,
      selectedColor: AppColors.primary,
      checkmarkColor: AppColors.onPrimary,
      side: BorderSide(
        color: isSelected 
            ? AppColors.primary
            : AppColors.outline,
        width: 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      showCheckmark: false,
      avatar: isSelected 
          ? Icon(
              Icons.directions_car,
              size: 16,
              color: AppColors.onPrimary,
            )
          : null,
    );
  }
}

/// Formateador de miles para inputs de tarifa
class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final String digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final String formatted = digits.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]}.',
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

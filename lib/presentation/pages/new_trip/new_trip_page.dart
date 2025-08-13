import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app_config/utils/currency_formatter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/trip.dart';
import '../../../app_config/utils/service_type_label.dart';
import '../../../app_config/router_config.dart';
import '../../bloc/new_trip/new_trip_cubit.dart';
import '../../bloc/new_trip/new_trip_state.dart';

class NewTripPage extends StatelessWidget {
  const NewTripPage({super.key});

  static const String route = '/';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              NewTripCubit(tripRepository: RepositoryProvider.of(context)),
      child: BlocListener<NewTripCubit, NewTripState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == FormStatus.failure) {
            final theme = Theme.of(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failureMessage ?? 'Error desconocido'),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
          if (state.status == FormStatus.success &&
              state.lastSavedTripId != null) {
            context.pushNamed(
              '/preview',
              arguments: {'tripId': state.lastSavedTripId},
            );
          }
        },
        child: const NewTripView(),
      ),
    );
  }
}

class NewTripView extends StatelessWidget {
  const NewTripView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Nuevo Viaje', style: theme.textTheme.titleLarge),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/history'),
            icon: const Icon(Icons.history),
            tooltip: 'Historial',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TripCounterCard(),
              SizedBox(height: 24),
              _TripFormCard(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: const SizedBox(
          width: double.infinity,
          child: _SaveTripButton(),
        ),
      ),
    );
  }
}

class _TripCounterCard extends StatelessWidget {
  const _TripCounterCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Próximo viaje',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Viaje nuevo',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripFormCard extends StatelessWidget {
  const _TripFormCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _PassengerNameField(),
            SizedBox(height: 24),
            _FareAmountField(),
            SizedBox(height: 24),
            _ServiceTypeSelector(),
          ],
        ),
      ),
    );
  }
}

class _PassengerNameField extends StatelessWidget {
  const _PassengerNameField();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return BlocBuilder<NewTripCubit, NewTripState>(
      buildWhen: (p, c) => p.passengerName != c.passengerName,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre del pasajero',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              onChanged: context.read<NewTripCubit>().passengerNameChanged,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: 'Nombre del pasajero',
                prefixIcon: Icon(Icons.person, color: colors.primary, size: 20),
              ),
              validator:
                  (value) =>
                      value!.isEmpty ? state.passengerName.errorMessage : null,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.onSurface,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FareAmountField extends StatelessWidget {
  const _FareAmountField();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return BlocBuilder<NewTripCubit, NewTripState>(
      buildWhen: (p, c) => p.fareAmount != c.fareAmount,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tarifa',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _GsThousandsFormatter(),
              ],
              onChanged: context.read<NewTripCubit>().fareAmountChanged,
              decoration: InputDecoration(
                hintText: '0',
                prefixIcon: Icon(
                  Icons.payments,
                  color: colors.primary,
                  size: 20,
                ),
                prefixText: 'Gs ',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator:
                  (value) =>
                      value!.isEmpty
                          ? state.fareAmount.errorMessage
                          : null, // TODO: validar rango
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.onSurface,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ServiceTypeSelector extends StatelessWidget {
  const _ServiceTypeSelector();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tipo de servicio', style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            // Calcular alto deseado para cada tile (botón)
            const double tileHeight = 48;
            final double totalSpacing =
                2 * 12; // 12 de espacio entre columnas (2 gaps)
            final double tileWidth = (constraints.maxWidth - totalSpacing) / 3;
            final double aspectRatio = tileWidth / tileHeight;

            return GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: aspectRatio,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: const [
                _ServiceTypeTile(type: ServiceType.economy),
                _ServiceTypeTile(type: ServiceType.uberX),
                _ServiceTypeTile(type: ServiceType.aireAc),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ServiceTypeTile extends StatelessWidget {
  const _ServiceTypeTile({required this.type});

  final ServiceType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return BlocBuilder<NewTripCubit, NewTripState>(
      buildWhen: (p, c) => p.serviceType != c.serviceType,
      builder: (context, state) {
        final bool isSelected = state.serviceType == type;
        final Color bg = isSelected ? colors.primary : colors.surfaceVariant;
        final Color fg =
            isSelected ? colors.onPrimary : colors.onSurfaceVariant;
        final Color border = isSelected ? colors.primary : colors.outline;

        return Material(
          color: bg,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: border, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => context.read<NewTripCubit>().serviceTypeChanged(type),
            child: Center(
              child: Text(
                serviceTypeLabel(type),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SaveTripButton extends StatelessWidget {
  const _SaveTripButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewTripCubit, NewTripState>(
      buildWhen: (p, c) => p.isValid != c.isValid || p.status != c.status,
      builder: (context, state) {
        final isLoading = state.status == FormStatus.loading;
        return FilledButton(
          onPressed:
              state.isValid && !isLoading
                  ? context.read<NewTripCubit>().saveTrip
                  : null,
          child:
              isLoading
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Text('Guardar viaje'),
        );
      },
    );
  }
}

class _GsThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final formatted = CurrencyFormatter.formatNumberOnly(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

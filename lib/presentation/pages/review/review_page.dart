import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../domain/repositories/review_repository.dart';
import '../../bloc/review/review_cubit.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  static const String routeName = '/review';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final tripId = (args is Map && args['tripId'] is String) ? args['tripId'] as String : null;
    return BlocProvider(
      create: (ctx) => ReviewCubit(
        repository: RepositoryProvider.of<ReviewRepository>(ctx),
        tripId: tripId ?? '',
      ),
      child: const _ReviewView(),
    );
  }
}

class _ReviewView extends StatelessWidget {
  const _ReviewView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BlocListener<ReviewCubit, ReviewState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == ReviewStatus.failure && state.failureMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failureMessage!), backgroundColor: colors.error),
          );
        }
        if (state.status == ReviewStatus.success) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reseña del Viaje'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Califica tu viaje', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Center(
                  child: BlocBuilder<ReviewCubit, ReviewState>(
                    buildWhen: (p, c) => p.rating != c.rating,
                    builder: (context, state) {
                      return RatingBar.builder(
                        initialRating: state.rating.toDouble(),
                        minRating: 1,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 40,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                        itemBuilder: (context, _) => Icon(Icons.star, color: colors.tertiary),
                        onRatingUpdate: (value) => context.read<ReviewCubit>().ratingChanged(value.toInt()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text('Comentarios (opcional)', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                BlocBuilder<ReviewCubit, ReviewState>(
                  buildWhen: (p, c) => p.comment != c.comment,
                  builder: (context, state) {
                    return TextField(
                      maxLines: 5,
                      onChanged: context.read<ReviewCubit>().commentChanged,
                      decoration: InputDecoration(
                        hintText: 'Escribe tu comentario (máx. 1000)',
                        counterText: '${state.comment.length}/1000',
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: BlocBuilder<ReviewCubit, ReviewState>(
            buildWhen: (p, c) => p.status != c.status || p.rating != c.rating,
            builder: (context, state) {
              final saving = state.status == ReviewStatus.loading;
              return SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: state.rating >= 1 && !saving ? context.read<ReviewCubit>().save : null,
                  child: saving
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Guardar reseña'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}



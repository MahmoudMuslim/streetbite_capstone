import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/string_helpers.dart';
import '../../../domain/entities/meal_entity.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../blocs/favourites/favourites_cubit.dart';
import '../../blocs/favourites/favourites_state.dart';
import '../../extensions/l10n_extension.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/cart_badge.dart';
import '../../widgets/meta_pill.dart';
import '../../widgets/theme_toggle_button.dart';

/// Full description of a single meal.
///
/// Navigation passes the **entity itself** as a route argument (see
/// `AppRouter`), so the screen never re-fetches what the Home grid already
/// has: opening a meal is instant, works offline, and costs no extra request.
class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key, required this.meal});

  final MealEntity meal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.mealDetails),
        actions: [
          const ThemeToggleButton(),
          IconButton(
            key: const ValueKey('details_open_cart_button'),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.cart),
            icon: CartBadge(child: const Icon(Icons.shopping_bag_outlined)),
          ),
          const SizedBox(width: 4),
        ],
      ),
      // BlocListener -> SnackBar side effect.
      body: BlocListener<CartBloc, CartState>(
        listener: _onCartChanged,
        // BlocBuilder -> live cart count in the AppBar badge.
        child: BlocBuilder<CartBloc, CartState>(
          buildWhen: (previous, current) =>
              _countOf(previous) != _countOf(current),
          builder: (context, _) => _buildBody(context, theme),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'meal-image-${meal.id}',
            child: AppNetworkImage(
              key: ValueKey('meal_details_image_${meal.id}'),
              url: meal.thumbnailUrl,
              width: double.infinity,
              height: 280,
              borderRadius: BorderRadius.zero,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.radius),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  key: const ValueKey('meal_details_name'),
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    MetaPill(
                      icon: Icons.restaurant_menu_rounded,
                      label: meal.category,
                    ),
                    const SizedBox(width: 8),
                    MetaPill(icon: Icons.public_rounded, label: meal.area),
                    const Spacer(),
                    Text(
                      formatPrice(meal.price),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  context.l10n.instructions,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  meal.instructions.isEmpty
                      ? context.l10n.mealNotFound
                      : meal.instructions,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                  ),
                ),
                if (meal.tags.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: meal.tags
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            labelStyle: const TextStyle(fontSize: 12),
                            visualDensity: VisualDensity.compact,
                          ),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<FavouritesCubit, FavouritesState>(
                        builder: (context, state) {
                          final isSaved =
                              state is FavouritesLoaded &&
                              state.contains(meal.id);
                          return OutlinedButton.icon(
                            key: const ValueKey('save_favourite_button'),
                            onPressed: () => _toggleFavourite(context),
                            icon: Icon(
                              isSaved
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                            ),
                            label: Text(
                              isSaved
                                  ? context.l10n.removeFromFavourites
                                  : context.l10n.saveToFavourites,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        key: const ValueKey('details_add_to_cart_button'),
                        onPressed: () =>
                            context.read<CartBloc>().add(CartItemAdded(meal)),
                        icon: const Icon(Icons.add_shopping_cart_rounded),
                        label: Text(context.l10n.addToCart),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onCartChanged(BuildContext context, CartState state) {
    if (state is! CartUpdated || state.lastAdded == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          key: const ValueKey('details_add_to_cart_snackbar'),
          content: Text(
            context.trArgs('addedToCart', {'name': state.lastAdded!}),
          ),
        ),
      );
  }

  Future<void> _toggleFavourite(BuildContext context) async {
    final authState = context.read<AuthCubit>().state;
    final uid = authState is AuthAuthenticated ? authState.user.uid : '';

    final isSaved = await context.read<FavouritesCubit>().toggle(uid, meal);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          key: const ValueKey('details_favourite_snackbar'),
          content: Text(
            isSaved == null
                ? context.l10n.somethingWentWrong
                : (isSaved
                      ? context.l10n.savedToFavourites
                      : context.l10n.removedFromFavouritesMessage),
          ),
        ),
      );
  }

  static int _countOf(CartState state) =>
      state is CartUpdated ? state.itemCount : 0;
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/string_helpers.dart';
import '../../../domain/entities/meal_entity.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_state.dart';
import '../../blocs/favourites/favourites_cubit.dart';
import '../../blocs/favourites/favourites_state.dart';
import '../../extensions/l10n_extension.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/cart_badge.dart';
import '../../widgets/cart_line_action.dart';
import '../../widgets/meta_pill.dart';
import '../../widgets/semantic_id.dart';

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
      extendBody: true,
      appBar: AppBar(
        title: Text(context.l10n.mealDetails),
        actions: [
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
              height: 300,
              borderRadius: BorderRadius.zero,
            ),
          ),
          // The content card overlaps the photo so the screen reads as one
          // composed sheet instead of an image stacked on a text block.
          Transform.translate(
            offset: const Offset(0, -28),
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.cardDecoration(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    key: const ValueKey('meal_details_name'),
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  // The two pills share the line with the price, and a long
                  // category ("Seafood" in Arabic is markedly wider) pushed the
                  // row 44px past the edge. A `Wrap` lets the second pill drop
                  // to its own line while the price stays pinned to the end.
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.start,
                          children: [
                            MetaPill(
                              icon: Icons.restaurant_menu_rounded,
                              label: meal.category,
                            ),
                            MetaPill(
                              icon: Icons.public_rounded,
                              label: meal.area,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatPrice(meal.price),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  const SizedBox(height: 20),
                  Text(
                    context.l10n.instructions,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meal.instructions.isEmpty
                        ? context.l10n.noInstructions
                        : meal.instructions,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.75,
                      ),
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
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      // Fixed 52dp circle rather than a labelled button: the
                      // label ("Save to favourites") is a whole sentence, and
                      // sharing this row with the cart CTA squeezed it into a
                      // two-line "Sa v…" stub. The heart is the same glyph the
                      // cards use, so it needs no caption — the name goes to
                      // assistive technology instead.
                      BlocBuilder<FavouritesCubit, FavouritesState>(
                        builder: (context, state) {
                          final isSaved =
                              state is FavouritesLoaded &&
                              state.contains(meal.id);
                          return _FavouriteToggle(
                            isSaved: isSaved,
                            label:
                                '${isSaved ? context.l10n.removeFromFavourites : context.l10n.saveToFavourites} ${meal.name}',
                            onPressed: () => _toggleFavourite(context),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        // The CTA *is* the cart control: it adds the first
                        // serving, then grows into the same `+ count -`
                        // stepper the cards use, so the shopper never has to
                        // open the Cart to fix an order.
                        child: CartLineAction(meal: meal, large: true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
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

/// The heart on the details action row.
///
/// A fixed circle so it keeps the same footprint whatever the wording is — the
/// Arabic label is twice as long as the English one, and a labelled button made
/// the row jump between locales.
///
/// The 52dp box is imposed from *outside* on purpose. A `Row` hands its
/// non-flexible children unbounded width, and `OutlinedButton.styleFrom(fixedSize:)`
/// answers those constraints with an infinite one of its own, which throws in
/// `performLayout` and leaves the entire screen unpainted.
class _FavouriteToggle extends StatelessWidget {
  const _FavouriteToggle({
    required this.isSaved,
    required this.label,
    required this.onPressed,
  });

  final bool isSaved;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 52,
      height: 52,
      child: SemanticId(
        id: 'save_favourite_button',
        label: label,
        button: true,
        child: OutlinedButton(
          key: const ValueKey('save_favourite_button'),
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: const CircleBorder(),
            side: BorderSide(
              color: isSaved
                  ? AppColors.hotOffer.withValues(alpha: 0.5)
                  : theme.dividerColor,
            ),
          ),
          child: Icon(
            isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: isSaved ? AppColors.hotOffer : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

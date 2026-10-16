import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_categories.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_glass_tokens.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/meal_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_state.dart';
import '../../blocs/favourites/favourites_cubit.dart';
import '../../blocs/favourites/favourites_state.dart';
import '../../blocs/meals/meals_cubit.dart';
import '../../blocs/meals/meals_state.dart';
import '../../extensions/l10n_extension.dart';
import '../../widgets/app_error_view.dart';
import '../../widgets/app_search_field.dart';
import '../../widgets/cart_badge.dart';
import '../../widgets/home_feed_skeleton.dart';
import '../../widgets/hot_offer_card.dart';
import '../../widgets/language_toggle_button.dart';
import '../../widgets/meal_banner_page.dart';
import '../../widgets/meal_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/semantic_id.dart';
import '../../widgets/theme_toggle_button.dart';
import 'menu_search_sheet.dart';

/// The live menu feed — StreetBite's home screen.
///
/// Composed of exactly the sections in the Figma design:
/// location header -> search -> category chips -> featured `PageView` ->
/// Hot Offers strip -> meals `GridView`.
///
/// State management is split by responsibility rather than by screen:
/// * `MealsCubit`      -> the feed (this screen)
/// * `CartBloc`       -> shared with the AppBar badge and the Cart screen
/// * `FavouritesCubit`-> shared with the heart on every card
/// * `ThemeCubit`     -> shared with the AppBar toggle
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController(viewportFraction: 0.92);
  final _searchController = TextEditingController();

  int _bannerIndex = 0;
  Timer? _searchDebounce;

  /// `apiCategory` of the selected chip, or `null` for "show everything".
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<MealsCubit>().load();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  UserEntity get _user {
    final state = context.read<AuthCubit>().state;
    return state is AuthAuthenticated ? state.user : _anonymous;
  }

  /// Placeholder used only while the router is still settling; the Home screen
  /// is never reachable without an authenticated user.
  static const UserEntity _anonymous = UserEntity(uid: '', email: '');

  Future<void> _toggleFavourite(MealEntity meal) async {
    final isSaved = await context.read<FavouritesCubit>().toggle(
      _user.uid,
      meal,
    );
    if (!mounted || isSaved == null) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          key: const ValueKey('favourite_snackbar'),
          content: Text(
            isSaved
                ? context.l10n.savedToFavourites
                : context.l10n.removedFromFavouritesMessage,
          ),
        ),
      );
  }

  void _openMeal(MealEntity meal) {
    Navigator.of(context).pushNamed(AppRoutes.mealDetails, arguments: [meal]);
  }

  void _onSearchChanged(String value) {
    // Debounced so a fast typist triggers one filtered rebuild, not eight.
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() {});
    });
  }

  List<MealEntity> _filter(List<MealEntity> meals) {
    final category = AppCategory.byApiCategory(_selectedCategory);
    final query = _searchController.text.trim().toLowerCase();

    return meals.where((meal) {
      if (category != null && !category.matches(meal)) return false;
      if (query.isEmpty) return true;
      return meal.name.toLowerCase().contains(query) ||
          meal.category.toLowerCase().contains(query) ||
          meal.area.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;

    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is! CartUpdated) return;
        final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
        if (state.lastAdded != null) {
          messenger.showSnackBar(
            SnackBar(
              key: const ValueKey('add_to_cart_snackbar'),
              content: Text(
                context.trArgs('addedToCart', {'name': state.lastAdded!}),
              ),
            ),
          );
        } else if (state.justEmptied) {
          messenger.showSnackBar(
            SnackBar(content: Text(context.l10n.yourCartCleared)),
          );
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(user),
        extendBody: true,
        // The app bar already clears the top inset; `extendBody` hands the
        // bottom one to the feed so it paints behind the bar and the scroll
        // padding below keeps the last row reachable.
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<MealsCubit, MealsState>(
            builder: (context, state) {
              return switch (state) {
                MealsInitial() => const HomeFeedSkeleton(),
                MealsLoading() => const HomeFeedSkeleton(),
                MealsError(:final messageKey) => AppErrorView(
                  messageKey: messageKey,
                  onRetry: () =>
                      context.read<MealsCubit>().load(isRefresh: true),
                ),
                MealsLoaded(:final meals, :final hotOffers) => _buildFeed(
                  meals,
                  hotOffers,
                ),
              };
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(UserEntity user) {
    final firstName = user.displayName.split(' ').first;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      titleSpacing: 20,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            firstName.isEmpty ? context.l10n.appName : '$firstName.',
            key: const ValueKey('home_greeting'),
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontSize: 21),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 2),
              Text(
                context.l10n.deliveryAddress,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
      actions: [
        _appBarAction(child: const ThemeToggleButton()),
        // The EN/AR switch lives on every screen, not just Settings, so an
        // Arabic tester never has to leave the feed to change language.
        LanguageToggleButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(40, 40),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            backgroundColor: isDark
                ? AppColors.surfaceDark
                : AppColors.background,
            foregroundColor: isDark ? Colors.white : AppColors.primaryDark,
            side: const BorderSide(color: Colors.transparent),
            shadowColor: Colors.black.withValues(alpha: 0.08),
            elevation: 0,
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 8),
        _appBarAction(
          child: SemanticId(
            key: const ValueKey('open_map_button'),
            id: 'open_map_button',
            label: context.l10n.vendorMap,
            button: true,
            child: IconButton(
              tooltip: context.l10n.vendorMap,
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.vendorMap),
              icon: const Icon(Icons.map_outlined),
            ),
          ),
        ),
        _appBarAction(
          child: SemanticId(
            key: const ValueKey('open_cart_button'),
            id: 'open_cart_button',
            label: context.l10n.cart,
            button: true,
            child: IconButton(
              tooltip: context.l10n.cart,
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.cart),
              icon: CartBadge(child: const Icon(Icons.shopping_bag_outlined)),
            ),
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  /// Circular "pill" that unifies the AppBar's icon actions.
  Widget _appBarAction({required Widget child}) {
    final isGlass = AppGlassTokens.enabledOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsetsDirectional.only(end: 6),
      decoration: BoxDecoration(
        color: isGlass
            ? AppGlassTokens.wellColor(context)
            : isDark
            ? AppColors.surfaceDark
            : AppColors.background,
        shape: BoxShape.circle,
        border: isGlass
            ? Border.all(color: AppGlassTokens.wellBorder(context))
            : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: child,
    );
  }

  Widget _buildFeed(List<MealEntity> meals, List<MealEntity> hotOffers) {
    final visible = _filter(meals);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: () => context.read<MealsCubit>().load(isRefresh: true),
      child: CustomScrollView(
        key: const ValueKey('home_scroll_view'),
        slivers: [
          // ---- Search ----------------------------------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding(context),
              ),
              child: AppSearchField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                hintText: context.l10n.searchHint,
                fieldKeyName: 'home_search_field',
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        key: const ValueKey('home_search_clear'),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close_rounded, size: 18),
                      ),
              ),
            ),
          ),

          // ---- Category chips -------------------------------------------
          SliverToBoxAdapter(child: _buildCategories(isDark)),

          // ---- Featured PageView ----------------------------------------
          if (meals.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: SizedBox(
                height: 210,
                child: PageView.builder(
                  key: const ValueKey('home_banner_page_view'),
                  controller: _pageController,
                  itemCount: meals.take(5).length,
                  onPageChanged: (index) =>
                      setState(() => _bannerIndex = index),
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return MealBannerPage(
                      meal: meal,
                      isActive: index == _bannerIndex,
                      onTap: () => _openMeal(meal),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    meals.take(5).length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: index == _bannerIndex ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: index == _bannerIndex
                            ? Theme.of(context).colorScheme.primary
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],

          // ---- Hot Offers ------------------------------------------------
          if (hotOffers.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: SectionHeader(title: context.l10n.hotOffers),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 208,
                child: SemanticId(
                  key: const ValueKey('hot_offers_list'),
                  id: 'hot_offers_list',
                  label: context.l10n.hotOffers,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.horizontalPadding(context),
                    ),
                    itemCount: hotOffers.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final meal = hotOffers[index];
                      return HotOfferCard(
                        meal: meal,
                        discountPercent: 10 + index * 5,
                        onTap: () => _openMeal(meal),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],

          // ---- Meals grid ------------------------------------------------
          SliverToBoxAdapter(
            child: SectionHeader(
              title: _selectedCategory == null
                  ? context.l10n.recommended
                  : context.trKey(
                      AppCategory.byApiCategory(_selectedCategory)!.labelKey,
                    ),
              actionLabel: context.l10n.seeAll,
              onAction: () => showMenuSearchSheet(context, meals),
            ),
          ),
          if (visible.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.ramen_dining_rounded,
                        size: 56,
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        context.l10n.mealNotFound,
                        style: Theme.of(context).textTheme.bodyLarge
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding(context),
              ),
              sliver: SliverGrid(
                key: const ValueKey('meals_grid_view'),
                // Exposed to the automation suite as `resource-id`, so a test
                // can scroll to the grid without knowing pixel offsets.
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.mealGridColumns(context),
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  // 0.78 aspect ratio reproduces the tall card in the design.
                  childAspectRatio: 0.78,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final meal = visible[index];
                  return BlocBuilder<FavouritesCubit, FavouritesState>(
                    builder: (context, favState) => MealCard(
                      meal: meal,
                      isFavourite:
                          favState is FavouritesLoaded &&
                          favState.contains(meal.id),
                      onTap: () => _openMeal(meal),
                      onToggleFavourite: () => _toggleFavourite(meal),
                    ),
                  );
                }, childCount: visible.length),
              ),
            ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 32 + Responsive.bottomBarClearance(context),
            ),
          ),
        ],
      ),
    );
  }

  /// Circular category chips from the design (Chicken / Vegetarian / ...).
  ///
  /// Tapping a chip filters the meals grid below and tapping it again clears
  /// the filter. The chips read [AppCategory.all], the same table the Browse
  /// tab uses, so the two screens can never disagree about what a category
  /// means — and a chip that matches nothing yields the grid's empty state
  /// instead of pretending to work.
  Widget _buildCategories(bool isDark) {
    final isGlass = AppGlassTokens.enabledOf(context);
    return SizedBox(
      height: 104,
      child: ListView.separated(
        key: const ValueKey('category_chips_list'),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(
          Responsive.horizontalPadding(context),
          16,
          Responsive.horizontalPadding(context),
          0,
        ),
        itemCount: AppCategory.all.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = AppCategory.all[index];
          final isSelected = _selectedCategory == category.apiCategory;
          return SemanticId(
            id: 'category_chip_${category.apiCategory}',
            label: context.trKey(category.labelKey),
            button: true,
            child: InkWell(
              key: ValueKey('category_chip_${category.apiCategory}'),
              onTap: () => setState(
                () => _selectedCategory = isSelected
                    ? null
                    : category.apiCategory,
              ),
              borderRadius: BorderRadius.circular(32),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : isGlass
                          ? AppGlassTokens.wellColor(context)
                          : isDark
                          ? AppColors.surfaceDark
                          : AppColors.background,
                      shape: BoxShape.circle,
                      border: isGlass && !isSelected
                          ? Border.all(
                              color: AppGlassTokens.wellBorder(context),
                            )
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : isDark
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                    ),
                    child: Icon(
                      category.icon,
                      color: isSelected
                          ? Colors.white
                          : isGlass
                          ? Theme.of(context).colorScheme.onSurface
                          : AppColors.primaryDark,
                      size: 27,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.trKey(category.labelKey),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : isDark
                          ? Colors.white70
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

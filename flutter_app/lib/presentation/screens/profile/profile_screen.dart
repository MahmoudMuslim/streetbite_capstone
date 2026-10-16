import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/user_entity.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/favourites/favourites_cubit.dart';
import '../../blocs/favourites/favourites_state.dart';
import '../../blocs/locale/locale_cubit.dart';
import '../../blocs/locale/locale_state.dart';
import '../../blocs/orders/orders_cubit.dart';
import '../../blocs/orders/orders_state.dart';
import '../../blocs/profile/profile_cubit.dart';
import '../../blocs/profile/profile_state.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/theme/theme_state.dart';
import '../../extensions/l10n_extension.dart';
import '../../widgets/app_loading_view.dart';
import '../../widgets/app_error_view.dart';
import '../../widgets/info_row.dart';
import '../../widgets/order_history_tile.dart';
import '../../widgets/settings_row.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/language_toggle_button.dart';
import '../../widgets/profile_gate_button.dart';

/// Profile screen — reachable only after the biometric gate on the Home AppBar.
///
/// Shows everything the brief asks for:
/// * profile photo with a camera shortcut (`image_picker` -> Firestore)
/// * full name, e-mail
/// * device model + OS version (`device_info_plus`)
/// * live favourites and order history straight from Cloud Firestore
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      // Defensive: the router never sends an unauthenticated user here.
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.profile)),
        body: AppErrorView(messageKey: 'authSessionExpired'),
      );
    }

    return BlocProvider<ProfileCubit>(
      create: (_) => ProfileCubit(
        getDeviceInfo: GetIt.I(),
        pickAndUploadPhoto: GetIt.I(),
        user: authState.user,
      )..loadDeviceInfo(),
      child: _ProfileView(user: authState.user),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView({required this.user});

  final UserEntity user;

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  @override
  void initState() {
    super.initState();
    _loadOnce();
  }

  @override
  void didUpdateWidget(_ProfileView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user.uid != widget.user.uid) {
      _loadOnce();
    }
  }

  /// Loads both collections, shared by the two sections below.
  ///
  /// This used to be called straight from `build()`, which is a bug with two
  /// faces: every rebuild — including the one caused by the cubit emitting the
  /// result of this very call — fired the queries again, so the screen hammered
  /// Firestore continuously and any transient failure left a stale error view
  /// with no way back. Loading once per uid is both correct and cheaper.
  void _loadOnce() {
    final uid = widget.user.uid;
    // After the first frame: the cubits come from an ancestor provider, and
    // emitting during build would be illegal.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FavouritesCubit>().load(uid);
      context.read<OrdersCubit>().load(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.profile),
        actions: const [LanguageToggleButton(), SizedBox(width: 8)],
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.messageKey == null) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                key: const ValueKey('profile_snackbar'),
                content: Text(context.trKey(state.messageKey!)),
              ),
            );
          context.read<ProfileCubit>().consumeMessage();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Responsive.constrainWidth(
              context,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.horizontalPadding(context),
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _ProfileHeader(),
                    const SizedBox(height: 24),
                    const _SettingsSection(),
                    const SizedBox(height: 16),
                    _DeviceInfoCard(),
                    const SizedBox(height: 24),
                    _FavouritesSection(),
                    const SizedBox(height: 24),
                    _OrderHistorySection(),
                    const SizedBox(height: 24),
                    const _LogoutButton(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Avatar, name, e-mail and the camera shortcut.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final photoUrl = state.user.photoUrl;
        final firstName = state.user.displayName.split(' ').first;

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: AppTheme.cardDecoration(context),
          child: Row(
            children: [
              Stack(
                children: [
                  ProfileGateButton(
                    photoUrl: photoUrl,
                    // Already past the gate by the time this is on screen, and
                    // `onUnlocked` is a no-op - so a failure here must not present
                    // a dialog that appears to demand something and then does
                    // nothing. The off-ramp keeps the tap harmless.
                    bypassAllowed: true,
                    onUnlocked: () {},
                  ),
                  if (state.isUpdatingPhoto)
                    const Positioned.fill(
                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.4),
                        ),
                      ),
                    ),
                  // The camera shortcut sits on top of the avatar and bypasses
                  // the biometric gate: changing your own picture is not a
                  // sensitive read, and gating it would be pure friction.
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: GestureDetector(
                      key: const ValueKey('change_photo_button'),
                      onTap: () => _pickPhotoSource(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.photo_camera_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstName.isEmpty ? context.l10n.profile : '$firstName.',
                      key: const ValueKey('profile_display_name'),
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.user.email,
                      key: const ValueKey('profile_email'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickPhotoSource(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              key: const ValueKey('pick_from_gallery_option'),
              leading: const Icon(Icons.photo_library_rounded),
              title: Text(context.l10n.pickFromGallery),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
            ),
            ListTile(
              key: const ValueKey('take_photo_option'),
              leading: const Icon(Icons.photo_camera_rounded),
              title: Text(context.l10n.takePhoto),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (source != null) await cubit.changePhoto(source);
  }
}

/// Appearance + language rows, wired to the global cubits.
class _SettingsSection extends StatelessWidget {
  const _SettingsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            return Column(
              children: [
                SettingsRow(
                  icon: themeState.isDark
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  label: themeState.isDark
                      ? context.l10n.darkMode
                      : context.l10n.lightMode,
                  trailing: Switch(
                    key: const ValueKey('dark_mode_switch'),
                    value: themeState.isDark,
                    onChanged: (_) => context.read<ThemeCubit>().toggle(),
                  ),
                ),
                const SizedBox(height: 10),
                SettingsRow(
                  icon: Icons.translate_rounded,
                  label: context.l10n.language,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localeState.isArabic
                            ? context.l10n.arabic
                            : context.l10n.english,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 8),
                      const LanguageToggleButton(),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SettingsRow(
                  icon: Icons.map_outlined,
                  label: context.l10n.vendorMap,
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.vendorMap),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// Model + OS version read through `device_info_plus`.
class _DeviceInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(AppTheme.radius),
          decoration: AppTheme.cardDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.smartphone_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.deviceInformation,
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (state.isLoadingDevice)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: LinearProgressIndicator(),
                )
              else ...[
                InfoRow(
                  labelKey: 'deviceModel',
                  value: state.device.model,
                  valueKeyName: 'device_model_value',
                ),
                InfoRow(
                  labelKey: 'deviceOs',
                  value: state.device.osVersion,
                  valueKeyName: 'device_os_value',
                ),
                InfoRow(
                  labelKey: 'deviceName',
                  value: state.device.manufacturer,
                  valueKeyName: 'device_manufacturer_value',
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Favourites read live from Firestore.
class _FavouritesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouritesCubit, FavouritesState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.favourites,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            switch (state) {
              FavouritesInitial() || FavouritesLoading() => const SizedBox(
                height: 120,
                child: AppLoadingView(),
              ),
              FavouritesError(:final messageKey) => AppErrorView(
                messageKey: messageKey,
                icon: Icons.favorite_border_rounded,
              ),
              FavouritesLoaded(:final meals) when meals.isEmpty =>
                const EmptyStateView(
                  titleKey: 'favouritesEmpty',
                  bodyKey: 'favouritesEmptyBody',
                  icon: Icons.favorite_border_rounded,
                ),
              FavouritesLoaded(:final meals) => SizedBox(
                height: 150,
                child: ListView.separated(
                  key: const ValueKey('favourites_list'),
                  scrollDirection: Axis.horizontal,
                  itemCount: meals.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) =>
                      _FavouriteThumb(meal: meals[index]),
                ),
              ),
            },
          ],
        );
      },
    );
  }
}

/// Order history read live from Firestore.
class _OrderHistorySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.orderHistory,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            switch (state) {
              OrdersInitial() || OrdersLoading() => const SizedBox(
                height: 120,
                child: AppLoadingView(),
              ),
              OrdersError(:final messageKey) => AppErrorView(
                messageKey: messageKey,
                icon: Icons.receipt_long_rounded,
              ),
              OrdersLoaded() => _OrderList(orders: state),
            },
          ],
        );
      },
    );
  }
}

/// Renders the "Current" and "Past" blocks exactly like the Figma Orders tab.
class _OrderList extends StatelessWidget {
  const _OrderList({required this.orders});

  final OrdersLoaded orders;

  @override
  Widget build(BuildContext context) {
    if (orders.orders.isEmpty) {
      return const EmptyStateView(
        titleKey: 'orderHistoryEmpty',
        bodyKey: 'orderHistoryEmptyBody',
        icon: Icons.receipt_long_outlined,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (orders.active.isNotEmpty) ...[
          Text(
            context.l10n.current,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...orders.active.map((order) => OrderHistoryTile(order: order)),
        ],
        if (orders.past.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            context.l10n.past,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...orders.past.map((order) => OrderHistoryTile(order: order)),
        ],
      ],
    );
  }
}

class _FavouriteThumb extends StatelessWidget {
  const _FavouriteThumb({required this.meal});

  final dynamic meal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 110,
      padding: const EdgeInsets.all(6),
      decoration: AppTheme.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppNetworkImage(
            url: meal.thumbnailUrl as String,
            width: 98,
            height: 76,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 6),
          Text(
            meal.name as String,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      key: const ValueKey('logout_button'),
      onPressed: () async {
        await context.read<AuthCubit>().logout();
        if (!context.mounted) return;
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.error,
        side: BorderSide(color: AppColors.error.withValues(alpha: 0.4)),
      ),
      icon: const Icon(Icons.logout_rounded),
      label: Text(context.l10n.logout),
    );
  }
}

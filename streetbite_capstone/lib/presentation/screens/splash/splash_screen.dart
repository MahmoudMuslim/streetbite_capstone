import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/locale/locale_cubit.dart';
import '../../blocs/locale/locale_state.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../extensions/l10n_extension.dart';
import '../../router/app_router.dart';
import '../../widgets/language_toggle_button.dart';
import '../../widgets/streetbite_logo.dart';

/// Splash / onboarding screen shown at the very start of every launch.
///
/// Two jobs in one screen (a deliberate choice so the app never flashes an
/// empty frame):
/// 1. A fade-in logo over the brand gradient — the "fade-in animation" the
///    brief asks for — plus the Figma tagline and a "Get Started" CTA.
/// 2. Restoring the persisted session, then routing to Home or Login.
///
/// The session restore runs **in parallel** with the minimum display time, so a
/// slow Firebase handshake never lengthens the perceived launch.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  /// Minimum time the brand animation stays on screen before routing.
  static const Duration minimumDisplay = Duration(milliseconds: 2000);

  late final AnimationController _controller;
  late final Animation<double> _fade;

  /// `true` once the animation has had its minimum time on screen.
  bool _minDisplayElapsed = false;

  /// `null` until the session restore has produced a verdict.
  String? _pendingRoute;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();

    _startRestore();
    Future<void>.delayed(minimumDisplay, () {
      if (!mounted) return;
      setState(() => _minDisplayElapsed = true);
      _tryNavigate();
    });
  }

  Future<void> _startRestore() async {
    await context.read<AuthCubit>().restore();
    if (!mounted) return;
    setState(() => _pendingRoute = _routeFor(context.read<AuthCubit>().state));
    _tryNavigate();
  }

  /// Where a restored session is sent.
  ///
  /// A *gated* session goes to the scan screen, not the password form — landing
  /// on Login after the device had already accepted the credentials would make
  /// the whole opt-in invisible.
  static String _routeFor(AuthState state) => switch (state) {
    AuthAuthenticated() => AppRoutes.home,
    AuthBiometricGate() => AppRoutes.biometricLogin,
    _ => AppRoutes.login,
  };

  /// Navigates only when *both* gates are open — the animation finished and
  /// the session verdict arrived — so the user never sees a half-built screen.
  void _tryNavigate() {
    final route = _pendingRoute;
    if (!_minDisplayElapsed || route == null || !mounted) return;

    // Fade-transition into the destination, as specified for the sign-up flow.
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, _, _) => AppRouter.resolve(RouteSettings(name: route)),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = Responsive.isCompact(context);

    return Scaffold(
      extendBody: true,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.splashTop, AppColors.splashBottom],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, localeState) {
              return Stack(
                children: [
                  Column(
                    children: [
                      // Top area holds the mark, mirroring the Figma layout.
                      Expanded(
                        flex: 45,
                        child: FadeTransition(
                          opacity: _fade,
                          child: const Center(child: StreetBiteLogo(size: 132)),
                        ),
                      ),
                      Expanded(
                        flex: 55,
                        child: Responsive.constrainWidth(
                          context,
                          child: FadeTransition(
                            opacity: _fade,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                horizontal: isCompact ? 32 : 64,
                                vertical: 8,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    context.l10n.appName,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    context.l10n.onboardingTitle,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: Colors.white,
                                          height: 1.2,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    context.l10n.onboardingBody,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white.withValues(
                                            alpha: 0.92,
                                          ),
                                        ),
                                  ),
                                  const SizedBox(height: 28),
                                  SizedBox(
                                    width: double.infinity,
                                    child: FilledButton(
                                      key: const ValueKey('get_started_button'),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: AppColors.primaryDark,
                                      ),
                                      onPressed: () {
                                        _minDisplayElapsed = true;
                                        _tryNavigate();
                                      },
                                      child: Text(context.l10n.getStarted),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // The language toggle is always reachable, even on the
                  // splash, so an Arabic tester never lands on an English
                  // first frame.
                  PositionedDirectional(
                    top: 8,
                    end: 12,
                    child: LanguageToggleButton(
                      onDarkBackground: true,
                      style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                        side: WidgetStatePropertyAll(
                          BorderSide(
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

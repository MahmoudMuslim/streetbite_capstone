import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streetbite_capstone/core/theme/app_theme.dart';
import 'package:streetbite_capstone/core/theme/app_theme_mode.dart';
import 'package:streetbite_capstone/l10n/generated/app_localizations.dart';
import 'package:streetbite_capstone/presentation/blocs/theme/theme_cubit.dart';
import 'package:streetbite_capstone/presentation/widgets/theme_options_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Pumps the sheet the way production does: `ThemeCubit` above `MaterialApp`,
  /// so the route pushed by `showModalBottomSheet` still resolves it.
  Future<ThemeCubit> pumpSheet(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final cubit = ThemeCubit(await SharedPreferences.getInstance());
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [BlocProvider<ThemeCubit>.value(value: cubit)],
        child: MaterialApp(
          theme: AppTheme.light,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showThemeOptionsSheet(context),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    return cubit;
  }

  testWidgets('shows every appearance as its own option', (tester) async {
    await pumpSheet(tester);

    for (final mode in AppThemeMode.values) {
      expect(
        find.byKey(ValueKey('theme_sheet_option_${mode.name}')),
        findsOneWidget,
      );
    }
  });

  testWidgets(
    'picking an appearance applies it, persists it and keeps the sheet open',
    (tester) async {
      final cubit = await pumpSheet(tester);

      await tester.tap(
        find.byKey(const ValueKey('theme_sheet_option_glassDark')),
      );
      await tester.pumpAndSettle();

      expect(cubit.state.mode, AppThemeMode.glassDark);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(ThemeCubit.storageKey), 'glassDark');
      // Comparing looks is the point of the sheet, so it must not dismiss itself.
      expect(
        find.byKey(const ValueKey('theme_sheet_option_light')),
        findsOneWidget,
      );
    },
  );

  testWidgets('marks exactly the active appearance', (tester) async {
    final cubit = await pumpSheet(tester);

    await tester.tap(find.byKey(const ValueKey('theme_sheet_option_dark')));
    await tester.pumpAndSettle();

    expect(cubit.state.mode, AppThemeMode.dark);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(3));
  });
}

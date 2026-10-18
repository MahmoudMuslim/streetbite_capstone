import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// App-wide defaults for the Liquid Glass renderer.
///
/// Centralised so every glass surface in StreetBite shares one blur/thickness
/// recipe instead of each widget guessing — the same reason [AppColors] exists
/// for the Material themes.
///
/// [GlassQuality.standard] is chosen deliberately over `premium`: most glass in
/// this app sits inside scrollable feeds, where the lightweight shader keeps the
/// list at 60fps on mid-range Android hardware. `adaptiveQuality` in
/// `LiquidGlassWidgets.wrap` still promotes individual devices that can afford
/// more.
class AppGlassTheme {
  const AppGlassTheme._();

  static GlassThemeData get data => GlassThemeData.simple(
    blur: 12,
    thickness: 32,
    quality: GlassQuality.standard,
    saturation: 1.4,
  );
}

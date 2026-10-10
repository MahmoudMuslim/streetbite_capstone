# Keep the Flutter engine's entry points.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Play Services / Maps and Firebase models are resolved reflectively.
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Play Core is referenced by the in-app update flow but unused at runtime.
-dontwarn com.google.android.play.core.**

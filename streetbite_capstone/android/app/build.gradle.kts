import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// ---- Local, never-committed configuration ----------------------------------
// Copy `key.properties.example` to `key.properties` and fill in the Maps key.
val localProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}

// START: FlutterFire Configuration
// The Google Services plugin hard-fails when `google-services.json` is missing,
// which would make a fresh clone un-buildable. Applying it only when the file
// is present keeps `flutter run` working for every contributor, while a real
// Firebase project switches it on automatically.
if (file("google-services.json").exists()) {
    apply(plugin = "com.google.gms.google-services")
}
// END: FlutterFire Configuration

android {
    // Matches the Android app registered in `google-services.json`.
    namespace = "com.example.streetbite_capstone"
    // Several bundled plugins (maps, image_picker, local_auth, ...) already
    // target SDK 36; compiling against the highest keeps them backward
    // compatible with our own minSdk.
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.example.streetbite_capstone"
        // `local_auth` requires 23+; 24 is the practical floor for Play
        // integrity checks on a 2026 release build.
        minSdk = 24
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Consumed by the `MAPS_API_KEY` placeholder in AndroidManifest.xml.
        manifestPlaceholders["MAPS_API_KEY"] =
            localProperties.getProperty("MAPS_API_KEY", "")
    }

    buildTypes {
        release {
            // Replace with a real upload key before publishing:
            //   keytool -genkey -v -keystore ~/streetbite-upload.jks ...
            // Debug keys keep `flutter build apk --release` working out of the
            // box for the Firebase App Distribution upload.
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    signingConfigs {
        getByName("debug") {
            storeFile = file("/Users/shinodamike/GitHub/onelink-hino_sa-flutter_mobile/hnza.jks")
            storePassword = "@n3L!nkdev"
            keyAlias = "hnza-key"
            keyPassword = "P@ssw0rD"
        }
        create("release") {
            storeFile = file("/Users/shinodamike/GitHub/onelink-hino_sa-flutter_mobile/hnza.jks")
            storePassword = "@n3L!nkdev"
            keyAlias = "hnza-key"
            keyPassword = "P@ssw0rD"
        }
    }
    namespace = "com.onelink.hnza"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.onelink.hnza"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        signingConfig = signingConfigs.getByName("release")
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

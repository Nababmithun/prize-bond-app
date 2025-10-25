plugins {
    id("com.android.application")
    // Use the official Kotlin Android plugin id for KTS:
    id("org.jetbrains.kotlin.android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "tss.com.bond_notifier_app"

    // Let Flutter manage these SDK versions
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // Use Java 17 with recent AGP/Flutter (recommended)
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "tss.com.bond_notifier_app"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // If you hit 65K method refs in the future, uncomment:
        // multiDexEnabled = true
    }

    buildTypes {
        release {
            // TODO: replace with your real release signing config when ready.
            // Using debug keystore so that `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")

            // Typical proguard setup if you add minify later:
            // isMinifyEnabled = true
            // proguardFiles(
            //     getDefaultProguardFile("proguard-android-optimize.txt"),
            //     "proguard-rules.pro"
            // )
        }
        debug {
            // debug-specific options if needed
        }
    }

    // Optional: if you face META-INF conflicts later, you can use:
    // packaging {
    //     resources {
    //         excludes += setOf(
    //             "META-INF/DEPENDENCIES",
    //             "META-INF/INDEX.LIST",
    //             "META-INF/*.kotlin_module"
    //         )
    //     }
    // }
}

flutter {
    source = "../.."
}

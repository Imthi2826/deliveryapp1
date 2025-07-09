plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // ✅ correct plugin id
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // ✅ No need to apply() separately when included here
}

android {
    namespace = "com.example.deliveryapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.deliveryapp"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties if present for release signing
val keystorePropertiesFile = rootProject.file("keystore.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}

android {
    namespace = "com.cabelloenrique.boby"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion
    
    // Habilitar buildConfig para campos personalizados
    buildFeatures {
        buildConfig = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.cabelloenrique.boby"
        minSdk = flutter.minSdkVersion  // Android 4.4 KitKat para máxima compatibilidad con Fire OS
        targetSdk = 33  // Android 13
        versionCode = flutter.versionCode.toInt()
        versionName = flutter.versionName
        
        // Configuración para Amazon Appstore y Fire Tablets
        // Nota: No usamos abiFilters aquí para evitar conflictos con splits
        
        // Asegurar compatibilidad con pantallas grandes
        resConfigs("en", "es")
        resValue("string", "app_name", "Boby")
        
        // Configuración específica para Fire OS
        buildConfigField("boolean", "IS_AMAZON", "true")
        
        // Asegurar compatibilidad con Fire TV y Fire Tablets
        manifestPlaceholders["amzn_scheme"] = "amzn"
        
        // Especificar que es compatible con tablets
        resValue("bool", "isTablet", "true")
        
        // Habilitar soporte para pantallas grandes
        resValue("bool", "isLargeLayout", "true")
        
        // Configuración específica para tablets Fire
        resValue("integer", "min_tablet_width_dp", "600")
        
        // Habilitar soporte para múltiples ventanas
        resValue("bool", "supports_picture_in_picture", "false")
        
        // Configuración de compatibilidad con pantallas
        resValue("bool", "isWideColorGamut", "false")
    }

    signingConfigs {
        create("release") {
            val storePath = keystoreProperties.getProperty("storeFile")
            if (!storePath.isNullOrBlank()) {
                storeFile = file(storePath)
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
        
        // Amazon release config (can use the same keystore or a different one)
        create("amazonRelease") {
            val storePath = keystoreProperties.getProperty("storeFile")
            if (!storePath.isNullOrBlank()) {
                storeFile = file(storePath)
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    // Simplified configuration for release build
    splits {
        abi {
            isEnable = true
            reset()
            include("armeabi-v7a", "arm64-v8a")
            isUniversalApk = true  // Generate a universal APK
        }
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("amazonRelease")
            isMinifyEnabled = false  // Desactivar minify para evitar problemas con R8
            isShrinkResources = false
            isCrunchPngs = true
            
            // Configuración de ProGuard para Fire OS
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            
            // Configuración de rendimiento
            isDebuggable = false
            isJniDebuggable = false
            isRenderscriptDebuggable = false
            renderscriptOptimLevel = 3
            
            // Configuración específica para Amazon Appstore
            buildConfigField("boolean", "AMAZON_STORE", "true")
        }
    }
}

flutter {
    source = "../.."
}

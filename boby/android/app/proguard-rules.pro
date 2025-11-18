# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Amazon Fire Tablet specific
-keep class com.amazon.** { *; }
-keep class com.amazon.device.** { *; }
-keep class com.amazon.identity.** { *; }
-keep class com.amazon.insights.** { *; }
-keep class com.amazon.mas.kiwi.** { *; }

# Keep - Applications. If your project is an application project, keep the Application class
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference

# Keep - View bindings and click listeners
-keepclassmembers class * {
    @android.view.View$OnClickListener *;
    @android.view.View$OnTouchListener *;
}

# Keep - Keep attributes
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keepattributes InnerClasses

# If you are using custom views, uncomment the following line
#-keep public class * extends android.view.View

# Uncomment to preserve the line number information for debugging stack traces
-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to hide the original source file name
#-renamesourcefileattribute SourceFile

# Keep - Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep - Keep setters in Views so that animations can still work
-keepclassmembers public class * extends android.view.View {
   void set*(***);
   *** get*();
}

# Keep - Keep R (resources)
-keepclassmembers class **.R$* {
    public static <fields>;
}

# Keep - Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# Keep - Keep Serializable implementations
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep - Keep the special static methods that are required in all enumeration classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep - Keep the support library
-keep class android.support.v4.app.** { *; }
-keep interface android.support.v4.app.** { *; }
-keep class androidx.** { *; }
-keep interface androidx.** { *; }

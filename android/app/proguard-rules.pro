## ProGuard rules for Flutter/Android app
# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep Google Play Core (deferred components / split install)
-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep Kotlin metadata
-keep class kotlin.** { *; }
-keep class kotlin.coroutines.** { *; }
-keep class kotlinx.** { *; }

# Keep generated registrant
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# Keep application and activities
-keep class **.MainActivity { *; }
-keep class **.MainApplication { *; }

# Keep enums and parcelables
-keepclassmembers enum * { *; }
-keepclassmembers class * implements android.os.Parcelable { static ** CREATOR; }


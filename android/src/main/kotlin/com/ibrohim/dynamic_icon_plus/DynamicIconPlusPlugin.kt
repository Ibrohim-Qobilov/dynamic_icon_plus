package com.ibrohim.dynamic_icon_plus

import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** DynamicIconPlusPlugin */
class DynamicIconPlusPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dynamic_icon_plus")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "supportsAlternateIcons" -> {
                result.success(true)
            }
            "getAlternateIconName" -> {
                val current = getCurrentIconName()
                result.success(current)
            }
            "getAvailableIcons" -> {
                val icons = getAvailableIconNames()
                result.success(icons)
            }
            "setAlternateIconName" -> {
                val iconName = call.argument<String?>("iconName")
                try {
                    setIcon(iconName)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("SET_ICON_FAILED", e.message, null)
                }
            }
            "resetToDefault" -> {
                try {
                    setIcon(null)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("RESET_ICON_FAILED", e.message, null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun getAvailableIconNames(): List<String> {
        val pm = context.packageManager
        val packageName = context.packageName
        val iconList = mutableListOf<String>()

        try {
            val packageInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                pm.getPackageInfo(packageName, PackageManager.PackageInfoFlags.of(PackageManager.GET_ACTIVITIES.toLong()))
            } else {
                @Suppress("DEPRECATION")
                pm.getPackageInfo(packageName, PackageManager.GET_ACTIVITIES)
            }

            packageInfo.activities?.forEach { activityInfo ->
                val name = activityInfo.name
                // Check if this activity is an alias for icon switching
                if (name.contains("MainActivity") && name != "$packageName.MainActivity") {
                    val iconName = name.substringAfterLast("MainActivity.")
                        .ifEmpty { name.substringAfterLast(".") }
                    if (iconName.isNotEmpty() && !iconName.equals("MainActivity", ignoreCase = true) && !iconName.equals("default", ignoreCase = true)) {
                        iconList.add(iconName)
                    }
                }
            }
        } catch (e: Exception) {
            // Fallback empty list
        }

        return iconList
    }

    private fun getCurrentIconName(): String? {
        val pm = context.packageManager
        val packageName = context.packageName
        val icons = getAvailableIconNames()

        for (icon in icons) {
            val componentName = ComponentName(packageName, "$packageName.MainActivity.$icon")
            val state = pm.getComponentEnabledSetting(componentName)
            if (state == PackageManager.COMPONENT_ENABLED_STATE_ENABLED) {
                return icon
            }
        }

        return null // Default icon is active
    }

    private fun setIcon(targetIconName: String?) {
        val pm = context.packageManager
        val packageName = context.packageName
        val defaultComponent = ComponentName(packageName, "$packageName.MainActivity")
        val availableIcons = getAvailableIconNames()

        if (targetIconName.isNullOrEmpty()) {
            // Enable default MainActivity
            pm.setComponentEnabledSetting(
                defaultComponent,
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                PackageManager.DONT_KILL_APP
            )

            // Disable all alternate activity-aliases
            for (icon in availableIcons) {
                val component = ComponentName(packageName, "$packageName.MainActivity.$icon")
                pm.setComponentEnabledSetting(
                    component,
                    PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                    PackageManager.DONT_KILL_APP
                )
            }
        } else {
            // Enable target alternate alias
            val targetComponent = ComponentName(packageName, "$packageName.MainActivity.$targetIconName")
            pm.setComponentEnabledSetting(
                targetComponent,
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                PackageManager.DONT_KILL_APP
            )

            // Disable default MainActivity
            pm.setComponentEnabledSetting(
                defaultComponent,
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                PackageManager.DONT_KILL_APP
            )

            // Disable other alternate aliases
            for (icon in availableIcons) {
                if (icon != targetIconName) {
                    val component = ComponentName(packageName, "$packageName.MainActivity.$icon")
                    pm.setComponentEnabledSetting(
                        component,
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP
                    )
                }
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}

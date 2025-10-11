package com.deepershort.deeplink_app_listener


import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** DeeplinkAppListnerPlugin */
class DeeplinkAppListnerPlugin : FlutterPlugin,
    MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler,
    ActivityAware {

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    private var initialLink: String? = null
    private var activityBinding: ActivityPluginBinding? = null

    private val mainHandler = Handler(Looper.getMainLooper())
    private val TAG = "DeeplinkAppListener"

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(binding.binaryMessenger, "deeplink_listener")
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(binding.binaryMessenger, "deeplink_listener/events")
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "getInitialLink" -> result.success(initialLink)
            else -> result.notImplemented()
        }
    }

    // 👇 Event Channel
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        // Optional: send the initial link immediately when listener attaches
        initialLink?.let {
            mainHandler.post { eventSink?.success(it) }
        }
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    // 👇 Activity lifecycle handling
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        binding.addOnNewIntentListener { intent ->
            handleIntent(intent)
            false
        }
        handleIntent(binding.activity.intent) // Handle cold start
    }

    override fun onDetachedFromActivity() {
        activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    // 👇 Handle deep link from Intent
    private fun handleIntent(intent: Intent?) {
        if (intent == null) return

        val uri: Uri? = intent.data
        if (uri != null) {
            val link = sanitizeLink(uri.toString())
            Log.d(TAG, "Received deep link: $link")

            if (initialLink == null) {
                initialLink = link
            }
            mainHandler.post {
                eventSink?.success(link)
            }
        }
    }

    // 👇 Optional: Clean or normalize the deep link
    private fun sanitizeLink(link: String): String {
        // Example: remove trailing slashes
        return link.trim().removeSuffix("/")
    }
}

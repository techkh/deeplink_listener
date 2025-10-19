import Flutter
import UIKit

@objc public class DeeplinkListenerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {

    // Singleton instance
    public static let shared = DeeplinkListenerPlugin()

    private var eventSink: FlutterEventSink?
    private var initialLink: String?
    private var pendingLinks: [String] = []

    // MARK: - Plugin Registration
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = DeeplinkListenerPlugin.shared

        // Method channel
        let methodChannel = FlutterMethodChannel(
            name: "deeplink_listener",
            binaryMessenger: registrar.messenger()
        )
        registrar.addMethodCallDelegate(instance, channel: methodChannel)

        // Event channel
        let eventChannel = FlutterEventChannel(
            name: "deeplink_listener/events",
            binaryMessenger: registrar.messenger()
        )
        eventChannel.setStreamHandler(instance)

        registrar.addApplicationDelegate(instance)
    }

    // MARK: - Method calls
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getInitialLink":
            result(initialLink)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Event channel
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events

        // Send any pending links
        for link in pendingLinks {
            events(link)
        }
        pendingLinks.removeAll()

        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    // MARK: - Handle URL
    private func handleLink(_ url: URL) {
        let link = url.absoluteString

        if initialLink == nil {
            initialLink = link
        }

        if let sink = eventSink {
            sink(link)
        } else {
            pendingLinks.append(link)
        }
    }

    // MARK: - Public methods for AppDelegate forwarding
    public static func handleUserActivity(_ userActivity: NSUserActivity) {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let url = userActivity.webpageURL {
            shared.handleLink(url)
        }
    }

    public static func handleOpenURL(_ url: URL) {
        shared.handleLink(url)
    }
}

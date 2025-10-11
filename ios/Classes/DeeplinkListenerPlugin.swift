import Flutter
import UIKit

public class DeeplinkListenerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  var eventSink: FlutterEventSink?
  var initialLink: String?
  var pendingLinks: [String] = []

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = DeeplinkListenerPlugin()

    let channel = FlutterMethodChannel(name: "deeplink_listener",
                                       binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: channel)

    let eventChannel = FlutterEventChannel(name: "deeplink_listener/events",
                                           binaryMessenger: registrar.messenger())
    eventChannel.setStreamHandler(instance)

    registrar.addApplicationDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getInitialLink":
      result(initialLink)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  @objc public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events

    for link in pendingLinks {
      events(link)
    }
    pendingLinks.removeAll()

    return nil
  }

  @objc public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }

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

  public func application(_ application: UIApplication,
                          open url: URL,
                          options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    handleLink(url)
    return true
  }

  public func application(_ application: UIApplication,
                          continue userActivity: NSUserActivity,
                          restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let url = userActivity.webpageURL {
      handleLink(url)
      return true
    }
    return false
  }
}

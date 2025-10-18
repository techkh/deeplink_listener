# deeplink_listener

[![Pub Package](https://img.shields.io/pub/v/deeplink_listener.svg?style=flat-square)](https://pub.dev/packages/deeplink_listener)

## Features

### deeplink_listener : 
Handling Custom Deep Links and Universal Links
Deep linking allows your app to respond to links, whether they come from emails, websites, or other apps. There are two main types:

- Custom URL Schemes – Works on both iOS and Android for listen custom deeplink.
- Universal Links / App Links both IOS and Anroid for listen Universal Links.

## Befor use
if you are using Universal links  your must be config you servr support IOS and Android handle deeplink
Android to create https://youserveer.com/.well-known/assetlinks.json
```yaml
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.yourdomain.app",
      "sha256_cert_fingerprints": ["YOUR_APP_SHA256_FINGERPRINT"]
    }
  }
]
```
IOS to create https://yourdomain.com/.well-known/apple-app-site-association
```yaml
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "teamId.com.yourdomain.app",
        "paths": [ "/apple-login-callback", "/callback/*" ]
      }
    ]
  }
}
```
## Updated AppDelegate for IOS
```yaml
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Forward universal link calls to Flutter plugins
  override func application(_ application: UIApplication,
                              continue userActivity: NSUserActivity,
                              restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
  }

  override func application(_ app: UIApplication,
                              open url: URL,
                              options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return super.application(app, open: url, options: options)
  }
}
```
## Usage

Make sure to check out [examples](https://github.com/techkh/deeplink_listener/tree/prod/example)


### Installation

Add the following line to `pubspec.yaml`:

```yaml
dependencies:
  deeplink_listener: ^1.0.3
```

### Basic setup

The complete example is available [here](https://github.com/techkh/deeplink_listener/tree/prod/example/lib).

```dart
create your _linkSub  
StreamSubscription<String>? _linkSub;
String _deeplinkResult = 'Unknown';
```

&#11088; Initial cold start 
- Get first time app never open and not active.
```dart
DeeplinkListener.getInitialLink().then((link) {
      print('[Dart] getInitialLink: $link');
      if (link != null) _handleDeepLink(link);
});
```
&#11088; Stream for incoming links
-  Get all time when app live and in background.
```dart
 _linkSub = DeeplinkListener.linkStream.listen(
      (link) {
        print('[Dart] linkStream received: $link');
        _handleDeepLink(link);
      },
      onError: (err) {
        print('[Dart] linkStream error: $err');
      },
);
```

### Funtion Handller
```dart
  // Example handler
  void _handleDeepLink(String link) {
    // Do something with the link (e.g., navigation)
    setState(() {
      _deeplinkResult = link;
    });
    print("Handling deep link: $link");
  }
```
### Note Don't forget cancel _linkSub before your view dispose 
```dart
@override
void dispose() {
    _linkSub?.cancel();
    super.dispose();
}
```

### Deeplink Config See 
1. [Andoid Deeplink](https://github.com/techkh/deeplink_listener/blob/prod/example/android/app/src/main/AndroidManifest.xml)

2. [IOS Deeplink](https://github.com/techkh/deeplink_listener/blob/prod/example/ios/Runner/Info.plist)

### how to run Testing in local
Make sure you config all 
1. Android can run  adb by add  echo 'export PATH="$PATH:/Users/nemo/Library/Android/sdk/platform-tools"' >> ~/.zprofile, your .zsrc
```dart

//Check your device has been link 
 adb devices   
//Open Custom deeplink
adb shell am start -a android.intent.action.VIEW -d "myapp://open"
//Open Universal Links
 adb shell am start -a android.intent.action.VIEW -d "link.yourdomain.com"

```

2. IOS no need you just : Open browser safari 
```dart
//Open Custom deeplink
myapp://
//Open Universal Links
https://link.deepershort.com
```


Hello everyone 👋

If you want to support me, feel free to do so. 

Thanks

============================================

សួស្ដី អ្នកទាំងអស់គ្នា👋 

បើ​អ្នក​ចង់​គាំទ្រ​ខ្ញុំ សូម​ធ្វើ​ដោយ​សេរី , 

សូមអរគុណ

<a  href="https://www.buymeacoffee.com/kdrtech" target="_blank">
<img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" height="41" />
</a>
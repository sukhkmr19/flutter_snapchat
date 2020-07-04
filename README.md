# snapchat_flutter_plugin

A plugin for snapchat Login. Please make some changes to work this
plugin

Step 1 

        please go to https://kit.snapchat.com/portal/ and make your app register
        there and get the redirect url and your snap chat client for android and
        ios

Step 2 

**For Android**
 
        Make some changes in android manifest and other like

In android manifest 


        <meta-data
            android:name="com.snapchat.kit.sdk.clientId"
            android:value=“your client id” />
        <meta-data
            android:name="com.snapchat.kit.sdk.redirectUrl"
            android:value=“your redirect url“ />
        <meta-data
            android:name="com.snapchat.kit.sdk.scopes"
            android:resource="@array/snap_connect_scopes" /> <!-- This should be a string array of scopes !-->

        <activity android:name="com.snapchat.kit.sdk.SnapKitActivity"
          android:launchMode="singleTask">
 
        <intent-filter>

        <actionandroid:name="android.intent.action.VIEW" />

        <category android:name="android.intent.category.DEFAULT" />
        
        <category android:name="android.intent.category.BROWSABLE" />

        <data
            android:host=“your host from redirect url” //sanp-chat
            android:path=“your path“ // /oauth2
            android:scheme=“your scheme” /> //snapChat
    </intent-filter>

    </activity>



App gradle inside dependencies


        implementation([
        'com.snapchat.kit.sdk:login:1.1.4',
        'com.snapchat.kit.sdk:core:1.1.4'
        ])

Build gradle inside all projects

       allprojects{
       repositories{
        maven {
              url "https://raw.githubusercontent.com/Snap-Kit/release-maven/repo"
            }
          }
        }

Values folder make an array.xml and paste below

    <?xml version="1.0" encoding="utf-8"?>
    <resources>
        <string-array name="snap_connect_scopes">
            <item>https://auth.snapchat.com/oauth2/api/user.bitmoji.avatar</item>
            <item>https://auth.snapchat.com/oauth2/api/user.external_id</item>
            <item>https://auth.snapchat.com/oauth2/api/user.display_name</item>
        </string-array>
    </resources>

Step 3 

**For iOS**
 
     Requirements
        •	Client ID from the developer portal
        •	iOS version 10.1+

 Make changes in your info plist
 
 In AppDelegate please add 
 
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return SCSDKLoginClient.application(app, open: url, options: options)
    }

 please add in pod file
 
     pod 'SnapSDK'

Info.plist

    <key>SCSDKRedirectUrl</key>
    <string>your redirect url</string>
    
    <key>SCSDKClientId</key>
    <string>your client id</string>
        suppose your redirect url is myapp://snap-kit/oauth2
    
    
    <key>CFBundleURLTypes</key>
    <array>
            <dict>
                <key>CFBundleTypeRole</key>
                <string>Editor</string>
                <key>CFBundleURLSchemes</key>
                <array>
                    <string>myapp</string>
                    <string>snap-kit</string>
                    <string>oauth2</string>
                </array>
            </dict>
        </array>
    
    <key>LSApplicationQueriesSchemes</key>
        <array>
            <string>snapchat</string>
            <string>bitmoji-sdk</string>
            <string>itms-apps</string>
        </array>
    
    <key>SCSDKScopes</key>
        <array>
            <string>https://auth.snapchat.com/oauth2/api/user.external_id</string>
            <string>https://auth.snapchat.com/oauth2/api/user.display_name</string>
            <string>https://auth.snapchat.com/oauth2/api/user.bitmoji.avatar</string>
        </array>

Step 4

To use it 

For Login just call 

    SnapchatFlutterPlugin.snapchatLogin.then((onValue) {
        // cast onvalue to the map of string , dynamic 
      });

In return you get the map for the data of name, id an pic cast it as a
dynamic if you get success then return map else it will return String if
any issue found.

For Logout

    await SnapchatFlutterPlugin.snapchatLogout;

return type is dynamic

Thanks https://github.com/palkerecsenyi for removing the deprecated method.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.io/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

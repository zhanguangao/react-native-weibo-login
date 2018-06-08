
# react-native-weibo-login

## Getting started

`$ npm install react-native-weibo-login --save`

### Mostly automatic installation

`$ react-native link react-native-weibo-login`

### Manual installation


#### iOS

1. Add `node_modules/react-native-weibo-login/ios/WeiboSDK.bundle` in you project, or else it will be crash.
2. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`, Go to `node_modules` ➜ `react-native-weibo-login` and add `RCTWeiBo.xcodeproj`.
3. In XCode, in the project navigator, select your project.
    
    Add
    - libRCTWeiBo.a
    - QuartzCore.framework
    - ImageIO.framework
    - SystemConfiguration.framework
    - Security.framework
    - CoreTelephony.framework
    - CoreText.framework
    - UIKit.framework
    - Foundation.framework
    - CoreGraphics.framework 
    - Photos.framework
    - libz.tbd
    - libsqlite3.tbd
    
    to your project's `Build Phases` ➜ `Link Binary With Libraries`.
4.  In the project navigator, in `Targets` ➜ `info` ➜ `URL types`. Add new URL type, `Identifier` value is `com.weibo`, `URL Schemes` value is `wb` + `you weibo appKey`, such as: `wb2317411734`.
5. Right click `Info.plist` open as source code, insert the following lines:
    ```xml
    <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>sinaweibohd</string>
        <string>weibosdk</string>
        <string>sinaweibo</string>
        <string>weibosdk2.5</string>
    </array>
    ```
6.  Copy the following in `AppDelegate.m`:
```
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
  return [RCTLinkingManager application:application openURL:url
                            sourceApplication:sourceApplication annotation:annotation];
}
```

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.gratong.WeiBoPackage;` to the imports at the top of the file.
  - Add `new WeiBoPackage()` to the list returned by the `getPackages()` method.
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-weibo-login'
  	project(':react-native-weibo-login').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-weibo-login/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-weibo-login')
  	```
4. Insert the following lines inside the allprojects block in `android/build.gradle`:
  	```
      maven { url "https://dl.bintray.com/thelasterstar/maven/" }
  	```
	such as:
	```
	allprojects {
       repositories {
          mavenLocal()
          jcenter()
          maven { url "https://dl.bintray.com/thelasterstar/maven/" }
        }
	}
	```
}


## Usage
```javascript
import * as WeiBo from 'react-native-weibo-login';

 // 设置登录参数 
let config = {
    appKey:"2317411734",
    scope: 'all',       
    redirectURI: 'https://api.weibo.com/oauth2/default.html',
}

WeiBo.login(config)
    .then(res=>{  
        console.log('login success:',res)
    }).catch(err=>{ 
        console.log('login fail:',err)
})
```
  
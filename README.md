# cordova-plugin-ios-shareextension

#### Usage

> cordova plugin add cordova-plugin-ios-shareextension --variable IOS_GROUP_IDENTIFIER=IOS_GROUP_IDENTIFIER --variable IOS_URL_NAME=IOS_URL_NAME --variable IOS_URL_SCHEME=IOS_URL_SCHEME

```js
document.addEventListener('deviceready', onDeviceReady, false)

function onDeviceReady () {
  const cordova.shareextension.onFiles(function (urls) {
    alert(JSON.stringify(urls, null, 2))
  })
}
```

#### Meteor

```js
App.configurePlugin('cordova-plugin-ios-shareextension', {
  IOS_GROUP_IDENTIFIER: 'group.com.example.shareextension',
  IOS_URL_NAME: 'com.example',
  IOS_URL_SCHEME: 'app',
})
```

```js
Meteor.isCordova && Meteor.startup(function () {
  const cordova.shareextension.onFiles(function (urls) {
    alert(JSON.stringify(urls, null, 2))
  })
})
```

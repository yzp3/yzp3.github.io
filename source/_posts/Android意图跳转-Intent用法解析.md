---
title: Android意图跳转组件-Intent用法
date: 2020-04-05 12:22:45
category: 
  - Android
tags: 
  - Android
  - 轻松入门
  - Intent
---

## Intent 的设计初衷

Android 系统设计的独特之处在于，任何应用都可启动其他应用的组件。
由于系统在单独的进程中运行每个应用，且其文件权限会限制对其他应用的访问，因此您的应用无法直接启动其他应用中的组件，但 Android 系统可以。如要启动其他应用中的组件，请向系统传递一条消息，说明启动特定组件的 _Intent_ 。系统随后便会为您启动该组件。
当系统启动某个组件时，它会启动该应用的进程（如果尚未运行），并实例化该组件所需的类。例如，如果您的应用启动相机应用中拍摄照片的 Activity，则该 Activity 会在属于相机应用的进程（而非您的应用进程）中运行。因此，与大多数其他系统上的应用不同，Android 应用并没有单个入口点（即没有 `main()` 函数）。

 <!-- more -->

## Intent 介绍

[Intent](https://developer.android.google.cn/reference/android/content/Intent) 是一个消息传递对象，您可以用来从其他[应用组件](https://developer.android.google.cn/guide/components/fundamentals#Components)请求操作。尽管 Intent 可以通过多种方式促进组件之间的通信，但其基本用例主要包括以下三个：启动 Activity、启动服务、传递广播。

- **启动 Activity**

   Activity 表示应用中的一个屏幕。通过将Intent 传递给 [startActivity()](https://developer.android.google.cn/reference/android/content/Context#startActivity(android.content.Intent)，可以启动新的 Activity 实例。Intent 用于描述要启动的 Activity，并携带任何必要的数据。
    如果希望在 Activity 完成后收到结果，可以调用 [startActivityForResult()](https://developer.android.google.cn/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int))。在 Activity 的 [onActivityResult()](https://developer.android.google.cn/reference/android/app/Activity#onActivityResult(int,%20int,%20android.content.Intent)) 回调中，Activity 将结果作为单独的 Intent 对象接收。

- **启动服务**

 Service是一个不使用用户界面而在后台执行操作的组件。通过 startService(intent) 方法启动服务执行一次性操作（例如，下载文件），通过 bindService(intent) 方法将服务绑定到组件上。

- **传递广播**
  广播是任何应用均可接收的消息。系统将针对系统事件（例如：系统启动或设备开始充电时）传递各种广播。通过 sendBroadcast(intent) 或 sendOrderedBroadcast(intent) 方法，可以将广播传递给其他应用。

### Intent 分为两种类型：

- **显式 Intent** ：通过提供目标应用的软件包名称或完全限定的组件类名来指定可处理 Intent 的应用。通常，您会在自己的应用中使用显式 Intent 来启动组件，这是因为您知道要启动的 Activity 或服务的类名。例如，您可能会启动您应用内的新 Activity 以响应用户操作，或者启动服务以在后台下载文件。
- **隐式 Intent** ：不会指定特定的组件，而是声明要执行的常规操作，从而允许其他应用中的组件来处理。例如，如需在地图上向用户显示位置，则可以使用隐式 Intent，请求另一具有此功能的应用在地图上显示指定的位置。

图 1 显示如何在启动 Activity 时使用 Intent。当 `Intent` 对象显式命名某个具体的 Activity 组件时，系统立即启动该组件。

![图 1 隐式 Intent 如何通过系统传递以启动其他 Activity](https://developer.android.google.cn/images/components/intent-filters_2x.png)

使用隐式 Intent 时，Android 系统通过将 Intent 的内容与在设备上其他应用的[清单文件](https://developer.android.google.cn/guide/topics/manifest/manifest-intro)中声明的 _Intent 过滤器 (intent-filter)_ 进行比较，从而找到要启动的相应组件。如果 Intent 与 Intent 过滤器匹配，则系统将启动该组件，并向其传递 [Intent](https://developer.android.google.cn/reference/android/content/Intent) 对象。如果匹配到多个 Intent 过滤器，则系统会显示一个对话框，支持用户选取要使用的应用。

**注意：** 为了确保应用的安全性，启动 [Service](https://developer.android.google.cn/reference/android/app/Service) 时，请始终使用显式 Intent，且不要为服务声明 Intent 过滤器。使用隐式 Intent 启动服务存在安全隐患，因为您无法确定哪些服务将响应 Intent，且用户无法看到哪些服务已启动。从 Android 5.0（API 级别 21）开始，如果使用隐式 Intent 调用 [bindService()](https://developer.android.google.cn/reference/android/content/Context#bindService(android.content.Intent,%20android.content.ServiceConnection,%20int)) ，系统会抛出异常。

## 构建 Intent

### 显式 Intent

显式 Intent 通过指定组件启动，可以使用 setComponent()、setClass()、setClassName()，或 Intent 构造函数设置 ComponentName 对象。
`当设置了 ComponentName 对象后，系统就不会取匹配 intent-filter ，而是直接跳转 ComponentName 中指定的 Activity 。`

```JAVA
    //将直接跳转到ThirdActivity，不会去匹配Action
    Intent intent = new Intent();
    intent.setComponent(new ComponentName("com.example.myaop", "com.example.myaop.ThirdActivity"));
    intent.setAction("com.example.myaop.priority");
    startActivity(intent);
```

### 隐式 Intent

隐式 Intent 匹配的顺序是 action > data > category。除 BroadcastReceiver 可以动态注册，在代码里设置 intent-filter 以外，Activity、Service 都必须在 Android Manifest 中声明 intent-filter 。 如果不希望自己的组件被其他应用匹配到，可以将 exported 设为 false。
`注意：intent-filter 可以设置优先级，但这里的优先级是进程的优先级，并不会影响匹配的过程。`

```xml
<activity
  android:exported="false" <!-- 不被外部应用启动 -->
  android:name=".SecondActivity"
  android:label="@string/app_name"
  android:theme="@style/AppTheme.NoActionBar">
  <intent-filter android:priority="1000"> <!-- 设置进程的优先级1000,并不会影响匹配 -->
      <action android:name="android.intent.action.MAIN" />
      <category android:name="android.intent.category.LAUNCHER" />
      <action android:name="com.example.myaop.priority" />
      <category android:name="android.intent.category.DEFAULT" />
  </intent-filter>
</activity>
```

1. action
 可以约定自定义的 Action，让其他应用启动。比如添加支付宝约定的 Action， 跳转支付宝支付后接收对应的支付广播获取支付结果。

[Android 常用的 Action](https://developer.android.google.cn/reference/android/content/Intent#constants_2)

| Action 名称                            | 作用                             |
| ------------------------------------ | ------------------------------ |
| android.intent.action.MAIN           | 首页，点击应用图标启动的第一个 Activity       |
| android.intent.action.VIEW           | 查看，一般需要要同时设置 data ，启动相应的系统应用查看 |
| android.intent.action.EDIT           | 编辑                             |
| android.intent.action.INSERT_OR_EDIT | 插入，存在则修改                       |
| android.intent.action.PICK           | 选中                             |

2. data
   每个 [<data>](https://developer.android.google.cn/guide/topics/manifest/data-element) 元素均可指定 URI 结构和数据类型（MIME 媒体类型）。URI 的每个部分都是一个单独的属性：`scheme`、`host`、`port` 和 `path`：`<scheme>://<host>:<port>/<path>`
   下例所示为这些属性的可能值：`content://com.example.project:200/folder/subfolder/etc`
   在此 URI 中，架构是 `content`，主机是 `com.example.project`，端口是 `200`，路径是 `folder/subfolder/etc`。

一般来说，指定 URI，系统会自动推断 mimeType。如果要同时指定 URI 和 mimeType，可以使用 `public @NonNull Intent setDataAndType(@Nullable Uri data, @Nullable String type)`方法。

intent 中的 URI 和 intent-filter 中的 <data> 比较时，按 scheme、host、port、path 的顺序比较，如果没找到就不会继续往下比较，默认比较成功。`例如：只设置了host没有设置scheme，比较scheme时发现没有scheme则认为匹配成功而不会继续往下去比较host。`

```xml
<!-- 组件可从内容提供程序处获得并显示图像数据 -->
<intent-filter>
  <data  android:mimeType="image/*"  /> 
  ... 
</intent-filter>
```

```xml
<!-- 组件可从网络中检索视频或图片数据以执行操作 -->
<intent-filter>
  <data  android:scheme="http"  android:mimeType="video/*"  />
  <data  android:mimeType="image/*"  android:scheme="http" ... />
  ... 
</intent-filter>
```

3. category
   intent 默认会设置 CATEGORY_DEFAULT，所以所有希望响应隐式 Intent 的组件都需要在 intent-filter 设置 CATEGORY_DEFAULT。

| Action 名称           | 作用                                                   |     |
| ------------------- | ---------------------------------------------------- | --- |
| CATEGORY_DEFAULT    | Android系统中默认的执行方式，按照普通Activity的执行方式执行                | 　   |
| CATEGORY_HOME       | 设置该组件为Home Activity                                  |     |
| CATEGORY_PREFERENCE | 设置该组件为Preference                                     | 　   |
| CATEGORY_LAUNCHER   | 设置该组件为在当前应用程序启动器中优先级最高的Activity，通常为入口ACTION_MAIN配合使用 | 　   |
| CATEGORY_BROWSABLE  | 设置该组件可以使用浏览器启动                                       |     |
| CATEGORY_GADGET     | 设置该组件可以内嵌到另外的Activity中                               |     |

### [常见 Intent](https://developer.android.google.cn/guide/components/intents-common)

| Action                     | 应用类型      | URI                                                       | mimeType                             |
| -------------------------- | --------- | --------------------------------------------------------- | ------------------------------------ |
| ACTION_SET_ALARM           | 闹钟        |                                                           |                                      |
| ACTION_IMAGE_CAPTURE       | 拍摄照片并返回   |                                                           |                                      |
| ACTION_VIDEO_CAPTURE       | 拍摄视频并返回   |                                                           |                                      |
| INTENT_ACTION_IMAGE_CAMERA | 启动相机拍照    |                                                           |                                      |
| INTENT_ACTION_VIDEO_CAMERA | 启动相机拍摄视频  |                                                           |                                      |
| ACTION_VIEW                | 查看联系人     | http\:~~uri~~</br> https\:~~uri~~                         | text/html</br> application/xhtml+xml |
| ACTION_VIEW                | 使用浏览器打开网页 | content:~~uri~~                                           |                                      |
| ACTION_VIEW                | 播放音乐      | file:~~uri~~</br> content:~~uri~~</br> http\:~~uri~~</br> | audio/_</br> application/_           |
| ACTION_DIAL                | 打开拨号器     | tel:~~phone-number~~</br> voicemail:~~phone-number~~</br> |                                      |

# Table of contents
* [Configuring an App for Push Notifications](#configuring-an-app-for-push-notifications)
	* [Enabling the Push Notification Service](#enabling-the-push-notification-service)
	* [Registering for Push Notifications](#registering-for-push-notifications)
    * [Creating an SSL Certificate and PEM file](#creating-an-ssl-certificate-and-pem-file)
        * [SSL Certificate](#ssl-certificate)
        * [PEM file](#pem-file)
* [Sending a Push Notification](#sending-a-push-notification)
* [Anatomy of a Basic Push Notification](#anatomy-of-a-basic-push-notification)
* [Handling Push Notifications](#handling-push-notifications)
	* [What Happens When You Receive a Push Notification ?](#what-happens-when-you-receive-a-push-notification-?)
	* [Actionable Notifications](#actionable-notifications)
	* [Handling Notification Actions](#handling-notification-actions)
* [VOIP Push Notifications](#voip-push-notifications)
	
	
Tổng quan của Push Remote Notification được thể hiện thông qua sơ đồ sau:

![](image/Push-Overview-2.jpg)

# Configuring an App for Push Notifications

## Enabling the Push Notification Service

Vào **App Settings** -> **Capabilities**, sau đó đổi **Push Notifications** thành **On**

![](image/PushNotificaitonCapability.png)

Sau khi thực hiện bước này, App ID sẽ tự động được tạo trên member center nếu nó chưa tồn tại, và thêm quyền push notifications vào cho app

![](image/MemberCenter1.png)

## Registering for Push Notifications

Để đăng kí Push Notifications cần phải thực hiện qua 2 bước

    - Đạt được quyền của user cho phép hiển thị notification
    - Đăng kí remote notification
    
**B1: Đạt được quyền của user cho phép hiển thị notification**

Mở **AppDelegate.swift**, sau đó thêm vào phương thức sau:


```swift
func registerForPushNotifications(application: UIApplication) {
  let notificationSettings = UIUserNotificationSettings(
    forTypes: [.Badge, .Sound, .Alert], categories: nil)
  application.registerUserNotificationSettings(notificationSettings)
}
```

    .Badge cho phép app hiển thị số ở góc của app icon
    .Sound cho phép app play nhạc
    .Alert cho phép app hiển thị thông báo

Cuối cùng add lời gọi hàm **registerForPushNotifications(_:)** vào **application(_:didFinishLaunchingWithOptions:launchOptions:)**:
```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
  registerForPushNotifications(application)
  //...
}
```
**B2: Đăng kí remote notification**

Sau khi có được sự cho phép của user về hiển thị notify, phương thức delegate sau của **UIApplicationDelegate** sẽ được gọi:
```swift
func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
 
}
```
Trong hàm **application(_:didRegisterUserNotificationSettings:)**, ta sẽ thực hiện việc đăng kí **Remote Notifications** như sau:

```swift
func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
  if notificationSettings.types != .None {
    application.registerForRemoteNotifications()
  }
}
```

Một lần nữa, các hàm delegate của UIApplicationDelegate sẽ được gọi để thông báo về trạng thái của **registerForRemoteNotifications()**:

```swift
func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
  let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
  var tokenString = ""
 
  for i in 0..<deviceToken.length {
    tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
  }
 
  print("Device Token:", tokenString)
}
 
func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
  print("Failed to register:", error)
}
```

## Creating an SSL Certificate and PEM file

### SSL Certificate

Tại member center, vào **Certificates, Identifiers & Profiles -> Identifiers -> App IDs**, tìm App ID có sử dụng push notification, click **Edit** và scroll down tới **Push Notifications:**

![](image/CreateCertificate.png)

Click **Create Certificate** trong **Development SSL Certificate**, sau đó theo các bước hướng dẫn để tạo file CSR. Sau khi đã có file CSR, click  **continue** và **Generate** để tạo certificate (sử dụng file CSR vừa tạo). Cuối cùng, download file certificate và add vào Keychain.

### PEM file

Để server có thể push được remote notify về cho client, server có thể sử dụng file *.p12 hoặc *.pem (2 file này được tạo ra từ file certificate vừa được add vào Keychain). Để tạo 2 file này, ta thực hiện như sau:

Vào Keychain, sau đó tìm đến file certificate vừa được add, chuột phải vào file certificate đó, rồi chọn **Export**

![](image/ExportCertificate.png)

Save as **APNSDemoCert.p12**. Vậy là ta đã có file *.p12. Để sinh file *.pem, vào terminal gõ lệnh sau:

```swift
$ openssl pkcs12 -in APNSDemoCert.p12 -out APNSDemoCert.pem -nodes -clcerts
```
# Sending a Push Notification

Mở file **/PushServerDemo/PushServer.php**, thực hiện update **$deviceToken** thành deviceToken mà device nhận được trong hàm **application(_didRegisterForRemoteNotificationsWithDeviceToken:)**, đồng thời update **$passphrase** thành pass sử dụng khi tạo file *.p12.

Mở terminal, **cd** đến folder chứa **PushServer.php**, gõ:

```swift
$ php PushServer.php
```
**Một số chú ý**

- Nếu device trong tình trạng offline, notification sẽ được lưu lại trong một khoảng thời gian xác định và sẽ được push lại về device khi device có kết nối mạng trở lại.

- Chỉ có duy nhất 1 notification mới nhất được lưu trữ trong khi device offline. Tất cả các notification trước đó sẽ bị bỏ qua (xét trên 1 app)

# Anatomy of a Basic Push Notification

Với mỗi notification ta sẽ soạn ra 1 đối tượng dictionary tương ứng. Đối tượng dictionary này phải chứa 1 đối tượng dictionary khác được định danh bởi key **aps**. Dictionary tương ứng với key **aps** có thể gồm 1 hoặc nhiều key. Có 5 key mà ta có thể thêm vào dictionary **aps**

- alert (string, or dictionary): Nếu value của key **alert** là string thì nó trở thành message text của alert. Còn nếu value của key **alert** là dictionary, nó có thể địa phương hóa text ([tham khảo](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/TheNotificationPayload.html#//apple_ref/doc/uid/TP40008194-CH107-SW4))

- badge (number): số hiển thị ở góc icon của app

- sound (string): quy định tên file nhạc của alert. Có thể set giá trị cho nó là default hoặc nếu file không có thì nhạc default sẽ được play. Các định dạng file sau là hợp lệ: **aiff**, **wav**, hoặc **caf** ([tham khảo](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/IPhoneOSClientImp.html#//apple_ref/doc/uid/TP40008194-CH103-SW6))
	
- content-available (number) : nếu giá trị là 1 thì có dữ liệu cần xử lý. Việc thêm key **content-available** thì khi app ở backgound hoặc resume, hàm **application:didReceiveRemoteNotification:fetchCompletionHandler:** sẽ được gọi

- category (string): chỉ ra loại notification (được sử dụng trong việc custom action)

**Chú ý:** Data cho notification không được vượt quá 4096 bytes

# Handling Push Notifications

## What Happens When You Receive a Push Notification ?

Notification cần được xử lý theo các cách khác nhau phụ thuộc vào các trạng thái khác nhau của app khi app nhận được notification. Ta sẽ xem xét 3 trường hợp sau

- Nếu app đang không chạy, và user chạy lại app bằng cách tap vào push notification, push notification sẽ được chuyền vào app thông qua hàm **application:didReceiveRemoteNotification:fetchCompletionHandler:**

- Nếu app đang chạy và đang ở foreground, push notification sẽ không được show, nhưng hàm **application:didReceiveRemoteNotification:fetchCompletionHandler:** sẽ được gọi ngay lập tức

- Nếu app đang ở background, user tap vào push notification, hàm **application:didReceiveRemoteNotification:fetchCompletionHandler:** sẽ được gọi. Ngoài ra nếu app cho phép **Remote notification** ở **Background Mode**, hàm **application:didReceiveRemoteNotification:fetchCompletionHandler:** sẽ được gọi (nếu trường **content-available** được xét trong payload)

```swift
func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        let aps = userInfo["aps"] as! [String: AnyObject]
        print(aps)
    }
```

## Actionable Notifications

Actionable notifications cho phép thêm các nút vào notification. Actionable notifications được định nghĩa bởi app thông qua các *categorie*. Mỗi categorie có thể có một vài custom action. Một khi đã đăng kí category thì server cũng phải bổ sung trường **categorie** trong payload, và dĩ nhiên giá trị phải giống với giá trị mà app đã đăng kí.

Bổ sung đoạn code sau vào đầu của hàm **registerForPushNotifications(_:)**:

```swift
let viewAction = UIMutableUserNotificationAction()
viewAction.identifier = "VIEW_IDENTIFIER"
viewAction.title = "View"
viewAction.activationMode = .Foreground

let newsCategory = UIMutableUserNotificationCategory()
newsCategory.identifier = "NEWS_CATEGORY"
newsCategory.setActions([viewAction], forContext: .Default)
```
**Giải thích**: Chúng ta sẽ tạo ra 1 notification category có định danh là **NEWS_CATEGORY**, và category với định danh là **Category** sẽ có một mảng các action. Cụ thể mảng các action ở đây chỉ chứa 1 action có định danh là **VIEW_IDENTIFIER**.

**Chú ý**

- Số nút action tối đa là 2 nút.
- Màu của nút sẽ có 2 màu: default và đỏ. Nếu button set thuộc tính **destructive** là **true** thì nút có màu đỏ. Còn không thì màu là default (màu của nút phải cùng màu xanh, màu của nút thứ 2 màu xám)

Sau đó thay thế câu lệnh tạo **notificationSettings** thành:

```swift
let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: [newsCategory])
```

**Giải thích**: Câu lệnh trên nhằm đăng kí loại notification vừa tạo với thiết bị.

Cuối cùng trong playload của server, chúng ta sẽ bổ sung thêm trường **category** như sau:

```php
$body['aps'] = array(
  'alert' => $message,
  'sound' => 'default',
  'content-available' => 1,
  'category' => 'NEWS_CATEGORY',
  );
```
Kết quả khi nhận được notication:

![](image/ViewAction.png)

## Handling Notification Actions

Thêm đoạn code sau vào file **AppDelegate.swift**:

```swift
func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        let aps = userInfo["aps"] as! [String: AnyObject]
        if identifier == "VIEW_IDENTIFIER" {
            let view = UILabel.init(frame: CGRectMake(0, 50, 320, 100))
            view.textAlignment = .Center
            view.text = aps["alert"] as! String
            view.backgroundColor = UIColor.greenColor()
            window?.rootViewController?.view.addSubview(view)
        }
        completionHandler()
    }
```

Đây là callback nhận được khi mở app bằng custom action. Dựa vào các định danh của action mà ta sẽ có những đoạn code xử lý phù hợp.

# VOIP Push Notifications

Một số thuận lợi khi push notification lợi dụng cơ chế VOIP
- App sẽ được đánh thức để nhận notification và xử lý cho dù app không đang chạy.
- Không giống như kiểu push notification truyền thống, app cần phải nhận hành động từ người dùng trước khi thực hiện một công việc gì đó. VOIP push sẽ có cơ chế ngược lại, đó là xử lý 1 công việc nào đó trước khi show notification cho người dùng.
- VOIP được cho phép nhiều data hơn kiểu push thông thường.
- Quyền ưu tiên cho VOIP Push cao hơn, và được chuyển đi mà không bị delay.

Để có thể sử dụng VOIP Push, ta cũng cần phải thực hiện qua 1 số bước cấu hình như sau:

## Enable VOIP

![](image/VOIPEnable.png)

## Sinh file certificate

![](image/ios-8-voip-notifications-5.jpg)

![](image/ios-8-voip-notifications-6.jpg)

## Sinh file .pem cho server

Sau khi có file certificate, cách thức sinh file .pem giống với cách hình thức push notification thông thường.

## Implement

### Thực hiện đăng kí

Import thư viện PushKit vào fiel AppDelegate.swift. Sau đó thêm hàm sau vào file AppDelegate.swift:

```swift
// Register for VoIP notifications
func voipRegistration {
    let mainQueue = dispatch_get_main_queue()
    // Create a push registry object
    let voipRegistry: PKPushRegistry = PKPushRegistry(mainQueue)
    // Set the registry's delegate to self
    voipRegistry.delegate = self
    // Set the push type to VoIP
    voipRegistry.desiredPushTypes = [PKPushTypeVoIP]
}
```
Thực hiện lời gọi hàm trên trong hàm **application(_:didRegisterUserNotificationSettings:)**:

```swift
func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
            self.voipRegistration()
        }
    }
```

Nếu đăng kí thành công, hàm delegate sau sẽ được gọi, và tại đây ta sẽ nhận được **deviceToken**:

```swift
func pushRegistry(registry: PKPushRegistry!, didUpdatePushCredentials credentials: PKPushCredentials!, forType type: String!) {
        // Register VoIP push token (a property of PKPushCredentials) with server
        
        let tokenChars = UnsafePointer<CChar>(credentials.token.bytes)
        var tokenString = ""
        
        for i in 0..<credentials.token.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("VOIP Device Token:",tokenString)
    }
```
### Xử lý notification

Khi có 1 notification được push từ server về device, app sẽ được đánh thức và gọi vào hàm **pushRegistry(registry:didReceiveIncomingPushWithPayload:forType:)**. Tại đây ta sẽ thực hiện xử lý một số công việc trước khi push 1 local notification cho user. Ví dụ:

```swift
func pushRegistry(registry: PKPushRegistry!, didReceiveIncomingPushWithPayload payload: PKPushPayload!, forType type: String!) {
        
        let payloadDict = payload.dictionaryPayload as NSDictionary
        let apsDict = payloadDict.objectForKey("aps") as! NSDictionary
        let message : String = apsDict.valueForKey("alert") as! String
        
        let localNotification = UILocalNotification();
        localNotification.alertBody = message + " [VOIP]"
        localNotification.applicationIconBadgeNumber = 1;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = apsDict as [NSObject : AnyObject]
        
        UIApplication.sharedApplication().presentLocalNotificationNow(localNotification);
        
    }
```
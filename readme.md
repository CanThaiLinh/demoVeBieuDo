# Thư viện chat và notification CTLModuleChat
* [Cơ chế hoạt động](#cơ-chế-hoạt-động)
* [Yêu cầu](#yêu-cầu)
* [Cài đặt](#cài-đặt)
    * [Podfile](#podfile)
    * [Cài đặt Config cho thư viện](#cài-đặt-config-cho-thư-viện)
    * [Cài đặt khác](#cài-đặt-khác)
* [Sử dụng](#sử-dụng)
    * [Khởi tạo thư viện](#khởi-tạo-thư-viện)
        * [Khai báo thư viện trong AppDelegate](#khai-báo-thư-viện-trong-appdelegate)
        * [Khởi tạo thư viện trong didFinishLaunchingWithOptions](#khởi-tạo-thư-viện-trong-didfinishlaunchingwithoptions)
    * [Action](#action)
        * [Register user](#register-user)
        * [Get time stamp milisecond](#get-time-stamp-milisecond)
        * [Get history messages](#get-history-messages)
        * [Join conversation](#join-conversation)
        * [Leave conversation](#leave-conversation)
        * [Create Content Dictionary](#create-content-dictionary)
        * [Send message](#send-message)
    * [Delegate](#delegate)
        * [Did Connect](#did-connect)
        * [Did Disconnect](#did-disconnect)
        * [Did Receive Message From Conversation](#did-receive-message-from-conversation)
        * [Did Receive Message From System](#did-receive-message-from-system)
    

## Cơ chế hoạt động
Thư viện sử dụng trên nền tảng Mdclib.

Người dùng A chat với người dùng B thì :

1. A gọi lên server create 1 conversation cho A và B. Server trả về id conversation.

2. A **bắt buộc phải** join conversation để chat cho B.

3. B nhận được message cùng id conversation.

4. B **bắt buộc phải** join conversation bằng id conversation nhận được mới có thể chat cho A.

Gửi notification thông qua Mdclib và xử lý thông qua **PushHandler**

## Yêu cầu

Thư viện yêu cầu :

    * SohaSDK để login vietID
    
    * MdcLib verson 3.1 để thực hiện chat
    
    * AFNetworking 3.0
    

## Cài đặt
### Podfile
pod 'MdcLib-Skyprepare'

pod 'AFNetworking'

### Cài đặt Config cho thư viện

Để sử dụng thư viện bạn vui lòng liên hệ với bộ phận MySoha để có token và appkey tương ứng với project của bạn.

Sau đó vào file MdcLibConfig.h để sửa 2 giá trị tương ứng :
```swift
//Config App
#define MDCLIB_TOKEN @"YOUR_MDCLIB_PROJECT_TOKEN"
#define MDCLIB_APPKEY @"YOUR_MDCLIB_PROJECT_APPKEY"
```


### Cài đặt khác

Disable bitcode (Enable BitCode = NO)

## Sử dụng
### Khởi tạo thư viện
#### Khai báo thư viện trong AppDelegate

```swift
    #import "AppDelegate.h"
    #import "MdcLibManager.h"
    @interface AppDelegate ()<MdcChatManagerDelegate>
    @property(strong,nonatomic) MdcLibManager * mdcChatManager;
```

#### Khởi tạo thư viện trong didFinishLaunchingWithOptions

```swift
    self.mdcChatManager = [MdcLibManager sharedInstance];
    [self.mdcChatManager configTokenAndAppKeyLaunchOptions:launchOptions];
```

#### Cài đặt 1 số thuộc tính của thư viện

```swift
    // Override point for customization after application launch.
    
    [self.mdcChatManager enableRealTimeChat:true];
    [self.mdcChatManager checkForSurveysOnActive:true];
    [self.mdcChatManager showSurveyOnActive:true];//Change this to NO to show your surveys manually.
    
    [self.mdcChatManager checkForNotificationsOnActive:true];
    [self.mdcChatManager showNotificationOnActive:true];//Change this to NO to show your notifs manually.
    
    // Set the upload interval to 15 seconds for demonstration purposes. This would be overkill for most applications.
    [self.mdcChatManager setflushIntervalValue:15];// defaults to 15 seconds
    
    [self.mdcChatManager setUpPushHandler];
    
    // Set the icon badge to zero on startup (optional)
    [self.mdcChatManager resetBadge];
```

### Action
#### Register user
Tên hàm :

```swift
-(void)registerUser : (NSString*) userName : (NSString*)userID;
```
Sử dụng :

```swift
[[MdcLibManager sharedInstance] registerUser:@"linhcanthai@gmail.com" :@"linhcanthai"];
```

#### Get time stamp milisecond

Tên hàm :

```swift
-(NSString*)getTimeStampMilisecondString;
```

Sử dụng :

```swift
NSString * timeStampStr = [[MdcLibManager sharedInstance] getTimeStampMilisecondString];
```

#### Get history messages
Tên hàm :

```swift
- (void)getHistoryConversation:(NSString *_Nonnull)roomId limited:(NSInteger)limit timestamp:(NSString*)timestamp callback:(void (^ _Nullable)(NSDictionary *_Nullable data))response;
```

Sử dụng :

```swift
[[MdcLibManager sharedInstance] getHistoryConversation:@"100645" limited:20 timestamp:timeStampStr callback:^(NSDictionary * _Nullable data) {
        NSLog(@"getHistoryConversation %@",data);
    }];
```

#### Join conversation
Tên hàm :

```swift

```

Sử dụng :

```swift

```
#### Leave conversation
Tên hàm :

```swift
- (void) leaveConversation:(NSString *_Nonnull)conversationId callback:(void (^_Nullable)(NSError *_Nullable error))response;
```

Sử dụng :

```swift

```

#### Create Content Dictionary
Tên hàm :

```swift
-(NSDictionary*)createContentDictionaryWithText : (NSString*)text userAvatar : (NSString*)userAvatar userName : (NSString *)userName valueComment : (NSString*) valueComment;
```

Sử dụng :

```swift
NSDictionary *chatDist = [[MdcLibManager sharedInstance] createContentDictionaryWithText:@"day la text" userAvatar:@"imageLink" userName:@"userName" valueComment:@"valueComment"];
```

#### Send message
Tên hàm :

```swift
- (void)sendChatMessage:(NSString *_Nonnull)conversationId type:(NSString *_Nullable)type subConversationId:(NSString*)subConversationId content:(NSDictionary *_Nonnull)content callback:(void (^ _Nullable)(NSError *_Nullable error))response;
```

Sử dụng :

```swift
 NSDictionary *chatDist = [[MdcLibManager sharedInstance] createContentDictionaryWithText:@"day la text" userAvatar:@"imageLink" userName:@"userName" valueComment:@"valueComment"];
    
    [[MdcLibManager sharedInstance] sendChatMessage:@"100003697" type:@"message" subConversationId:@"" content:chatDist callback:^(NSError * _Nullable error) {
        if (error.code != 0){
            
            NSLog(@"send chat %@", error.localizedDescription);
        } else {
            
            NSLog(@"send chat %@", @"ok");
        }
    }];

```



### Delegate
#### Did Connect
Sử dụng :

```swift

```

#### Did Disconnect
#### Did Receive Message From Conversation
#### Did Receive Message From System
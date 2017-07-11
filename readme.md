# Mục lục
* [Cơ chế hoạt động](#cơ-chế-hoạt-động)
* [Yêu cầu](#yêu-cầu)
* [Cài đặt](#cài-đặt)
* [Sử dụng](#sử-dụng)
    * [Khởi tạo thư viện](#khởi-tạo-thư-viện)
    * [Action](#action)
        * [Register user](#register-user)
        * [Get history messages](#get-history-messages)
        * [Join conversation](#join-conversation)
        * [Leave conversation](#leave-conversation)
        * [Send message](#send-message)
        * [Create Content Dictionary](#create-content-dictionary)
    * [Delegate](#delegate)
        * [Did Connect](#did-connect)
        * [Did Disconnect](#did-disconnect)
        * [Did Receive Message From Conversation](#did-receive-message-from-conversation)
        * [Did Receive Message From System](#did-receive-message-from-system)
    

## Cơ chế hoạt động
Ứng dụng sử dụng trên nền tàng mdclib.
Người dùng A chat với người dùng B thì :

    A gọi lên server create 1 conversation cho A và B. Server trả về id conversation.

    A join conversation để chat vào conversation cho B.

    B nhận được message cùng id conversation.

    B join conversation để chat vào conversation cho A.


## Yêu cầu

Thư viện yêu cầu :

    * SohaSDK để login vietID
    
    * MdcLib verson 3.1 để thực hiện chat
    
    * AFNetworking 3.0
    

## Cài đặt
## Sử dụng
### Khởi tạo thư viện

```swift
#import "AppDelegate.h"
#import "MdcLibManager.h"
@interface AppDelegate ()<MdcChatManagerDelegate>
@property(strong,nonatomic) MdcLibManager * mdcChatManager;
```

### Action
#### Register user
#### Get history messages
#### Join conversation
#### Leave conversation
#### Send message
#### Create Content Dictionary
### Delegate
#### Did Connect
#### Did Disconnect
#### Did Receive Message From Conversation
#### Did Receive Message From System

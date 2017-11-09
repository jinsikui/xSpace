## QTNetwork

QTNetwork是蜻蜓FM iOS客户端的轻量级网络层框架,基于AFNetworking。它提供如下功能

- [x] 面向协议的API编写方式
- [x] 下载 & 断点续传
- [x] 上传 & MultipartForm
- [x] 请求适配
- [x] 重复网络请求管理
- [x] stub数据
- [x] 按时间缓存
- [x] 数据有效性验证
- [x] 请求依赖管理
- [x] 重试机制


## 安装

```
pod QTNetwork :git => 'https://huangwenchen@git2.qingtingfm.com/huangwenchen/QTNetwork.git'
```


## 概念

在QTNetwork中，主要有以下概念

- RequestConvertable，大多数时候开发者需要打交道的是这个协议，表示一个网络请求。
- Manager，通过把RequestConvertable传递给Manager进行实际的网络请求
- Response，网络请求返回的对象


## 基础使用

新建一个类，让其实现协议`RequestConvertable`，表示这是一个网络请求：

```
@interface QTPostSNSCheckAPI()<RequestConvertable>
@property (strong, nonatomic) NSString * phoneNumber;
@end
@implementation QTPostSNSCheckAPI
- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber{
    if (self = [super init]) {
        self.phoneNumber = phoneNumber;
    }
    return self;
}
@end
```

然后，实现协议的方法

```
- (NSString *)baseURL{ return @"https://appcommon.qingting.fm";}

- (NSString *)path{ return @"/common/v1/sms/send";}

- (QTHTTPMethod)httpMethod{ return HTTP_POST;}

- (NSDictionary *)parameters{
   	//...
    NSDictionary *params = @{
                             @"access_id":md5String,
                             @"mobile":self.phoneNumber,
                             @"device_id":@"1231421412",
                             @"app_type":@"0001"
                             };
    return params;
}
```
接着，创建一个manager来进行实际的网络请求：

```
self.manager = [QTNetworkManager manager];
QTGetV6ChannelOndemandAPI * api = [[QTGetV6ChannelOndemandAPI alloc] init];
[self.manager request:api
           completion:^(QTNetworkResponse * _Nonnull response) {
                          NSLog(@"%@",response.responseObject);
                     }];
```


## RequestConvertable

Requestable协议是QTNetwork对外接口的核心，绝大部分时候，你只需要提供这个协议要求的方法/属性

### 基础属性

```
@property (nonatomic, readonly) NSString *  baseURL;
@property (nonatomic, readonly) NSString *  path;

@optional
@property (nonatomic, readonly) NSDictionary *  parameters; //请求参数，如果是GET请求，会添加到Query中，POST/PUT会放到Body里
@property (nonatomic, readonly) QTHTTPMethod httpMethod; //默认GET
@property (nonatomic, readonly) NSDictionary<NSString *,NSString *> * httpHeaders; // HTTP Headers

```

### 请求类型

```
@optional
@property (nonatomic, readonly) QTRequestType * requestType; //请求类型，默认是[QTRequestType Data]

```

通过`QTRequestType`的类方法来创建请求类型，分为三种：

- `data` 拉数据到内存
- `uploadFromFileURL/uploadFromData` 上传数据
- `downloadWithResumeData:destination` 下载数据 & 断点续传

### 编码 & 解码


```
@optional
@property (nonatomic, readonly) QTParameterEncoding encodingType;//参数编码
@property (nonatomic, readonly) QTResponseDecncoding decodingType;//返回的NSData解码
```

参数编码支持三种：

```
typedef NS_ENUM(NSInteger,QTParameterEncoding){
    QTParameterEncodingHTTP,
    QTParameterEncodingJSON,
    QTParameterEncodingPropertyList
};
```

数据解码支持三种：

```
typedef NS_ENUM(NSInteger,QTResponseDecncoding){
    QTResponseDecncodingHTTP, //不会解析，直接返回NSData
    QTResponseDecncodingJSON, //按照JSON来解析
    QTResponseDecncodingXML, //按照XML来解析
};

```

### 假数据

假数据可以让前端开发不用等待后端API完成，并且可以方便自动化测试（模拟各种返回值情况），当提供了这个方法后，QTNetwork不会进行实际的网络请求，而是直接返回假数据作为Callback。除了数据源来自Stub，其余的均和实际网络请求一致。

```
@optional
@property (nonatomic, readonly) QTNetworkSub * stubData;

```
### 有效性验证

```
@optional
@property (nonatomic, readonly) id<QTNetworkResponseValider> responseValider;
```

QTNetwork提供按照JSON Scheme的验证工具类，比如：

```
- (id<QTNetworkResponseValider>)responseValider{
    NSDictionary * shema = @{
                             @"errorno":[NSNumber class],
                             @"data":@{
                                     @"id": [NSNumber class],
                                     @"title": [NSString class]
                                     }
                             };
    return [QTJSONSchemaValider objectValiderWithScheme:shema];
}
```


### 按时间缓存

当实现了这个协议方法，并且返回有效值（大于0）后，一段时间内相同的请求会返回缓存数据，而不会进行实际网络请求

```
@optional
@property (nonatomic, readonly) NSTimeInterval durationForReturnCache;

```

### 返回值适配

在这个方法里进行`QTNetworkResponse.responseObject`的适配，比如JSON转对象等动作。

```
@optional
- (QTNetworkResponse *)adaptResponse:(QTNetworkResponse *)networkResponse;

```


## 请求适配

QTNetwork的请求是按照如下方式进行转换的

> RequestConvertable -> QTNetworkRequst -> NSURLRequst -> NSURLSessionTask

前两次转换的时候，是通过Manager的适配器进行转换的：

```
- (void)adaptRequest:(QTNetworkRequest * )requset
            complete:(void(^)(NSURLRequest *  request,NSError * error))complete;
- (void)adaptRequestConvertable:(id<QTRequestable> )requestConvertable
                       complete:(void(^)(QTNetworkRequest *  request, NSError *  error))complete;
```

由于适配器支持异步适配，在这里进行Token验证和拼接是一个很好的模式：

```
- (void)adaptRequest:(QTNetworkRequest * )requset
            complete:(void(^)(NSURLRequest *  request,NSError * error))complete{
     if (tokenNotValid){//刷新Token，然后执行complete}
 }
```

## Response

QTNetwork通过QTNetworkResponse对象来提供网络请求数据结果：

```
@interface QTNetworkResponse<T> : NSObject

@property (strong, nonatomic, readonly) T responseObject; //经过适配后的对象，如果不适配，是JSON字典或者数组
@property (strong, nonatomic, readonly) NSURLResponse * urlResponse; //HTTP响应
@property (strong, nonatomic, readonly) NSError * error; //出错
@property (assign, nonatomic,readonly) NSInteger statusCode;  //HTTP 状态码
@property (strong, nonatomic,readonly) id <QTRequestable> request; //原始的请求对象
@property (strong, nonatomic, readonly) NSURL * filePath; //下载文件的路径（只有download任务有效）
@property (assign, nonatomic, readonly) QTNetworkResponseSource source;//响应数据来源

@end

```

其中响应数据来源包括三种：

```
typedef NS_ENUM(NSInteger, QTNetworkResponseSource){
    QTNetworkResponseSourceStub, //Stub数据
    QTNetworkResponseSourceLocalCache, //本地缓存
    QTNetworkResponseSourceURLLoadingSystem //来自URL Loading System
};
```


## 依赖管理

QTNetwork提供了`NSOperation`的字类`QTNetworkOperation`来进行依赖管理，你可以用任何的`NSOperation`依赖管理方法。

除此之外，QTNetwork提供了两个很常用的工具类。

### QTBatchNetworkOperation

**一组API同时发出去，等到所有API都完成了给出回调**

```
id<RequestConvertable>  api1;
id<RequestConvertable>  api2;
QTBatchNetworkOperation * operation = [[QTBatchNetworkOperation alloc] initWithRequestables:@[api1,api2]
                                                                                 completion:^(NSArray<QTNetworkResponse *> * responses) {
                                                                                     QTNetworkResponse * resp1 = responses[0];
                                                                                     QTNetworkResponse * resp2 = responses[1];
                                                                                    
                                                                                 }];
[self.operationQueue addOperation:operation];

```

### QTChainNetworkOperation

**一组API依次发出去，上一个成功下一个才会进行，等到最后一个结束后进行回调。**

```
id<RequestConvertable> api1;
id<RequestConvertable> api2;
QTChainNetworkOperation * operation = [[QTChainNetworkOperation alloc] initWithRequestables:@[api1,api2]
                                                                                 completion:^(QTNetworkResponse *lastActiveResponse) {
  //最后一个请求的回调                                                                                  
                                                                                 }];
[self.operationQueue addOperation:operation];

```


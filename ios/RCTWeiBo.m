
#import "RCTWeiBo.h"
#import "WeiboSDK.h"

#define RCTWBEventName (@"weibo_login")
BOOL registerSDK = NO;  //if SDK registered

@interface RCTWeiBo() <WeiboSDKDelegate>
@end

@implementation RCTWeiBo{
    bool hasListeners;
    WBAuthorizeRequest *request;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[RCTWBEventName];
}

// Will be called when this module's first listener is added.
-(void)startObserving {
    hasListeners = YES;
    // Set up any upstream listeners or background tasks as necessary
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving {
    hasListeners = NO;
    // Remove upstream listeners, stop unnecessary background tasks
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenURL:)
                                                     name:@"RCTOpenURLNotification" object:nil];
    }
    return self;
}

- (void)handleOpenURL:(NSNotification *)note
{
    NSDictionary *userInfo = note.userInfo;
    NSString *url = userInfo[@"url"];
    [WeiboSDK handleOpenURL:[NSURL URLWithString:url] delegate:self];
}

RCT_EXPORT_METHOD(login:(NSDictionary *)config :(RCTResponseSenderBlock)callback)
{
    NSString *redirectURI = config[@"redirectURI"];
    NSString *scope = config[@"scope"];
    NSString *appKey = config[@"appKey"];
    
    //注册SDK
    if(!registerSDK){
        #ifdef DEBUG
            [WeiboSDK enableDebugMode:YES];
        #endif
        if([WeiboSDK registerApp:appKey]){
            registerSDK = YES;
        }
    }
    
    if(request == nil){
        request = [WBAuthorizeRequest request];
        request.redirectURI = redirectURI;
        request.scope = scope;
    }
    
    BOOL success = [WeiboSDK sendRequest:request];
    callback(@[success?@"Weibo open success.":@"Weibo open fail."]);
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSMutableDictionary *body = [NSMutableDictionary new];
    body[@"errCode"] = @(response.statusCode);
    // 分享
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        body[@"type"] = @"WBSendMessageToWeiboResponse";
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess)
        {
            WBSendMessageToWeiboResponse *sendResponse = (WBSendMessageToWeiboResponse *)response;
            WBAuthorizeResponse *authorizeResponse = sendResponse.authResponse;
            if (sendResponse.authResponse != nil) {
                body[@"userID"] = authorizeResponse.userID;
                body[@"accessToken"] = authorizeResponse.accessToken;
                body[@"expirationDate"] = @([authorizeResponse.expirationDate timeIntervalSince1970]);
                body[@"refreshToken"] = authorizeResponse.refreshToken;
            }
        }
        else
        {
            body[@"errMsg"] = [self _getErrMsg:response.statusCode];
        }
    }
    // 认证
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        body[@"type"] = @"WBAuthorizeResponse";
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess)
        {
            WBAuthorizeResponse *authorizeResponse = (WBAuthorizeResponse *)response;
            body[@"userID"] = authorizeResponse.userID;
            body[@"accessToken"] = authorizeResponse.accessToken;
            body[@"expirationDate"] = @([authorizeResponse.expirationDate timeIntervalSince1970]*1000);
            body[@"refreshToken"] = authorizeResponse.refreshToken;
        }
        else
        {
            body[@"errMsg"] = [self _getErrMsg:response.statusCode];
        }
    }
    if (hasListeners) {
        [self sendEventWithName:RCTWBEventName body:body];
    }
}


- (NSString *)_getErrMsg:(NSInteger)errCode
{
    NSString *errMsg = @"微博认证失败";
    switch (errCode) {
        case WeiboSDKResponseStatusCodeUserCancel:
            errMsg = @"用户取消发送";
            break;
        case WeiboSDKResponseStatusCodeSentFail:
            errMsg = @"发送失败";
            break;
        case WeiboSDKResponseStatusCodeAuthDeny:
            errMsg = @"授权失败";
            break;
        case WeiboSDKResponseStatusCodeUserCancelInstall:
            errMsg = @"用户取消安装微博客户端";
            break;
        case WeiboSDKResponseStatusCodePayFail:
            errMsg = @"支付失败";
            break;
        case WeiboSDKResponseStatusCodeShareInSDKFailed:
            errMsg = @"分享失败";
            break;
        case WeiboSDKResponseStatusCodeUnsupport:
            errMsg = @"不支持的请求";
            break;
        default:
            errMsg = @"位置";
            break;
    }
    return errMsg;
}

@end



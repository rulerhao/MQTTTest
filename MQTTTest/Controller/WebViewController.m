//
//  WebViewController.m
//  MQTTTest
//
//  Created by louie on 2020/11/27.
//

#import "WebViewController.h"


@interface WebViewController ()

@end

@implementation WebViewController

/**
 * Access Token 可以維持大概一個小時
 */
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    WKWebView *WKWeb_View;
    WKWeb_View = [self setupWebView : (WKWebView *) WKWeb_View];
    OAuthParameters *oAuthParameters = [OAuthParameters alloc];
    NSString *RequestURL = [oAuthParameters logInURLWithParameters];
    RequestOAuth2Steps *requestOAuth2Steps = [RequestOAuth2Steps alloc];
    [requestOAuth2Steps     logIn: RequestURL
                        wKWebView: WKWeb_View];
    // 當登錄完成後做 get code 動作
    NSLog(@"afterLogin");
}

- (WKWebView *)setupWebView : (WKWebView *) WKWeb_View {
    WKWeb_View = [[WKWebView alloc] initWithFrame: CGRectZero];
    WKWeb_View.UIDelegate = self;
    WKWeb_View.navigationDelegate = self;
    WKWeb_View.allowsBackForwardNavigationGestures = YES;

    [self.view addSubview:WKWeb_View];
    // Constraint
    [self setupWKWebViewConstain: WKWeb_View];
    return WKWeb_View;
}

- (void)
webView             :(WKWebView *)      webView
didFinishNavigation :(WKNavigation *)   navigation {
    NSLog(@"didFinishNavigation URL = %@", [webView URL]);
    NSURL *URL = webView.URL;
    NSURLComponents *URL_Components = [NSURLComponents componentsWithString:URL.absoluteString];
    if([[URL_Components path]  isEqual: @"/oauth/login"]) {
        RequestOAuth2Steps *requestOAuth2Steps = [RequestOAuth2Steps alloc];
        [requestOAuth2Steps takeCode:webView];
    }
    // 在取得 Access Token 後
    // 這裡有兩個可能會進入
    // 1. 是在完成以 code 來取得 Access token 和 Refresh toekn
    // 2. 是在完成以 refresh token 來取得 Access token 和 Refresh token
    else if ([[URL_Components path]  isEqual: @"/oauth/token"]) {
        [[NSNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(getHTMLStringNotification:) //接收到該Notification時要call的function
            name:@"NotificationName"
            object:nil];
        HTMLProcess *htmlProcess = [HTMLProcess alloc];
        [htmlProcess getHTMLString   : self
                     webView         : webView];
    }
    else if ([[URL_Components path]  isEqual: @"/api/v1/ouhub/otp"]) {
        NSLog(@"GetOTP");
        HTMLProcess *htmlProcess = [HTMLProcess alloc];
        [htmlProcess getHTMLString   : self
                     webView         : webView];
    }
    else {
        // 取得 code
        URLProcess *urlProcess = [URLProcess alloc];
        NSString *URL_Query = [[webView URL] query];
        NSMutableArray *Parameters = [urlProcess getURLParameters:URL_Query];
        
        NSMutableDictionary *Code_Dict = [Parameters objectAtIndex:0];
        NSString *Code_Key = @"code";
        NSLog(@"NotYetGetInto = %@", [Code_Dict allKeys]);
        // 取得 access token
        if([[[Code_Dict allKeys]objectAtIndex:0] isEqual:Code_Key]) {
            NSLog(@"getintocodekey");
            NSString *Code_Value = [Code_Dict valueForKey:Code_Key];
            RequestOAuth2Steps *requestOAuth2Steps = [RequestOAuth2Steps alloc];
            [requestOAuth2Steps takeAccessToken:Code_Value
                                      wKWebView:webView];
        }
    }
    NSLog(@"didFinishNavigation");
}

// 在收到 response 後，决定是否跳轉
// 步驟請參考公司 pigo 建置的 github document
// https://github.com/kjws/ouhealth-ng/blob/master/docs/API-OAuth2.md
// 第一步驟登入後的 response
-(void)
webView                             : (WKWebView *)                             webView
decidePolicyForNavigationResponse   : (WKNavigationResponse *)                  navigationResponse
decisionHandler                     : (void (^)(WKNavigationResponsePolicy))    decisionHandler {
    NSURL *URL = navigationResponse.response.URL;
    NSURLComponents *URL_Components = [NSURLComponents componentsWithString:URL.absoluteString];
    
    URLProcess *urlProcess = [URLProcess alloc];
    // 只顯示參數的部分
    NSString *URL_Query = [URL_Components query];
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    Parameters = [urlProcess getURLParameters:URL_Query];
    NSLog(@"Parameters = %@", Parameters);

    if([[URL_Components path]  isEqual: @"/oauth/login"]) {
        decisionHandler(WKNavigationResponsePolicyAllow);
    } else if([[URL_Components path]  isEqual: @"/oauth/token"]) {
        decisionHandler(WKNavigationResponsePolicyAllow);
    } else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}
- (void)
webView:(WKWebView *)webView
didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation");
    NSLog(@"webView = %@", webView.URL);
    NSLog(@"           ");
}

- (void)
webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        decisionHandler(WKNavigationActionPolicyCancel);
        NSLog(@"WKNavigationActionPolicyCancel");

    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
        NSLog(@"WKNavigationActionPolicyAllow");
    }
}

/// autoLayout 設定
- (void)setupWKWebViewConstain: (WKWebView *)webView {
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 四個邊的距離設定為零
    NSLayoutConstraint *topConstraint =
    [NSLayoutConstraint constraintWithItem: webView
                                 attribute: NSLayoutAttributeTop
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: self.view
                                 attribute: NSLayoutAttributeTop
                                multiplier: 1.0
                                  constant: 0];
    
    NSLayoutConstraint *bottomConstraint =
    [NSLayoutConstraint constraintWithItem: webView
                                 attribute: NSLayoutAttributeBottom
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: self.view
                                 attribute: NSLayoutAttributeBottom
                                multiplier: 1.0
                                  constant: 0];
    
    NSLayoutConstraint *leftConstraint =
    [NSLayoutConstraint constraintWithItem: webView
                                 attribute: NSLayoutAttributeLeft
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: self.view
                                 attribute: NSLayoutAttributeLeft
                                multiplier: 1.0
                                  constant: 0];
    
    NSLayoutConstraint *rightConstraint =
    [NSLayoutConstraint constraintWithItem: webView
                                 attribute: NSLayoutAttributeRight
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: self.view
                                 attribute: NSLayoutAttributeRight
                                multiplier: 1.0
                                  constant: 0];
    
    NSArray *constraints = @[
                             topConstraint,
                             bottomConstraint,
                             leftConstraint,
                             rightConstraint
                             ];
    
    [self.view addConstraints:constraints];
}

- (BOOL) HaveLogInCookies : (WKWebView *) WKWeb_View {
    // cookies
    WKHTTPCookieStore *cookieStore = WKWeb_View.configuration.websiteDataStore.httpCookieStore;
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    NSDictionary *headers = [[NSDictionary alloc] init];
    [cookieStore getAllCookies:^(NSArray* cookies) {
        if (cookies.count > 0) {
            for (NSHTTPCookie *cookie in cookies) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                [cookieArray addObject:cookie];
                if([cookie.name isEqual:@"_identity"]) {
                    
                }
                if([cookie.name isEqual:@"PHPSESSID"]) {
                    
                }
                if([cookie.name isEqual:@"_csrf"]) {
                    
                }
            }
        }
    }];
    headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
    return true;
}

- (void)
getHTMLStringNotification:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo]; //讀取userInfo
    NSString *HTTP_String_Key = [[userInfo allKeys] objectAtIndex:0];
    NSMutableArray *HTTP_Information = [[userInfo allValues] objectAtIndex:0];
    NSString *HTTP_String_Value = [HTTP_Information objectAtIndex:0];
    WKWebView *WKWeb_View = [HTTP_Information objectAtIndex:1];
    NSLog(@"HTTP_String_Key = %@", HTTP_String_Key);
    
    HTMLProcess *htmlProcess = [HTMLProcess alloc];
    NSString *HTTP_String_JSON = [htmlProcess htmlStringToJSONFormatString:HTTP_String_Value];
    
    JSONProcess *Json_Process = [JSONProcess alloc];
    NSDictionary *Json_Dictionary = [Json_Process NSStringToJSONDict:HTTP_String_JSON];

    if([HTTP_String_Key isEqual: @"/oauth/token"]) {
        NSString *Access_Token = [Json_Dictionary valueForKey:@"access_token"];
        NSString *Refresh_Token = [Json_Dictionary valueForKey:@"refresh_token"];
        
        NSLog(@"Access_Token = %@", Access_Token);
        NSLog(@"Refresh_Token123 = %@", Refresh_Token);
        
        //    暫時沒有使用 Refresh Token 來做 Refresh 的動作
        //    [self takeRefreshAccesssTokenThroughRefreshToken:Refresh_Token];
        RequestOAuth2Steps *requestOAuth2Steps = [RequestOAuth2Steps alloc];
        [requestOAuth2Steps takeOTP : Access_Token
                           wKWebView: WKWeb_View];
    } else if ([HTTP_String_Key  isEqual: @"/api/v1/ouhub/otp"]) {
        NSString *Client_ID = [Json_Dictionary valueForKey:@"client_id"];
        NSString *User_Name = [Json_Dictionary valueForKey:@"username"];
        NSString *OTP = [Json_Dictionary valueForKey:@"otp"];
        NSString *OTP_Expired = [Json_Dictionary valueForKey:@"otp_expired"];
        
        NSLog(@"OTPValue = %@", Client_ID);
        NSLog(@"OTPValue = %@", User_Name);
        NSLog(@"OTPValue = %@", OTP);
        NSLog(@"OTPValue = %@", OTP_Expired);

        //[self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end

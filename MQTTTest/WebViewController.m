//
//  WebViewController.m
//  MQTTTest
//
//  Created by louie on 2020/11/27.
//

#import "WebViewController.h"


@interface WebViewController ()

@property (nonatomic) WKWebView *webView;

@end

@implementation WebViewController

/**
 * Access Token 可以維持大概一個小時
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"GetInto = %@", self);
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setupWebView];
    OAuthParameters *oAuthParameters = [OAuthParameters alloc];
    NSString *RequestURL = [oAuthParameters logInURLWithParameters];
    [self logIn: RequestURL];
    // 當登錄完成後做 get code 動作
    NSLog(@"afterLogin");
}

- (void)setupWebView
{
    self.webView = [[WKWebView alloc] initWithFrame: CGRectZero];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    
    [self.view addSubview:self.webView];
    // Constraint
    [self setupWKWebViewConstain: self.webView];
}

- (void)
webView:(WKWebView *)webView
didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"didFinishNavigation URL = %@", [webView URL]);
    NSURL *URL = webView.URL;
    NSURLComponents *URL_Components = [NSURLComponents componentsWithString:URL.absoluteString];
    if([[URL_Components path]  isEqual: @"/oauth/login"]) {
        [self takeCode];
    }
    // 在取得 Access Token 後
    else if ([[URL_Components path]  isEqual: @"/oauth/token"]) {
        NSLog(@"%@", [NSThread currentThread]);

        HTMLProcess *htmlProcess = [HTMLProcess alloc];
        OAuth2ForOuhealth *oAuth2ForOuhealth = [OAuth2ForOuhealth alloc];
        ////
        //__block NSString *HTML_String = [htmlProcess getHTMLString:webView];
        __block NSString *HTML_String = nil;
        //    NSString __block *Return_HTML_String = nil;
            [webView evaluateJavaScript:@"document.documentElement.outerHTML" completionHandler:^(id result, NSError *error) {
                NSLog(@"Evaluateerror = %@", error);
                NSLog(@"Evaluateresult = %@", result);
                if (error == nil) {
                    if (result != nil) {
        //                Return_HTML_String = [NSString stringWithFormat:@"%@", result];
                        HTML_String = [NSString stringWithFormat:@"%@", result];
                    }
                } else {
                    NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
                }
            }];
        ////
        NSLog(@"HTML_String = %@", HTML_String);
        NSString *Access_Token = [oAuth2ForOuhealth getAccessTokenThroughHTML:HTML_String];
        NSString *Refresh_Token = [oAuth2ForOuhealth getRefresgTokenThroughHTML:HTML_String];
        NSLog(@"FinishEva");
        NSLog(@"Refresh_Token = %@", Refresh_Token);
//        [self takeRefreshAccesssTokenThroughRefreshToken:Refresh_Token];
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
            [self takeAccessToken:Code_Value];
        }
    }
    NSLog(@"didFinishNavigation");
}
// 登錄用的URL設定
- (void)logIn:(NSString *)requestURLString {
    NSURL *url = [[NSURL alloc] initWithString: requestURLString];
    OAuthParameters *oAuthParameters = [OAuthParameters alloc];
    NSString *Body_String = [oAuthParameters Parameters_Merge:[oAuthParameters logInBodyParameters] ];;
    NSData *Body = [Body_String dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[Body length]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:Body];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPShouldHandleCookies:true];
    [self.webView loadRequest: request];
}

- (void)takeCode {
    // cookies
    WKHTTPCookieStore *cookieStore = self.webView.configuration.websiteDataStore.httpCookieStore;
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    NSDictionary *headers = [[NSDictionary alloc] init];
    [cookieStore getAllCookies:^(NSArray* cookies) {
        NSLog(@"cookies.count = %lu", (unsigned long)cookies.count);
        if (cookies.count > 0) {
            for (NSHTTPCookie *cookie in cookies) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                [cookieArray addObject:cookie];

                //NSLog(@"cookie = %@", cookie);
            }
        }
    }];
    headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
    
    OAuthParameters *oAuthParameters = [OAuthParameters alloc];
    NSString *urlString = [oAuthParameters takeCodeURLWithParameters];
    NSLog(@"urlString1234 = %@", urlString);
    NSURL *url = [[NSURL alloc] initWithString: urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPShouldHandleCookies:true];
    [self.webView loadRequest: request];
}

- (void) takeAccessToken : (NSString *) Code_Value {
    // get URL with Parameters
    OAuthParameters *oAuthParameters = [OAuthParameters alloc];
    NSURL *url = [[NSURL alloc] initWithString: [oAuthParameters takeAccessTokenURLWithCodeParameters]];
    
    NSString *Body_String = [oAuthParameters Parameters_Merge:[oAuthParameters takeAccessTokenBodyParameters:Code_Value] ];;
    NSData *Body = [Body_String dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[Body length]];
    NSLog(@"Body_String = %@", Body_String);
    NSLog(@"URLOFTEAKEAT = %@", url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:Body];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPShouldHandleCookies:true];
    [self.webView loadRequest: request];
}
  
- (void) takeRefreshAccesssTokenThroughRefreshToken : (NSString *) Refresh_Token {
    // get URL with Parameters
    OAuthParameters *oAuthParameters = [OAuthParameters alloc];
    NSURL *url = [[NSURL alloc] initWithString: [oAuthParameters takeRefreshTokenURLWithCodeParameters]];
    
    // set Body
    NSString *Body_String = [oAuthParameters Parameters_Merge:[oAuthParameters takeRefreshTokenBodyParameters:Refresh_Token] ];
    NSData *Body = [Body_String dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[Body length]];
    NSLog(@"Body_String = %@", Body_String);
    NSLog(@"URLOFTEAKEAT = %@", url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:Body];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPShouldHandleCookies:true];
    [self.webView loadRequest: request];
}
- (void) setGetCodeURL {
    
}
// 在收到 response 後，决定是否跳轉
-(void)webView:(WKWebView *)webView
decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse
decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"webViewForResponse = %@", webView);
    NSLog(@"getResponse");
    NSLog(@"responseForErrorCode = %@", navigationResponse.response);
    NSLog(@"ResponseURLNavigateURL = %@", navigationResponse.response.URL);
    NSLog(@"ResponseURLWebViewURL = %@", webView.URL);
    NSLog(@"ResponsePath = %@", [[NSURLComponents componentsWithString:navigationResponse.response.URL.absoluteString] path]);
    NSURL *URL = navigationResponse.response.URL;
    NSURLComponents *URL_Components = [NSURLComponents componentsWithString:URL.absoluteString];
    
    URLProcess *urlProcess = [URLProcess alloc];
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    // 只顯示參數的部分
    NSString *URL_Query = [URL_Components query];
    Parameters = [urlProcess getURLParameters:URL_Query];
    NSLog(@"Parameters = %@", Parameters);
    // 步驟請參考公司 pigo 建置的 github document
    // https://github.com/kjws/ouhealth-ng/blob/master/docs/API-OAuth2.md
    // 第一步驟登入後的 response
    if([[URL_Components path]  isEqual: @"/oauth/login"]) {
        decisionHandler(WKNavigationResponsePolicyAllow);
    } else if([[URL_Components path]  isEqual: @"/oauth/token"]) {
        decisionHandler(WKNavigationResponsePolicyAllow);
    } else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
//    else if ([[URL_Components path]  isEqual: @"/oauth/authorize"]) {
//        NSLog(@"Get Code Location = %@", [[navigationResponse response] URL]);
//        decisionHandler(WKNavigationResponsePolicyAllow);
//    }
//    else {
//        decisionHandler(WKNavigationResponsePolicyAllow);
//    }
}
// 読み込み開始
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

- (BOOL) HaveLogInCookies {
    // cookies
    WKHTTPCookieStore *cookieStore = self.webView.configuration.websiteDataStore.httpCookieStore;
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
@end

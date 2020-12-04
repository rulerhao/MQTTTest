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

//static NSString *const RequestURL = @"https://www.google.com/";
//NSString *RequestURL = @"https://www.google.com/";

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // UIView *baseView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSLog(@"GetInto = %@", self);
//    WKWebView *webView = [[WKWebView alloc] init];
//
//    webView.UIDelegate = self;
//    webView.navigationDelegate = self;
//    webView.frame = CGRectMake(0, 0, 400, 270);
//    self.view = webView;
//    NSURL *url = [NSURL URLWithString:@"https://www.google.com"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//
//    [webView loadRequest:request];


}
- (void)viewDidAppear:(BOOL)animated
{
    [self setupWebView];
    OAuthParameters *oAuthParameters = [OAuthParameters alloc];
    NSString *RequestURL = [oAuthParameters logInURLWithParameters];
    [self logIn: RequestURL];
    // 當登錄完成後做 get code 動作
    //[self.view setBackgroundColor:DDMakeColor(50, 50, 50)];
}

- (void)setupWebView
{
    //UIView *baseWebView = [[UIView alloc] initWithFrame:CGRectZero];
    self.webView = [[WKWebView alloc] initWithFrame: CGRectZero];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    
    [self.view addSubview:self.webView];
    // Constraint
    [self setupWKWebViewConstain: self.webView];
}

// 登錄用的URL設定
- (void)logIn:(NSString *)requestURLString
{
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

- (void)takeCode
{
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

                NSLog(@"cookie = %@", cookie);
            }
        }
    }];
    headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
    
    OAuthParameters *oAuthParameters = [OAuthParameters alloc];
    NSString *urlString = [oAuthParameters takeCodeURLWithParameters];
    NSURL *url = [[NSURL alloc] initWithString: urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPShouldHandleCookies:true];
    [self.webView loadRequest: request];
}
- (void) setGetCodeURL
{
    
}
// 完整讀取完頁面
-(void)webView:(WKWebView *)webView
decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse
decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSURL *URL = navigationResponse.response.URL;
    NSURLComponents *URL_Components = [NSURLComponents componentsWithString:URL.absoluteString];
//    if([[URL_Components path]  isEqual: @"/oauth/login"]) {
//        [self takeCode];
//    }
//    else if([[URL_Components path]  isEqual: @"/oauth/authorize"]) {
//    }                
    [self takeCode];
    decisionHandler(WKNavigationResponsePolicyAllow);
}
// 読み込み開始
- (void)
webView:(WKWebView *)webView
didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"didStartProvisionalNavigation");
    NSLog(@"webView = %@", webView.URL);
    NSLog(@"           ");
}

- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        decisionHandler(WKNavigationActionPolicyCancel);
        NSLog(@"WKNavigationActionPolicyCancel");

    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
        NSLog(@"WKNavigationActionPolicyAllow");
    }
}
/// autoLayoutをセット
- (void)setupWKWebViewConstain: (WKWebView *)webView {
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // ４辺のマージンを0にする
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

@end

//
//  RequestOAuth2Steps.m
//  MQTTTest
//
//  Created by louie on 2020/12/10.
//

#import "RequestOAuth2Steps.h"

@interface RequestOAuth2Steps ()

@end

@implementation RequestOAuth2Steps

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 登錄用的URL設定
- (void)
logIn       :   (NSString *)    requestURLString
wKWebView   :   (WKWebView *)   WKWebView {
    NSURL *url = [[NSURL alloc] initWithString: requestURLString];
    OAuthParameters *oAuthParameters = [OAuthParameters alloc];
    NSString *Body_String = [oAuthParameters Parameters_Merge:[oAuthParameters logInBodyParameters] ];;
    NSData *Body = [Body_String dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSLog(@"BodyTest = %@", Body);
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[Body length]];
    NSLog(@"WKWebViewDelegate = %@", [WKWebView UIDelegate]);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSLog(@"WKWebView = %@", WKWebView);
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:Body];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPShouldHandleCookies:true];
    NSLog(@"Request = %@", request);
    [WKWebView loadRequest: request];
}

- (void)takeCode : (WKWebView *) WKWebView {
    // cookies
    WKHTTPCookieStore *cookieStore = WKWebView.configuration.websiteDataStore.httpCookieStore;
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    NSDictionary *headers = [[NSDictionary alloc] init];
    [cookieStore getAllCookies:^(NSArray* cookies) {
        NSLog(@"cookies.count = %lu", (unsigned long)cookies.count);
        if (cookies.count > 0) {
            for (NSHTTPCookie *cookie in cookies) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                [cookieArray addObject:cookie];
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
    [WKWebView loadRequest: request];
}

- (void)
takeAccessToken : (NSString *) Code_Value
wKWebView       : (WKWebView *) WKWebView {
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
    [WKWebView loadRequest: request];
}
  
- (void)
takeRefreshAccesssTokenThroughRefreshToken : (NSString *)  Refresh_Token
wKWebView                                  : (WKWebView *) WKWebView {
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
    [WKWebView loadRequest: request];
}

- (void)
takeOTP         : (NSString *)  Access_Token
wKWebView       : (WKWebView *) WKWebView {
    OAuthParameters *oAuthParemeters = [OAuthParameters alloc];
    NSURL *URL = [[NSURL alloc] initWithString: [oAuthParemeters takeBearerTokenURLWithCodeParameters]];
    NSString *JSON_String = [oAuthParemeters takeBearerTokenBodyParameters];
    NSData *requestData = [NSData dataWithBytes:[JSON_String UTF8String] length:[JSON_String lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", Access_Token];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestData];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPShouldHandleCookies:true];

    [WKWebView loadRequest: request];
}
@end

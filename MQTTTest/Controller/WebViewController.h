//
//  WebViewController.h
//  MQTTTest
//
//  Created by louie on 2020/11/27.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <OIDAuthorizationRequest.h>
#import <OIDAuthState.h>
#import <OIDAuthorizationService.h>
#import "OAuthParameters.h"
#import "URLProcess.h"
#import "HTMLProcess.h"
#import "JSONProcess.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController <WKUIDelegate, WKNavigationDelegate>

@end

NS_ASSUME_NONNULL_END

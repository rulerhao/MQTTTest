//
//  HTMLProcess.m
//  MQTTTest
//
//  Created by louie on 2020/12/8.
//

#import "HTMLProcess.h"

@interface HTMLProcess ()

@end

@implementation HTMLProcess

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (nullable NSString *) getHTMLString : (WKWebView *) webView {
//    NSString __block *Return_HTML_String = nil;
    NSString *HaveA = @"NiceDay";
    [webView evaluateJavaScript:@"document.documentElement.outerHTML" completionHandler:^(id result, NSError *error) {
        NSLog(@"Evaluateerror = %@", error);
        NSLog(@"Evaluateresult = %@", result);
        if (error == nil) {
            if (result != nil) {
//                Return_HTML_String = [NSString stringWithFormat:@"%@", result];
            }
        } else {
            NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
        }
    }];
    return nil;
//    return Return_HTML_String;
}
@end

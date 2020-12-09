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

// 取得HTML所以字串
- (nullable NSString *)
getHTMLString   : (id) WebView_Controller
webView         : (WKWebView *)         WebView {
    __block NSString *Return_HTML_String = nil;
    
    [WebView evaluateJavaScript:@"document.documentElement.outerHTML"
              completionHandler:^(id result, NSError *error) {
        NSLog(@"Evaluateerror = %@", error);
        NSLog(@"Evaluateresult = %@", result);
        if (error == nil) {
            if (result != nil) {
                Return_HTML_String = [NSString stringWithFormat:@"%@", result];
                NSDictionary *HTML_String_Dict = [NSDictionary dictionaryWithObject:Return_HTML_String forKey:@"HTML_String"];
                [[NSNotificationCenter defaultCenter]
                    postNotificationName:@"NotificationName" //Notification以一個字串(Name)下去辨別
                    object:WebView_Controller
                    userInfo:HTML_String_Dict];
            }
        } else {
            NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
        }
    }];
    return Return_HTML_String;
}

- (NSString *) htmlStringToJSONFormatString : (NSString *) HTML_String {
    NSRange JSON_Range;
    NSRange Left_Quote_Range = [HTML_String rangeOfString:@"{"];
    NSRange Right_Quote_Range = [HTML_String rangeOfString:@"}"];
    JSON_Range = NSMakeRange(Left_Quote_Range.location, Right_Quote_Range.location - Left_Quote_Range.location + 1);
    NSString *HTTP_String_JSON = [HTML_String substringWithRange:JSON_Range];
    
    return HTTP_String_JSON;
}
@end

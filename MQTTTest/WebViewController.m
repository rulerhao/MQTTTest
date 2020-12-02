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
    NSString *RequestURL = [self getURL_With_Parameters];
    [self setURL: RequestURL];
    
    [self.view setBackgroundColor:DDMakeColor(50, 50, 50)];
}

- (void)setupWebView
{
    //UIView *baseWebView = [[UIView alloc] initWithFrame:CGRectZero];
    self.webView = [[WKWebView alloc] initWithFrame: CGRectMake(0, 0, 200, 600)];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    
    [self.view addSubview:self.webView];
    //[self setupWKWebViewConstain: self.webView];
    //[self.baseView addSubview: self.webView];
    [self setupWKWebViewConstain: self.webView];
}

- (void)setURL:(NSString *)requestURLString
{
    NSURL *url = [[NSURL alloc] initWithString: requestURLString];
    
    NSString *Body_String = [self Parameters_Merge:[self Login_Body_Parameters] ];;
    NSData *Body = [Body_String dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[Body length]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:Body];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    //NSLog(@"url = %@", request.HTTPBody.bytes);
    
    [self.webView loadRequest: request];
    //[]
    [request HTTPBodyStream];
}

// 読み込み開始
- (void)
webView:(WKWebView *)webView
didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"webView = %@", webView.URL);
    NSLog(@"           ");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        decisionHandler(WKNavigationActionPolicyCancel);
        NSLog(@"WKNavigationActionPolicyCancel");
        
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
        NSLog(@"webView = %@", navigationAction.request.URL);
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

/**
 * 例如 Parameter[0] 現在變成 Cilent_ID
 * Parameter[0][0] 現在變成 Client_ID_Title
 * Parameter[0][1] 現在變成 Client_ID_Value
 */
- (NSMutableArray *) LoginParameter {
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    
    NSString *Client_ID_Title = @"client_id";
    NSString *Client_ID_Value = @"c90ccc19-2fab-11eb-a13f-02420a00080e";
    NSMutableArray *Parameters_For_Client_ID =[[NSMutableArray alloc] init];
    [Parameters_For_Client_ID addObject:Client_ID_Title];
    [Parameters_For_Client_ID addObject:Client_ID_Value];
    [Parameters addObject:Parameters_For_Client_ID];
    
    NSString *Redirect_URL_Title = @"redirect_uri";
    NSString *Redirect_URL_Value = @"oucare://oauth2/callback";
    NSMutableArray *Parameters_For_Redirect_URL =[[NSMutableArray alloc] init];
    [Parameters_For_Redirect_URL addObject:Redirect_URL_Title];
    [Parameters_For_Redirect_URL addObject:Redirect_URL_Value];
    [Parameters addObject:Parameters_For_Redirect_URL];
    
    NSString *Scope_Title = @"scope";
    NSString *Scope_Value = @"connect-ouhub";
    NSMutableArray *Parameters_For_Scope =[[NSMutableArray alloc] init];
    [Parameters_For_Scope addObject:Scope_Title];
    [Parameters_For_Scope addObject:Scope_Value];
    [Parameters addObject:Parameters_For_Scope];
    
    NSString *Response_Mode_Title = @"response_mode";
    NSString *Response_Mode_Value = @"json";
    NSMutableArray *Parameters_For_Response_Mode =[[NSMutableArray alloc] init];
    [Parameters_For_Response_Mode addObject:Response_Mode_Title];
    [Parameters_For_Response_Mode addObject:Response_Mode_Value];
    [Parameters addObject:Parameters_For_Response_Mode];
    
    NSString *Code_Challenge_Title = @"code_challenge";
    NSString *Code_Challenge_Value = @"ocYCWfMwcSjWZok91g7EAZsKLdqPI7Nn_qoUWIdHHM4";
    NSMutableArray *Parameters_For_Code_Challenge =[[NSMutableArray alloc] init];
    [Parameters_For_Code_Challenge addObject:Code_Challenge_Title];
    [Parameters_For_Code_Challenge addObject:Code_Challenge_Value];
    [Parameters addObject:Parameters_For_Code_Challenge];
    
    NSLog(@"Test = %@", [[Parameters objectAtIndex:0] objectAtIndex:0]);
    return Parameters;
}
- (NSString *) Parameters_Merge : (NSMutableArray *) Parameters {
    NSUInteger Parameters_Number = [Parameters count];
    NSString *Parameters_String = @"";
    NSString *Parameters_And = @"&";
    NSString *Parameters_Is = @"=";
    for(NSUInteger i = 0; i < Parameters_Number; i++) {
        NSString *Title = [[Parameters objectAtIndex:i] objectAtIndex:0];
        NSString *Value = [[Parameters objectAtIndex:i] objectAtIndex:1];
        if (i == 0) Parameters_String = [NSString stringWithFormat:@"%@%@%@%@", Parameters_String, Title, Parameters_Is, Value];
        else Parameters_String = [NSString stringWithFormat:@"%@%@%@%@%@", Parameters_String, Parameters_And, Title, Parameters_Is, Value];
    }
    return Parameters_String;
}
- (NSMutableArray *) Login_Body_Parameters {
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    NSString *User_Name_Title = @"username";
    NSString *Uesr_Name_Value = @"kjump";
    NSMutableArray *Parameters_For_Uesr_Name =[[NSMutableArray alloc] init];
    [Parameters_For_Uesr_Name addObject:User_Name_Title];
    [Parameters_For_Uesr_Name addObject:Uesr_Name_Value];
    [Parameters addObject:Parameters_For_Uesr_Name];
    
    NSString *Password_Title = @"password";
    NSString *Password_Value = @"1234qwer";
    NSMutableArray *Parameters_For_Password =[[NSMutableArray alloc] init];
    [Parameters_For_Password addObject:Password_Title];
    [Parameters_For_Password addObject:Password_Value];
    [Parameters addObject:Parameters_For_Password];
    return Parameters;
}
- (NSString *) getURL_With_Parameters {
    NSString *URL_With_Parameters = @"";
    NSString *Origin_URL = @"https://healthng.oucare.com/oauth/login";
    NSString *Parameters_Syntax = @"?";
    
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    Parameters = [self LoginParameter];
    NSString *Parameters_String;
    // get string contains all parameters
    Parameters_String = [self Parameters_Merge:Parameters];
    NSLog(@"Parameters_String = %@", Parameters_String);
    // get string url with all parameters
    URL_With_Parameters = [NSString stringWithFormat:@"%@%@%@", Origin_URL, Parameters_Syntax, Parameters_String];
    NSLog(@"URL_With_Parameters = %@", URL_With_Parameters);
    return URL_With_Parameters;
}

@end

//
//  UUIDVProcess.m
//  MQTTTest
//
//  Created by louie on 2020/11/23.
//

#import "UUIDVProcess.h"

@interface UUIDVProcess ()

@end

@implementation UUIDVProcess

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *VendorIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)
deleteSubString : (NSString *) UUID_String
subString       : (NSString *) SubString
{
    NSLog(@"IndexNumber = ", [@"hello bla bla" rangeOfString:@"bla"].location);
    NSString *string = @"hello bla bla";
    if ([string rangeOfString:@"bla"].location == NSNotFound) {
      NSLog(@"string does not contain bla");
    } else {
      NSLog(@"string contains bla!");
    }
    return @"apple";
}
@end

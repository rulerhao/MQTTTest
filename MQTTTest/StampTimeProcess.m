//
//  StampTimeProcess.m
//  MQTTTest
//
//  Created by louie on 2020/11/19.
//

#import "StampTimeProcess.h"

@interface StampTimeProcess ()

@end

@implementation StampTimeProcess

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (UInt32) getTimeStampSecond
{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    UInt32 timeStampLong = timeStamp;
    NSLog(@"timeStampLong:%lu", (unsigned long)timeStampLong);
    return timeStampLong;
}

- (UInt32) getTimeStampNanosecond
{
    StringProcessFunc *stringProcessFunctioc = [[StringProcessFunc alloc] init];
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    NSString *timeStampString = [timeStampObj stringValue];
    NSLog(@"timeStampString:%@", timeStampString);
    NSString *StringAfterPoint = [stringProcessFunctioc getSubString:timeStampString
                                                              length:[timeStampString length] - 11
                                                            location:11];
    UInt32 NanoSecond = [StringAfterPoint intValue] * 1000;
    NSLog(@"timeStampLong:%lu", (unsigned long)NanoSecond);
    return NanoSecond;
}

@end

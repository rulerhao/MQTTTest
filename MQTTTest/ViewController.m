//
//  ViewController.m
//  MQTTTest
//
//  Created by louie on 2020/11/11.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>


MQTTSession* MySeccion;


@interface ViewController ()


@end

@implementation ViewController

NSString *Client_ID;

MQTTSession *Session;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MQTTSetting *MqttSetting = [[MQTTSetting alloc] init];
    [MqttSetting InitMQTTSetting];
    
    [MqttSetting.Session setDelegate:self];
    
    [MqttSetting.Session setKeepAliveInterval:5];
    
    [MqttSetting.Session connectAndWaitTimeout:15];
    
    
}
/**
 * 按下 Publish button 的觸發事件
 */
NSUInteger count = 0;
- (IBAction)TouchDownPublishButton:(id)sender
{
    PublishDataFor4320 *publishDataFor4320 = [[PublishDataFor4320 alloc] init];
    NSData *PublishData = [publishDataFor4320 getPublishData:@"KS-4310"
                                               Device_Serial:@"S15"
                                                 Device_UUID:@"92ee96a6-ff9a-11ea-8fd3-0242ac160004"
                                                Temperature1:30
                                                Temperature2:35
                                                Temperature3:40
                                                     Battery:50
                                                      Breath:false
                                                    Motion_X:123.1
                                                    Motion_Y:252.6
                                                    Motion_Z:929.1];
    NSLog(@"TestForIn");
    [publishDataFor4320 publishData:PublishData
                            session:Session];
}

/**
 * 當執行 [MySeccion connectAndWaitTimeout:time]; 時觸發
 */
-(void)
handleEvent:(MQTTSession *)session
      event:(MQTTSessionEvent)eventCode
      error:(NSError *)error
{
    Session = session;
    NSLog(@"actuallyScssion:%ld ", (long)eventCode);
    if (eventCode == MQTTSessionEventConnected)
    {
        NSLog(@"MQTTStatus : Connected");
        // Subscribe part
        
        [session subscribeToTopic:@"/ouhub/requests"
                            atLevel:MQTTQosLevelAtMostOnce
                   subscribeHandler:
         ^(NSError *error,
           NSArray<NSNumber *> *gQoss)
        {
            if (error)
            {
                NSLog(@"MQTTStatuserror:%@",error);
            }
            else
            {
                Session = session;
                NSLog(@"MQTTStatusOK:%@",gQoss);
            }
        }];
         
    }
    else if (eventCode == MQTTSessionEventConnectionRefused)
    {
        NSLog(@"MQTTStatus : refused");
    }
    else if (eventCode == MQTTSessionEventConnectionClosed)
    {
        NSLog(@"MQTTStatus : closed");
        [session connectAndWaitTimeout:15];
    }
    else if (eventCode == MQTTSessionEventConnectionError)
    {
        NSLog(@"MQTTStatus : error");
    }
    else if (eventCode == MQTTSessionEventProtocolError)
    {
        NSLog(@"MQTTStatus : MQTTSessionEventProtocolError");
    }
    else{//MQTTSessionEventConnectionClosedByBroker
        NSLog(@"MQTTStatus : other");
    }
    if (error)
    {
        NSLog(@"MQTTStatus error  -- %@",error);
    }
}

- (void)newMessage:(MQTTSession *)session
              data:(NSData *)data
           onTopic:(NSString *)topic
               qos:(MQTTQosLevel)qos
          retained:(BOOL)retained
               mid:(unsigned int)mid
{
    TypesConversion *typesConversion = [[TypesConversion alloc] init];
    NSLog(@"IntoNewMessage");
    NSLog(@"DataForReturn:%@", [typesConversion getHEX:data]);
    NSLog(@"DataForReturn:%lu", (unsigned long)[[typesConversion getHEX:data] length]);
    NSString *NewString = @"";
    StringProcessFunc *stringProcessFunction = [[StringProcessFunc alloc] init];
    for(int i = 0; i < [[typesConversion getHEX:data] length]; i = i + 2)
    {
        NewString = [stringProcessFunction MergeTwoString:NewString
                                                SecondStr:[stringProcessFunction getSubString:[typesConversion getHEX:data]
                                                                                       length:2
                                                                                     location:i]];
        NewString = [stringProcessFunction MergeTwoString:NewString SecondStr:@" "];
        
    }
    NSLog(@"NewString :%@", NewString);
    
}
@end

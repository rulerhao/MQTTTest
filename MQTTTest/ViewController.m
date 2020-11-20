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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     * 取得 Vendor Identifier
     * 此 identifier 會依據app 的發行商而變更
     * 也因此單一對於想取得手機的身份卻又不希望他變更時可以選用這個
    */
    
    NSString *VendorIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"UUID2:%@", [[[UIDevice currentDevice] identifierForVendor] UUIDString]);
    
    MQTTWebsocketTransport *Transport = [[MQTTWebsocketTransport alloc] init];
    
    Transport.host = @"healthng.oucare.com";
    Transport.port = 1885;
    Transport.tls = YES;
    
    MySeccion = [[MQTTSession alloc] init];
    
    [MySeccion setTransport:Transport];
    [MySeccion setDelegate:self];
    
    [MySeccion setUserName:@"kjump"];
    [MySeccion setPassword:@"1234qwer"];
    [MySeccion setClientId:@"Jake"];
    
    [MySeccion setKeepAliveInterval:5];
    
    [MySeccion addObserver:self
                forKeyPath:@"state"
                   options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                   context:nil];
    
    [MySeccion connectAndWaitTimeout:15];
    
    
}

-(void)
handleEvent:(MQTTSession *)session
      event:(MQTTSessionEvent)eventCode
      error:(NSError *)error
{
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
                NSLog(@"MQTTStatusOK:%@",gQoss);
                
                [NSTimer scheduledTimerWithTimeInterval:1
                                                repeats:YES
                                                  block:^(NSTimer * _Nonnull timer)
                {
                    static NSInteger num = 0;
                    
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
                    
                    [session publishData:PublishData
                                 onTopic:@"/ouhub/requests"
                                  retain:NO
                                     qos:MQTTQosLevelAtMostOnce
                          publishHandler:^(NSError *error)
                    {
                        if (error)
                        {
                            NSLog(@"PulbishForSameTimeerror - %@",error);
                        }
                        
                        else
                        {
                            NSLog(@"send ok");
                        }
                    }];
                    
                    NSLog(@"%ld", (long)num);
                    if (num > 1)
                    {
                        [timer invalidate];
                        NSLog(@"end");
                    }
                 
                }];
                 
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
    TypesCoversion *typesConversion = [[TypesCoversion alloc] init];
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

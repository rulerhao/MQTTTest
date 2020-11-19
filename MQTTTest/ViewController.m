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
    
    //ˇˇˇˇˇˇˇˇˇˇˇˇ 這邊不用管 只是無聊測試ˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇ
    /*
    ProtoBufSwift *swift = [[ProtoBufSwift alloc] init];
    NSString *TestStr = [swift protoBufSwift];
    NSLog(@"TestStr:%@", TestStr);
    [swift proto2];
     */
    //^^^^^^^^^^^^ 這邊不用管 只是無聊測試^^^^^^^^^^^^^^^^^^
    
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
        NSLog(@"MQTT : Connected");
        // Subscribe part
        [session subscribeToTopic:@"/ouhub/requests"
                            atLevel:MQTTQosLevelAtMostOnce
                   subscribeHandler:
         ^(NSError *error,
           NSArray<NSNumber *> *gQoss)
        {
            if (error)
            {
                NSLog(@"error:%@",error);
            }
            else
            {
                NSLog(@"OK:%@",gQoss);
                
                [NSTimer scheduledTimerWithTimeInterval:1
                                                repeats:YES
                                                  block:^(NSTimer * _Nonnull timer)
                {
                    static NSInteger num = 0;
                    
                    PublishDataFor4320 *publishDataFor4320 = [[PublishDataFor4320 alloc] init];
                    NSData *PublishData = [publishDataFor4320 getPublishData:@"KS-4310"
                                                               Device_Serial:@"S10"
                                                                 Device_UUID:@"92ee96a5-ff9a-11ea-8fd3-0242ac160004"
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
                            NSLog(@"error - %@",error);
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
        NSLog(@"MQTT : refused");
    }
    else if (eventCode == MQTTSessionEventConnectionClosed)
    {
        NSLog(@"MQTT : closed");
        [session connectAndWaitTimeout:15];
    }
    else if (eventCode == MQTTSessionEventConnectionError)
    {
        NSLog(@"MQTT : error");
    }
    else if (eventCode == MQTTSessionEventProtocolError)
    {
        NSLog(@"MQTT : MQTTSessionEventProtocolError");
    }
    else{//MQTTSessionEventConnectionClosedByBroker
        NSLog(@"MQTT : other");
    }
    if (error)
    {
        NSLog(@"error  -- %@",error);
    }
}

- (void)newMessage:(MQTTSession *)session
              data:(NSData *)data
           onTopic:(NSString *)topic
               qos:(MQTTQosLevel)qos
          retained:(BOOL)retained
               mid:(unsigned int)mid
{
    NSLog(@"IntoNewMessage");
    NSLog(@"DataForReturn:%@", [self getHEX:data]);
    NSLog(@"DataForReturn:%lu", (unsigned long)[[self getHEX:data] length]);
    NSString *NewString = @"";
    StringProcessFunc *stringProcessFunction = [[StringProcessFunc alloc] init];
    for(int i = 0; i < [[self getHEX:data] length]; i = i + 2)
    {
        NewString = [stringProcessFunction MergeTwoString:NewString
                                                SecondStr:[stringProcessFunction getSubString:[self getHEX:data]
                                                                                       length:2
                                                                                     location:i]];
        NewString = [stringProcessFunction MergeTwoString:NewString SecondStr:@" "];
        
    }
    NSLog(@"NewString :%@", NewString);
    
}

/*!
 * @param data_bytes : 要被轉換為 Hex String 的 NSData
 *  @discussion
 *      將 NSData 轉換為 HexString
 *
 */
- (NSString *)getHEX:(NSData *)data_bytes
{
    const unsigned char *dataBytes = [data_bytes bytes];
    NSMutableString *ret = [NSMutableString stringWithCapacity:[data_bytes length] * 2];
    for (int i = 0; i<[data_bytes length]; ++i)
    [ret appendFormat:@"%02lX", (unsigned long)dataBytes[i]];
    return ret;
}

@end

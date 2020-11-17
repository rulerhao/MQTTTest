//
//  ViewController.m
//  MQTTTest
//
//  Created by louie on 2020/11/11.
//

#import "ViewController.h"
#import "Sensor.pbobjc.h"

MQTTSession* MySeccion;


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ProtoBufSwift *swift = [[ProtoBufSwift alloc] init];
    NSString *TestStr = [swift protoBufSwift];
    NSLog(@"TestStr:%@", TestStr);
    [swift proto2];
    
    Sensor *sensor = [[Sensor alloc] init];
    sensor.batteryProperty.value = 50;
    sensor.breathProperty.value = true;
    sensor.temperatureProperty.value = 23;
    
    NSData *sensorData = [sensor data];
    NSLog(@"sensorData:%@", sensorData);
    NSError *error = nil;
    
    Sensor *sensorGet = [Sensor parseFromData:sensorData
                                        error:nil];
    NSLog(@"sensorGet:%d", sensorGet.batteryProperty.value);
    
    
    // Do any additional setup after loading the view.
    
    MQTTWebsocketTransport *Transport = [[MQTTWebsocketTransport alloc] init];
    /*
    Transport.host = @"healthng.oucare.com";
    Transport.port = 1884;
    Transport.tls = NO;
    */
    Transport.host = @"healthng.oucare.com";
    Transport.port = 1885;
    Transport.tls = YES;
    
    MySeccion = [[MQTTSession alloc] init];
    
    [MySeccion setTransport:Transport];
    [MySeccion setDelegate:self];
    
    //NSString *linkUserName = @"kjump";
    //NSString *linkPassWord = @"1234qwer";
    //NSString *linkUserName = @"kjump";
    //NSString *linkPassWord = @"1234qwer";
    //NSString *clientID = @"00001";
    
    //[MySeccion setUserName:linkUserName];
    //[MySeccion setPassword:linkPassWord];
    //[MySeccion setClientId:clientID];
    
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
        NSLog(@"2222222 成功");
//        [self.session subscribeTopic:@"/ouhub/clients/Gimmy"];
        
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
                
                const uint8_t bytes[] = {0x04};
                
                NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
                
                [session publishData:data
                                 onTopic:@"/ouhub/requests"
                                  retain:NO qos:MQTTQosLevelAtMostOnce
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
                
                [session publishData:data
                                 onTopic:@"/ouhub/requests"
                                  retain:NO qos:MQTTQosLevelAtMostOnce
                          publishHandler:^(NSError *error)
                {
                    if (error)
                    {
                        NSLog(@"error - %@",error);
                    }
                    
                    else
                    {
                        NSLog(@"send ok2");
                    }
                }];
                
            }
        }];
    }
    else if (eventCode == MQTTSessionEventConnectionRefused)
    {
        NSLog(@"MQTT refused");
    }
    else if (eventCode == MQTTSessionEventConnectionClosed)
    {
        NSLog(@"MQTT closed");
        [session connectAndWaitTimeout:15];
    }
    else if (eventCode == MQTTSessionEventConnectionError)
    {
        NSLog(@"MQTT error");
    }
    else if (eventCode == MQTTSessionEventProtocolError)
    {
        NSLog(@"MQTT MQTTSessionEventProtocolError");
    }
    else{//MQTTSessionEventConnectionClosedByBroker
        NSLog(@"MQTT other");
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
    NSLog(@"Data:%@", [self getHEX:data]);
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

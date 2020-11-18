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
    
    sensor.batteryProperty.value = 1;
    sensor.temperatureProperty.value = 1;
    sensorData = [sensor data];
    NSLog(@"sensorData:%@", sensorData);
    
    GPBTimestamp *GPBTS = [[GPBTimestamp alloc] init];
    [GPBTS date];
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
    
    NSString *linkUserName = @"kjump";
    NSString *linkPassWord = @"1234qwer";
    NSString *clientID = @"00005";
    
    [MySeccion setUserName:linkUserName];
    [MySeccion setPassword:linkPassWord];
    [MySeccion setClientId:clientID];
    
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
                
                [NSTimer scheduledTimerWithTimeInterval:1
                                                repeats:YES
                                                  block:^(NSTimer * _Nonnull timer)
                {
                    static NSInteger num = 3;
                    
                    [session publishData:[self getpublishData]
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
                    if (num > 4)
                    {
                        [timer invalidate];
                        NSLog(@"end");
                    }
                }];
                
                [session publishData:data
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
    NSLog(@"DataForReturn:%@", [self getHEX:data]);
    NSLog(@"DataForReturn:%lu", (unsigned long)[data length]);
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

- (NSData*) getpublishData
{
    //
    Message *message = [[Message alloc] init];
    PostMeasureRequest *request = [[PostMeasureRequest alloc] init];
    
    NSMutableArray *recordList = [[NSMutableArray alloc] init];
    
    for(NSInteger i = 0; i < 1; i++)
    {
        Sensor *sensor = [[Sensor alloc] init];
        MeasureRecord *record = [[MeasureRecord alloc] init];
        DeviceProperty *deviceProperty = [[DeviceProperty alloc] init];
        GPBTimestamp *measuredAt = [[GPBTimestamp alloc] init];
        
        //long timeStampLong = timeStamp;
        //NSLog(@"UpperTimeStamp:%f", floor(timeStamp));
        //NSLog(@"UpperTimeStamp:%ld", timeStampLong);
        [measuredAt setSeconds:[self getTimeStampSecond]];
        [measuredAt setNanos:[self getTimeStampNanosecond]];
        NSLog(@"measuredAt:%@", [measuredAt date]);
        
        [deviceProperty setModel:@"KS-4310"];
        [deviceProperty setSerial:@"00005"];
        [deviceProperty setUuid:@"00005"];
        
        [record setMeasuredAt: measuredAt];
        [record setDeviceProperty:deviceProperty];
        
        Sensor *sensorTmp0 = [[Sensor alloc] init];
        Sensor *sensorTmp1 = [[Sensor alloc] init];
        Sensor *sensorTmp2 = [[Sensor alloc] init];
        Sensor *sensorBat = [[Sensor alloc] init];
        Sensor *sensorBre = [[Sensor alloc] init];
        
        [[record sensorArray] addObject:sensorTmp0];
        [[record sensorArray] addObject:sensorTmp1];
        [[record sensorArray] addObject:sensorTmp2];
        [[record sensorArray] addObject:sensorBat];
        [[record sensorArray] addObject:sensorBre];
        
        Sensor_TemperatureProperty *tmp0Property = [[Sensor_TemperatureProperty alloc] init];
        Sensor_TemperatureProperty *tmp1Property = [[Sensor_TemperatureProperty alloc] init];
        Sensor_TemperatureProperty *tmp2Property = [[Sensor_TemperatureProperty alloc] init];
        Sensor_BatteryProperty *batProperty = [[Sensor_BatteryProperty alloc] init];
        Sensor_BreathProperty *breProperty = [[Sensor_BreathProperty alloc] init];
        
        [tmp0Property setValue:30];
        [tmp1Property setValue:35];
        [tmp2Property setValue:40];
        [batProperty setValue:50];
        [breProperty setValue:false];
        Sensor_MotionProperty *motionProperty = [[Sensor_MotionProperty alloc] init];
        [motionProperty setValueX:123.1];
        [motionProperty setValueY:252.6];
        [motionProperty setValueZ:929.1];
        [breProperty setMotionProperty:motionProperty];
        
        [sensorTmp0 setIndex:0];
        [sensorTmp0 setTemperatureProperty:tmp0Property];
        [sensorTmp1 setIndex:1];
        [sensorTmp1 setTemperatureProperty:tmp1Property];
        [sensorTmp2 setIndex:2];
        [sensorTmp2 setTemperatureProperty:tmp2Property];
        [sensorBat setIndex:0];
        [sensor setBatteryProperty:batProperty];
        [sensorBre setIndex:0];
        [sensor setBreathProperty:breProperty];
        [recordList addObject:record];
    }
    
    [request setRecordArray:recordList];
    
    [message setPostMeasureRequest:request];
    [message setMessageId:[self getTimeStampAsString]];
    [message setClientId:@"00005"];
    
    NSData *publishData = [message data];
    NSLog(@"ddata%@", publishData);
    return publishData;
}

- (NSString *) getTimeStampAsString
{
    StringProcessFunc *stringProcessFunctioc = [[StringProcessFunc alloc] init];
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    // NSTimeInterval is defined as double
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    NSString *timeStampString = [timeStampObj stringValue];
    NSString *StringBeforePoint = [stringProcessFunctioc getSubString:timeStampString
                                                               length:10
                                                             location:0];
    NSString *StringAfterPoint = [stringProcessFunctioc getSubString:timeStampString
                                                              length:3
                                                            location:11];
    NSString *StringMerged = [stringProcessFunctioc MergeTwoString:StringBeforePoint
                                                         SecondStr:StringAfterPoint];
    return StringMerged;
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

//
//  PublishDataFor4320.m
//  MQTTTest
//
//  Created by louie on 2020/11/19.
//

#import "PublishDataFor4320.h"

@interface PublishDataFor4320 ()

@end

@implementation PublishDataFor4320

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSData *)
getPublishData        : (NSString *) Model
Device_Serial         : (NSString *) Serial
Device_UUID           : (NSString *) UUID
Temperature1          : (NSInteger)  t1
Temperature2          : (NSInteger)  t2
Temperature3          : (NSInteger)  t3
Battery               : (int)        bat
Breath                : (BOOL)       bre
Motion_X              : (float)      motion_X
Motion_Y              : (float)      motion_Y
Motion_Z              : (float)      motion_Z
{
    //
    Message *message = [[Message alloc] init];
    PostMeasureRequest *request = [[PostMeasureRequest alloc] init];
    
    NSMutableArray *recordList = [[NSMutableArray alloc] init];
    
    for(NSInteger i = 0; i < 1; i++)
    {
        MeasureRecord *record = [[MeasureRecord alloc] init];
        DeviceProperty *deviceProperty = [[DeviceProperty alloc] init];
        GPBTimestamp *measuredAt = [[GPBTimestamp alloc] init];
        [deviceProperty setModel:Model];
        [deviceProperty setSerial:Serial];
        [deviceProperty setUuid:UUID];
        
        StampTimeProcess *stampTimeProcess = [[StampTimeProcess alloc] init];
        
        [measuredAt setSeconds:[stampTimeProcess getTimeStampSecond]];
        [measuredAt setNanos:[stampTimeProcess getTimeStampNanosecond]];
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
        

        [tmp0Property setValue:t1];
        [tmp1Property setValue:t2];
        [tmp2Property setValue:t3];
        [batProperty setValue:bat];
        [breProperty setValue:bre];
        Sensor_MotionProperty *motionProperty = [[Sensor_MotionProperty alloc] init];
        [motionProperty setValueX:motion_X];
        [motionProperty setValueY:motion_Y];
        [motionProperty setValueZ:motion_Z];
        [breProperty setMotionProperty:motionProperty];
        
        [sensorTmp0 setIndex:0];
        [sensorTmp0 setTemperatureProperty:tmp0Property];
        [sensorTmp1 setIndex:1];
        [sensorTmp1 setTemperatureProperty:tmp1Property];
        [sensorTmp2 setIndex:2];
        [sensorTmp2 setTemperatureProperty:tmp2Property];
        
        [sensorBat setIndex:0];
        [sensorBat setBatteryProperty:batProperty];
        
        [sensorBre setIndex:0];
        [sensorBre setBreathProperty:breProperty];
        
        [recordList addObject:record];
    }
    
    [request setRecordArray:recordList];
    
    [message setPostMeasureRequest:request];
    [message setMessageId:[self getTimeStampAsHexString]];
    [message setClientId:@"Jake"];
    
    NSData *publishData = [message data];
    NSLog(@"ddata%@", publishData);
    return publishData;
}

/**
 * [[ 訊息代碼 ]]
 *
 * 編碼建議 :
 *
 * 1. 取得目前時間精確到小數點 3 位
 *    例如 2020-09-26 09:46:28.472 , 轉成 `1601113588472` 為整數
 * 2. 將訊息再轉為 16 進位 格式，可以縮小長度為 `174c9ce82f8`
 * 3. 如果使用 36 進位，則會更進一步縮成 `kfjhovlk` , 基本上 Server 不管編碼方式，只要確定 message_id 不會重複即可
 *
 * 若真的很頻繁發送訊息，建議保留最後一筆 message_id 比對是否重複，若重複，則自己 + 1
 */
- (NSString *) getTimeStampAsHexString
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
    
    // 將 long 變為 Hex String
    long StampTimeLong = [StringMerged longLongValue];
    NSString *ascHex = [[NSString alloc] initWithFormat:@"%lx", (long) StampTimeLong];
    //NSLog(@"StringToASCiiHex:%@", ascHex); // StringToASCiiHex:41
    
    return ascHex;
}
@end

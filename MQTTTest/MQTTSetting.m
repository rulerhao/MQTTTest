//
//  MQTTSetting.m
//  MQTTTest
//
//  Created by louie on 2020/11/23.
//

#import "MQTTSetting.h"

@interface MQTTSetting ()

@end

@implementation MQTTSetting

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) InitMQTTSetting
{
    User_Name = @"kjump";
    Password = @"1234qwer";
    
    IDFVProcess *idfvProcess = [[IDFVProcess alloc] init];
    ClientID = [idfvProcess getClientIDFromIDFV];
    
    // Transport setting
    Transport = [[MQTTWebsocketTransport alloc] init];
    Transport.host = @"healthng.oucare.com";
    Transport.port = 1885;
    Transport.tls = YES;
    
    Session = [[MQTTSession alloc] init];
    [Session setUserName:User_Name];
    [Session setPassword:Password];
    [Session setClientId:ClientID];
    [Session setTransport:Transport];
}

@synthesize User_Name;
@synthesize Password;
@synthesize ClientID;
@synthesize Session;
@synthesize Transport;

@end

//
//  ViewController.m
//  MQTTTest
//
//  Created by louie on 2020/11/11.
//

#import "ViewController.h"

MQTTSession* MySeccion;


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MQTTWebsocketTransport *Transport = [[MQTTWebsocketTransport alloc] init];
    Transport.host = @"wss://healthng.oucare.com:1885/";
    Transport.port = 1885;
    Transport.tls = YES;
    
    MySeccion = [[MQTTSession alloc] init];
    
    [MySeccion setTransport:Transport];
    [MySeccion setDelegate:self];
    
    //NSString *linkUserName = @"kjump";
    //NSString *linkPassWord = @"1234qwer";
    NSString *linkUserName = @"kjump";
    NSString *linkPassWord = @"1234qwer";
    NSString *clientID = @"Gimmy";
    
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
        
        [MySeccion subscribeToTopic:@"/ouhub/requests"
                            atLevel:MQTTQosLevelAtMostOnce subscribeHandler:
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
        [MySeccion connectAndWaitTimeout:15];
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
        NSLog(@"Error Domain : %@", [error domain]);
        NSLog(@"Error Code : %ld", (long)[error code]);
        NSLog(@"Error User Info : ");
        NSLog(@"    KCFStream Errorr Domain Key1 :%@", [[[error userInfo] allKeys] objectAtIndex:0]);
        NSLog(@"    KCFKey1:%@", [[[error userInfo] allValues] objectAtIndex:0]);
        NSLog(@"    KCFStream Errorr Domain Key2 :%@", [[[error userInfo] allKeys] objectAtIndex:1]);
        NSLog(@"    KCFKey2:%@", [[[error userInfo] allValues] objectAtIndex:1]);
        NSLog(@"    KCFStream Errorr Domain Key3 :%@", [[[error userInfo] allKeys] objectAtIndex:2]);
        NSLog(@"    KCFKey3:%@", [[[error userInfo] allValues] objectAtIndex:2]);
    }
}

@end

// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: device.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

#import <stdatomic.h>

#import "Device.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wdollar-in-identifier-extension"

#pragma mark - Objective C Class declarations
// Forward declarations of Objective C classes that we can use as
// static values in struct initializers.
// We don't use [Foo class] because it is not a static value.
GPBObjCClassDeclaration(DeviceProperty);
GPBObjCClassDeclaration(GPBTimestamp);
GPBObjCClassDeclaration(MeasureRecord);
GPBObjCClassDeclaration(Sensor);

#pragma mark - DeviceRoot

@implementation DeviceRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - DeviceRoot_FileDescriptor

static GPBFileDescriptor *DeviceRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"ouhub.device"
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - DeviceProperty

@implementation DeviceProperty

@dynamic uuid;
@dynamic model;
@dynamic serial;

typedef struct DeviceProperty__storage_ {
  uint32_t _has_storage_[1];
  NSString *uuid;
  NSString *model;
  NSString *serial;
} DeviceProperty__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "uuid",
        .dataTypeSpecific.clazz = Nil,
        .number = DeviceProperty_FieldNumber_Uuid,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(DeviceProperty__storage_, uuid),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldClearHasIvarOnZero),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "model",
        .dataTypeSpecific.clazz = Nil,
        .number = DeviceProperty_FieldNumber_Model,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(DeviceProperty__storage_, model),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldClearHasIvarOnZero),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "serial",
        .dataTypeSpecific.clazz = Nil,
        .number = DeviceProperty_FieldNumber_Serial,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(DeviceProperty__storage_, serial),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldClearHasIvarOnZero),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[DeviceProperty class]
                                     rootClass:[DeviceRoot class]
                                          file:DeviceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(DeviceProperty__storage_)
                                         flags:(GPBDescriptorInitializationFlags)(GPBDescriptorInitializationFlag_UsesClassRefs | GPBDescriptorInitializationFlag_Proto3OptionalKnown)];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - NotifyStatusRequest

@implementation NotifyStatusRequest

@dynamic hasDeviceProperty, deviceProperty;
@dynamic code;

typedef struct NotifyStatusRequest__storage_ {
  uint32_t _has_storage_[1];
  NotifyStatusRequest_StatusCode code;
  DeviceProperty *deviceProperty;
} NotifyStatusRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "deviceProperty",
        .dataTypeSpecific.clazz = GPBObjCClass(DeviceProperty),
        .number = NotifyStatusRequest_FieldNumber_DeviceProperty,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(NotifyStatusRequest__storage_, deviceProperty),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "code",
        .dataTypeSpecific.enumDescFunc = NotifyStatusRequest_StatusCode_EnumDescriptor,
        .number = NotifyStatusRequest_FieldNumber_Code,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(NotifyStatusRequest__storage_, code),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldHasEnumDescriptor | GPBFieldClearHasIvarOnZero),
        .dataType = GPBDataTypeEnum,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[NotifyStatusRequest class]
                                     rootClass:[DeviceRoot class]
                                          file:DeviceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(NotifyStatusRequest__storage_)
                                         flags:(GPBDescriptorInitializationFlags)(GPBDescriptorInitializationFlag_UsesClassRefs | GPBDescriptorInitializationFlag_Proto3OptionalKnown)];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t NotifyStatusRequest_Code_RawValue(NotifyStatusRequest *message) {
  GPBDescriptor *descriptor = [NotifyStatusRequest descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:NotifyStatusRequest_FieldNumber_Code];
  return GPBGetMessageRawEnumField(message, field);
}

void SetNotifyStatusRequest_Code_RawValue(NotifyStatusRequest *message, int32_t value) {
  GPBDescriptor *descriptor = [NotifyStatusRequest descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:NotifyStatusRequest_FieldNumber_Code];
  GPBSetMessageRawEnumField(message, field, value);
}

#pragma mark - Enum NotifyStatusRequest_StatusCode

GPBEnumDescriptor *NotifyStatusRequest_StatusCode_EnumDescriptor(void) {
  static _Atomic(GPBEnumDescriptor*) descriptor = nil;
  if (!descriptor) {
    static const char *valueNames =
        "UnknownStatusCode\000Ok\000Connecting\000Connecte"
        "d\000Disconnected\000Fault\000";
    static const int32_t values[] = {
        NotifyStatusRequest_StatusCode_UnknownStatusCode,
        NotifyStatusRequest_StatusCode_Ok,
        NotifyStatusRequest_StatusCode_Connecting,
        NotifyStatusRequest_StatusCode_Connected,
        NotifyStatusRequest_StatusCode_Disconnected,
        NotifyStatusRequest_StatusCode_Fault,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(NotifyStatusRequest_StatusCode)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:NotifyStatusRequest_StatusCode_IsValidValue];
    GPBEnumDescriptor *expected = nil;
  }
  return descriptor;
}

BOOL NotifyStatusRequest_StatusCode_IsValidValue(int32_t value__) {
  switch (value__) {
    case NotifyStatusRequest_StatusCode_UnknownStatusCode:
    case NotifyStatusRequest_StatusCode_Ok:
    case NotifyStatusRequest_StatusCode_Connecting:
    case NotifyStatusRequest_StatusCode_Connected:
    case NotifyStatusRequest_StatusCode_Disconnected:
    case NotifyStatusRequest_StatusCode_Fault:
      return YES;
    default:
      return NO;
  }
}

#pragma mark - PostMeasureRequest

@implementation PostMeasureRequest

@dynamic recordArray, recordArray_Count;

typedef struct PostMeasureRequest__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *recordArray;
} PostMeasureRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "recordArray",
        .dataTypeSpecific.clazz = GPBObjCClass(MeasureRecord),
        .number = PostMeasureRequest_FieldNumber_RecordArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(PostMeasureRequest__storage_, recordArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[PostMeasureRequest class]
                                     rootClass:[DeviceRoot class]
                                          file:DeviceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(PostMeasureRequest__storage_)
                                         flags:(GPBDescriptorInitializationFlags)(GPBDescriptorInitializationFlag_UsesClassRefs | GPBDescriptorInitializationFlag_Proto3OptionalKnown)];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - RepostMeasureRequest

@implementation RepostMeasureRequest

@dynamic recordArray, recordArray_Count;

typedef struct RepostMeasureRequest__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *recordArray;
} RepostMeasureRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "recordArray",
        .dataTypeSpecific.clazz = GPBObjCClass(MeasureRecord),
        .number = RepostMeasureRequest_FieldNumber_RecordArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(RepostMeasureRequest__storage_, recordArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[RepostMeasureRequest class]
                                     rootClass:[DeviceRoot class]
                                          file:DeviceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(RepostMeasureRequest__storage_)
                                         flags:(GPBDescriptorInitializationFlags)(GPBDescriptorInitializationFlag_UsesClassRefs | GPBDescriptorInitializationFlag_Proto3OptionalKnown)];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - MeasureRecord

@implementation MeasureRecord

@dynamic hasDeviceProperty, deviceProperty;
@dynamic hasMeasuredAt, measuredAt;
@dynamic sensorArray, sensorArray_Count;

typedef struct MeasureRecord__storage_ {
  uint32_t _has_storage_[1];
  DeviceProperty *deviceProperty;
  GPBTimestamp *measuredAt;
  NSMutableArray *sensorArray;
} MeasureRecord__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "deviceProperty",
        .dataTypeSpecific.clazz = GPBObjCClass(DeviceProperty),
        .number = MeasureRecord_FieldNumber_DeviceProperty,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(MeasureRecord__storage_, deviceProperty),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "measuredAt",
        .dataTypeSpecific.clazz = GPBObjCClass(GPBTimestamp),
        .number = MeasureRecord_FieldNumber_MeasuredAt,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(MeasureRecord__storage_, measuredAt),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "sensorArray",
        .dataTypeSpecific.clazz = GPBObjCClass(Sensor),
        .number = MeasureRecord_FieldNumber_SensorArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(MeasureRecord__storage_, sensorArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MeasureRecord class]
                                     rootClass:[DeviceRoot class]
                                          file:DeviceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MeasureRecord__storage_)
                                         flags:(GPBDescriptorInitializationFlags)(GPBDescriptorInitializationFlag_UsesClassRefs | GPBDescriptorInitializationFlag_Proto3OptionalKnown)];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)

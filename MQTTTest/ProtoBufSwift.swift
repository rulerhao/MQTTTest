//
//  ProtoBufSwift.swift
//  MQTTTest
//
//  Created by louie on 2020/11/13.
//

import UIKit
import Foundation


@objc public class ProtoBufSwift: NSObject
{
    @objc public func protoBufSwift() -> String
    {
        let apb = SayBigVoice()
        apb.Say()
        print("nice")
        return "TestStr"
    }
    @objc public func proto2()
    {
        print("sobad")
    }
}

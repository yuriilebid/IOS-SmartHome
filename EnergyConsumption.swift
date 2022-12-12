//
//  EnergyConsumption.swift
//  SmartHome
//
//  Created by Yurii Lebid on 01.12.2022.
//

import Foundation

class EnergyConsumption {
    var wattHour:Float = 0.0
    var voltage:Float = 0.0
    
    func getTime() -> Float { return 0.0 }

    init(jsonStrParse:String) {
        if let jsonArr = jsonStrParse.data(using: String.Encoding.utf8) {
            if let json = try! JSONSerialization.jsonObject(with: jsonArr, options: .allowFragments) as? [String:Any] {
                self.wattHour = json["energy"] as? Float ?? 0.0
                self.voltage = json["connection"] as? Float ?? 0.0
            }
        }
    }

    class BatteryDevice : EnergyConsumption {
        var cappacity:Float = 0.0
        
        override func getTime() -> Float {
            return cappacity / wattHour;
        }
    }

    class PlugDevice : EnergyConsumption {
        var cappacity:Float = 0.0
        
        override func getTime() -> Float {
            return 999999;
        }
    }
}

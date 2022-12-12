//
//  Device.swift
//  SmartHome
//
//  Created by Yurii Lebid on 01.12.2022.
//

import Foundation

class Device {
    var energy = EnergyConsumption(jsonStrParse:"N/A")
    var connection = Connection(jsonStr:"N/A")
    var devName = String()
    
    init(devName:String, parseConnectionStr:String, parseEnergyStr:String) {
        self.devName = devName
        
        if let jsonArr = parseConnectionStr.data(using: String.Encoding.utf8) {
            if let json = try! JSONSerialization.jsonObject(with: jsonArr, options: .allowFragments) as? [String:Any] {
                energy = EnergyConsumption(jsonStrParse: json["energy"] as? String ?? "N/A")
                connection = Connection(jsonStr: json["connection"] as? String ?? "N/A")
            }
        }
    }
}

//
//  Room.swift
//  SmartHome
//
//  Created by Yurii Lebid on 02.12.2022.
//

import Foundation

class Room {
    var roomName = String()
    var roomId = 0
    var devicesCount = 0
    var devices = [Device]()
    
    init(name:String, parseStr:String) {
        self.roomName = name
        
        if let jsonArr = parseStr.data(using: String.Encoding.utf8) {
            if let json = try! JSONSerialization.jsonObject(with: jsonArr, options: .allowFragments) as? [String:Any] {
                self.roomName = json["roomName"] as? String ?? "N/A"
                let devicesStr = json["devices"] as? String ?? "N/A"

                if let jsonDev = devicesStr.data(using: String.Encoding.utf8) {
                    if let jsonDevObj = try! JSONSerialization.jsonObject(with: jsonDev, options: .allowFragments) as? [Any] {
                        for devItem in jsonDevObj {
                            if let object = devItem as? [String: Any] {
                                let newDevice = Device(devName: object["name"] as? String ?? "N/A", parseConnectionStr: object["connection"] as? String ?? "N/A", parseEnergyStr: object["energy"] as? String ?? "N/A")
                                self.devices.append(newDevice)
                            }
                        }
                    }
                }
            }
        }
    }
    
    init(roomIdentifier:Int, name: String, devCount:Int) {
        self.roomId = roomIdentifier
        self.roomName = name
        self.devicesCount = devCount
    }
}

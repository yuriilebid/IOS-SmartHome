//
//  House.swift
//  SmartHome
//
//  Created by Yurii Lebid on 01.12.2022.
//

import Foundation

class House {
    var initialized = true
    var data: DataBase
    var houseId = Int()
    var name = String()
    var rooms = [Room]()
    
    func parseJson(parseStr:String) {
        if let jsonGlo = parseStr.data(using: String.Encoding.utf8) {
            if let json = try! JSONSerialization.jsonObject(with: jsonGlo, options: .allowFragments) as? [String:Any] {
                self.name = json["house"] as? String ?? "N/A"
                let rooms = json["rooms"] as? String ?? "N/A"
                
                if let jsonRom = rooms.data(using: String.Encoding.utf8) {
                    if let json = try! JSONSerialization.jsonObject(with: jsonRom, options: .allowFragments) as? [Any] {
                        for item in json {
                            if let object = item as? [String: Any] {
                                let newRoom = Room(name: object["rooms"] as? String ?? "N/A", parseStr: object["devices"] as? String ?? "N/A")
                                self.rooms.append(newRoom)
                            }
                        }
                    }
                }
            }
        }
    }
    
    init() {
        data = DataBase()
        let resHouse = data.readHouse()
        
        if resHouse.0 == -1 {
            initialized = false
            print("House is not initialized")
        }
        self.houseId = resHouse.0
        self.name = resHouse.1
        self.rooms.reserveCapacity(resHouse.2)
        
        data.testingData(houseIdTest: self.houseId)
        let Rooms = data.readRooms(houseId: self.houseId)
        
        for room in Rooms {
            rooms.append(Room(roomIdentifier: room.0, name: room.1, devCount: room.2))
        }
    }
}


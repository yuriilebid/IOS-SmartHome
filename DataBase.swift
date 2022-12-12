//
//  DataBase.swift
//  SmartHome
//
//  Created by Yurii Lebid on 02.12.2022.
//

import Foundation
import SQLite3

class DataBase {
    var db: OpaquePointer?
    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("HouseStructure.sqlite")
    
    init() {
        openDbConnection()
        createTable()
        initAvailableDevices()
    }
    
    func openDbConnection() {
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
    }
    
    func initAvailableDevices() {
        var stmt: OpaquePointer?
        var count = Int(0)
        var query = "select count(*) from availableDevices"
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK{
              while(sqlite3_step(stmt) == SQLITE_ROW){
                   count = Int(sqlite3_column_int(stmt, 0))
                   print("\(count)")
              }
        }
        if count == 0 {
            query = "INSERT INTO availableDevices (deviceid, name, bluetoothIdentifier) VALUES (1, 'Camera', 'esp32camera')"
            //preparing the query
            if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return
            }
            //executing the query to insert values
            if sqlite3_step(stmt) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting available device: \(errmsg)")
                return
            }
            query = "INSERT INTO availableDevices (deviceid, name, bluetoothIdentifier) VALUES (2, 'Lamp', 'esp32lamp')"
            //preparing the query
            if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return
            }
            //executing the query to insert values
            if sqlite3_step(stmt) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting available device: \(errmsg)")
                return
            }
        }
    }
    
    func getAvailableDevices() -> [(Int, String, String)] {
        var devsRes = [(Int, String, String)] ()
        let queryString = "SELECT * FROM availableDevices"
        //statement pointer
        var stmt:OpaquePointer?
     
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return [(0, "", "")]
        }
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let resId = Int(sqlite3_column_int(stmt, 0))
            let resName = String(cString: sqlite3_column_text(stmt, 1))
            let resIdentifier = String(cString: sqlite3_column_text(stmt, 2))
            devsRes.append((resId, resName, resIdentifier))
        }
        return devsRes
    }
    
    func createTable() {
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Houses (houseId INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, rooms INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table Houses: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Rooms (Roomid INTEGER PRIMARY KEY AUTOINCREMENT, Houseid INTEGER, name TEXT, devices INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table Rooms: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Devices (deviceid INTEGER PRIMARY KEY AUTOINCREMENT, roomid INTEGER, name TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table Devices: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS availableDevices (deviceid INTEGER PRIMARY KEY, name TEXT, bluetoothIdentifier TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table Devices: \(errmsg)")
        }
    }
    
    func testingData(houseIdTest:Int) {
        //creating a statement
        var stmt: OpaquePointer?
        //the insert query
        var queryString = "DELETE FROM Houses"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting house: \(errmsg)")
            return
        }
        queryString = "DELETE FROM Rooms"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting house: \(errmsg)")
            return
        }
        queryString = "INSERT INTO Houses (name, rooms) VALUES ('MyHome', 2)"
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting house: \(errmsg)")
            return
        }
        
        queryString = "INSERT INTO Rooms (Houseid, name, devices) VALUES ((?), 'Room1', 2)"
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_int(stmt, 1, Int32(houseIdTest)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting house: \(errmsg)")
            return
        }
        queryString = "INSERT INTO Rooms (Houseid, name, devices) VALUES ((?), 'Room2', 3)"
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_int(stmt, 1, Int32(houseIdTest)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting house: \(errmsg)")
            return
        }
         
        //displaying a success message
        print("House saved successfully")
    }

    func insertHouseInfo(houseName: String) {
        //validating that values are not empty
        if houseName.isEmpty {
            return
        }
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = "INSERT INTO Houses (name) VALUES (?)"
         
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
         
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, houseName, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
         
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting house: \(errmsg)")
            return
        }
         
        //displaying a success message
        print("House saved successfully")
    }
    
    func readRooms(houseId: Int) -> [(Int, String, Int)] {
        var roomsRes = [(Int, String, Int)] ()
        let queryString = "SELECT * FROM Rooms WHERE Houseid=(?)"
        //statement pointer
        var stmt:OpaquePointer?
     
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return [(0, "", 0)]
        }
        
        if sqlite3_bind_int(stmt, 1, Int32(houseId)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return [(0, "", 0)]
        }
     
            //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let resId = Int(sqlite3_column_int(stmt, 1))
            let resName = String(cString: sqlite3_column_text(stmt, 2))
            let resDevicesAmount = Int(sqlite3_column_int(stmt, 3))
            roomsRes.append((resId, resName, resDevicesAmount))
        }
        if roomsRes == nil {
            return [(0, "", 0)]
        } else {
            return roomsRes
        }
    }
    
    func readHouse() -> (Int, String, Int) {
        var houseId:Int = -1
        var houseNameRes:String = ""
        var rooms:Int = 0
        let queryString = "SELECT * FROM Houses"
     
            //statement pointer
        var stmt:OpaquePointer?
     
            //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return (houseId, houseNameRes, rooms)
        }
     
            //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            houseId = Int(sqlite3_column_int(stmt, 0))
            houseNameRes = String(cString: sqlite3_column_text(stmt, 1))
            rooms = Int(sqlite3_column_int(stmt, 2))
        }
        return (houseId, houseNameRes, rooms)
    }
}

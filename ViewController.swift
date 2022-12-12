//
//  ViewController.swift
//  SmartHome
//
//  Created by Yurii Lebid on 01.12.2022.
//

import UIKit
import CoreBluetooth

let myHome = House()

class ManuallSetupController: UIViewController {
    @IBOutlet weak var saveNameButton: UIButton!
    @IBOutlet weak var houseNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Adding home"
        view.backgroundColor = .systemCyan
        
        saveNameButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
    }
    
    @objc private func didTapSaveButton() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! ViewController
        
        myHome.data.insertHouseInfo(houseName: houseNameField.text!)
//        self.present(nextViewController, animated:true, completion:nil)
        DispatchQueue.main.async { [weak self] in
            self?.present(nextViewController, animated: true, completion: nil)
        }
        nextViewController.modalPresentationStyle = .fullScreen
    }
}

class SettingViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var manuallButton: UIButton!
    @IBOutlet weak var qrButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Adding home"
        view.backgroundColor = .systemBlue
        
        manuallButton.addTarget(self, action: #selector(didTapManuallButton), for: .touchUpInside)
    }
    
    @objc private func didTapManuallButton() {
//        let rootVC = ManuallSetupController()
//        let navVC = UINavigationController(rootViewController: rootVC)
//        present(navVC, animated: true, completion: nil)
//        navVC.modalPresentationStyle = .fullScreen
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "manuallSettingView") as! ManuallSetupController
//        self.present(nextViewController, animated:true, completion:nil)
        DispatchQueue.main.async { [weak self] in
            self?.present(nextViewController, animated: true, completion: nil)
        }
        nextViewController.modalPresentationStyle = .fullScreen
    }
}

class AddDeviceController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let devAvailable = myHome.data.getAvailableDevices()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devAvailable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDev = tableView.dequeueReusableCell(withIdentifier: "availableDevice")
        cellDev?.textLabel?.text = devAvailable[indexPath.row].1
        return cellDev!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(devAvailable.count)
    }
}

//class BluetoothViewModel: NSObject, ObservableObject {
//    private var centralManager: CBCentralManager
//    private var peripherals: [CBPeripheral] = []
//    @Published var peripheralNames: [String] = []
//
//    override init() {
//        super.init()
//        self.centralManager = CBCentralManager(delegate: self, queue: .main)
//    }
//}

//extension BluetoothViewModel: CBCentralManagerDelegate {
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if central.state == .poweredOn {
//            self.centralManager.scanForPeripherals(withServices: nil)
//        }
//    }
//    
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        if !peripherals.contains(peripheral) {
//            self.peripherals.append(peripheral)
//            self.peripheralNames.append(peripheral.name ?? "unknown")
//        }
//    }
//}

class BluetoothSearch: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var addDeviceButton: UIButton!
    @IBOutlet var textLabelDevName: UILabel!
//    @IBOutlet var whiteView: UIImageView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellRoom = tableView.dequeueReusableCell(withIdentifier: "RoomCell")
        cellRoom?.textLabel?.text = myHome.rooms[indexPath.row].roomName
        return cellRoom!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myHome.rooms.count
    }
    
    override func viewDidLoad() {
        addDeviceButton.layer.cornerRadius = 35
        addDeviceButton.clipsToBounds = true
        super.viewDidLoad()
        
        if myHome.initialized {
            textLabelDevName.text = myHome.name
        
        } else {
            presentSettingView()
        }
        
        addDeviceButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }

    @objc private func didTapAddButton() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "addingDeviceView") as! AddDeviceController
        DispatchQueue.main.async { [weak self] in
            self?.present(nextViewController, animated: true, completion: nil)
        }
//        nextViewController.modalPresentationStyle = .fullScreen
//        let rootVC = AddDeviceController()
//        let navVC = UINavigationController(rootViewController: rootVC)
//        present(navVC, animated: true, completion: nil)
//        navVC.modalPresentationStyle = .fullScreen
    }
    
    func presentSettingView() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "settingView") as! SettingViewController
//        self.present(nextViewController, animated:true, completion:nil)
        DispatchQueue.main.async { [weak self] in
            self?.present(nextViewController, animated: true, completion: nil)
        }
        nextViewController.modalPresentationStyle = .fullScreen
    }
}

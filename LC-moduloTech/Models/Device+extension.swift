//
//  Device+extension.swift
//  LC-moduloTech
//
//  Created by Luc Casimir on 13/02/2021.
//

import Foundation
import CoreData
import Combine

extension Device {
    
    enum ProductType : String {
        
        case Light, RollerShutter, Heater, Unknow
        
        static func withID(TypeID:Int16) -> ProductType {
            switch TypeID {
            case 1: return ProductType.Light
            case 2: return ProductType.RollerShutter
            case 3: return ProductType.Heater
            default: return .Unknow
            }
        }
    }
    
    var type : ProductType {
        return ProductType.withID(TypeID: self.type_)
    }
    
    var name : String {
        return "\(self.name_ ?? "Device Type \(self.type.rawValue)")"
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Device> {
        let request = NSFetchRequest<Device>(entityName: "Device")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Device.id_, ascending: true)]
        request.predicate = predicate
        return request
    }
    
    static func updateSelectionForType(Light:Bool, RollerShutter:Bool, Heater:Bool, onContext:NSManagedObjectContext) {
        
        do {
            let devices = try onContext.fetch(Device.fetchRequest(.all))
            devices.forEach({ device in
                switch device.type {
                case .Heater: device.isSelected_ = Heater
                case .Light: device.isSelected_ = Light
                case .RollerShutter: device.isSelected_ = RollerShutter
                default: print("Unknow device detected!")
                }
            })
            
            print(devices)
        }
        catch let error {
            print("Fetching request failed \(error.localizedDescription)")
        }
    }
    
    static func fetchDeviceList(Context:NSManagedObjectContext) {
        let webService = StorageWS.shared
        
        webService.fetchDeviceList { (result) in
            
            switch result {
            case .success(let reponse):
                
                let devices = reponse.devices.map({ deviceJSON -> Device in
                    let device = Device(context: Context)
                    device.id_ = Int16(deviceJSON.id)
                    device.name_ = deviceJSON.deviceName
                    device.type_ = deviceJSON.productType.id
                    device.isSelected_ = true
                    device.objectWillChange.send()
                    return device
                })
                
                let user = User(context: Context)
                user.lastName_ = reponse.user.lastName
                user.firstName_ = reponse.user.firstName
                user.birthDate_ = Date(timeIntervalSinceNow: TimeInterval(reponse.user.birthDate))
                user.city_ = reponse.user.address.city
                user.country_ = reponse.user.address.country
                user.postalCode_ = Int32(reponse.user.address.postalCode)
                user.street_ = reponse.user.address.street
                user.streetCode_ = reponse.user.address.streetCode
                user.ligthSelection_ = true
                user.heaterSelection_ = true
                user.rollerShutterSelection_ = true
                user.objectWillChange.send()
                
                print("Fetching item : \(devices)")
                
                do {
                    try Context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
                
            case .failure(let error):
                print("Error when fetching \(error.localizedDescription)")
            }
        }
    }
}

extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
    static var isSelected = NSPredicate(format:"isSelected_ == TRUE")
}

extension StorageWS.Device.ProductType {
    
    var id : Int16 {
        switch self {
        case .light: return 1
        case .rollerShutter: return 2
        case .heater: return 3
        }
    }
}

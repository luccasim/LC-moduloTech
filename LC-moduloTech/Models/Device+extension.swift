//
//  Device+extension.swift
//  LC-moduloTech
//
//  Created by Luc Casimir on 13/02/2021.
//

import Foundation
import CoreData

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
        return "Device - \(self.id_) \(self.type.rawValue)"
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
    
}

extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
    static var isSelected = NSPredicate(format:"isSelected_ == TRUE")
}

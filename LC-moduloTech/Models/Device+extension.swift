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
    
    static func createProductDevice(fromJSON json:StorageWS.Device, onContext:NSManagedObjectContext) {
        switch json.productType.id {
        
        case 1:
            //light
            let light = Light(context:onContext)
            light.id_ = Int16(json.id)
            light.type_ = 1
            light.isSelected_ = true
            light.name_ = json.deviceName
            light.intensity_ = Int16(json.intensity ?? 0)
            light.mode_ = false
            light.objectWillChange.send()
            
        case 2:
            //rollershutter
            let rollerShutter = RollerShutter(context: onContext)
            rollerShutter.id_ = Int16(json.id)
            rollerShutter.type_ = 2
            rollerShutter.isSelected_ = true
            rollerShutter.name_ = json.deviceName
            rollerShutter.position_ = Int16(json.position ?? 0)
            rollerShutter.objectWillChange.send()
            
        case 3:
            //heater
            let heater = Heater(context: onContext)
            heater.id_ = Int16(json.id)
            heater.type_ = 3
            heater.isSelected_ = true
            heater.name_ = json.deviceName
            heater.temperature_ = Double(json.temperature ?? 0)
            heater.mode_ = false
            heater.objectWillChange.send()
            
        default: break
        }
    }
    
    static func deleteAllDevices(onContext:NSManagedObjectContext) {
        
        do {
            
            let allDevices = try onContext.fetch(Device.fetchRequest(.all))
            allDevices.forEach({onContext.delete($0)})
            try onContext.save()
            print("Delete all devices successfully!")
            
        } catch let error {
            print("Error on Context \(error.localizedDescription)")
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


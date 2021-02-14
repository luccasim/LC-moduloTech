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
    
}

extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
    static var isSelected = NSPredicate(format:"isSelected_ == TRUE")
}



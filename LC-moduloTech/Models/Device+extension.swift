//
//  Device+extension.swift
//  LC-moduloTech
//
//  Created by Luc Casimir on 13/02/2021.
//

import Foundation

extension Device {
    
    enum `Type` : String {
        
        case Light, RollerShutter, Heater, Unknow
        
        static func withID(TypeID:Int16) -> Type {
            switch TypeID {
            case 1: return Type.Light
            case 2: return Type.RollerShutter
            case 3: return Type.Heater
            default: return .Unknow
            }
        }
    }
    
    var type : Type {
        return Type.withID(TypeID: self.type_)
    }
    
    var name : String {
        return "Device - \(self.id_) \(self.type.rawValue)"
    }
    
}

//
//  Heater+Extension.swift
//  LC-moduloTech
//
//  Created by Luc Casimir on 14/02/2021.
//

import Foundation
import CoreData

extension Heater {
    
    var temperature : Double {
        return self.temperature_
    }
    
    var mode : Bool {
        return self.mode_
    }
    
    func update(NewTemperature:Double,NewMode:Bool) {
        self.temperature_ = NewTemperature
        self.mode_ = NewMode
        print("Heater updated :\(self)")
    }
}

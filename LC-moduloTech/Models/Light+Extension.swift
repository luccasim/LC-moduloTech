//
//  Light+Extension.swift
//  LC-moduloTech
//
//  Created by Luc Casimir on 14/02/2021.
//

import Foundation
import CoreData

extension Light {
    
    var intensity : Double {
        return Double(self.intensity_)
    }
    
    var mode : Bool {
        return self.mode_
    }
    
    func udpate(NewIntensity:Double, NewMode:Bool) {
        self.intensity_ = Int16(NewIntensity)
        self.mode_ = NewMode
        print("Device Updated \(self)")
    }
    
}

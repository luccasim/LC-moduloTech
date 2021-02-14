//
//  RollerShutter+Extension.swift
//  LC-moduloTech
//
//  Created by Luc Casimir on 14/02/2021.
//

import Foundation
import CoreData

extension RollerShutter {
    
    var position : Double {
        return Double(self.position_)
    }
    
    func update(newPosition:Double) {
        self.position_ = Int16(newPosition)
    }
    
}

//
//  User+Extension.swift
//  LC-moduloTech
//
//  Created by Luc Casimir on 14/02/2021.
//

import Foundation
import CoreData

extension User {
    
    struct UserSelectionPreference {
        var showLight : Bool = true
        var showRollerShutter : Bool = true
        var showHeater : Bool = true
    }
    
    var fullName : String {
        return "\(self.firstName_ ?? "") \(self.lastName_ ?? "")"
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<User> {
        let request = NSFetchRequest<User>(entityName: "User")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \User.firstName_, ascending: true)]
        request.predicate = predicate
        return request
    }
    
    func update() {
        
    }
    
    var preferences : UserSelectionPreference {
        return UserSelectionPreference(showLight: self.ligthSelection_, showRollerShutter: self.rollerShutterSelection_, showHeater: self.heaterSelection_)
    }
    
    static func mainUser(Context:NSManagedObjectContext) -> User {
        
        guard let first = try? Context.fetch(User.fetchRequest(.all)).first else {
            let newUser = User(context: Context)
            newUser.firstName_ = "Luc"
            newUser.lastName_ = "CASIMIR"
            return newUser
        }
        
        return first
    }
    
}

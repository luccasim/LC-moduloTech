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
    
    private func fetchDeviceList(Context:NSManagedObjectContext) {
        
        let webService = StorageWS.shared
        
        print("Fetching Devices List")
        
        webService.fetchDeviceList { (result) in
            
            DispatchQueue.main.async {
                
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
                    
                    let user = self
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
    
    static func mainUser(Context:NSManagedObjectContext) -> User {
        
        guard let first = try? Context.fetch(User.fetchRequest(.all)).first else {
            let newUser = User(context: Context)
            newUser.fetchDeviceList(Context: Context)
            return newUser
        }
        
        return first
    }
    
}

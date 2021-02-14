//
//  User+Extension.swift
//  LC-moduloTech
//
//  Created by Luc Casimir on 14/02/2021.
//

import Foundation
import CoreData

extension User {
    
    var fullName : String {
        return "\(self.firstName_ ?? "") \(self.lastName_ ?? "")"
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<User> {
        let request = NSFetchRequest<User>(entityName: "User")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \User.firstName_, ascending: true)]
        request.predicate = predicate
        return request
    }
        
    func fetchDeviceList(Context:NSManagedObjectContext) {
        
        let webService = StorageWS.shared
                
        webService.fetchDeviceList { (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                
                case .success(let reponse):
                    
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
                    
                    reponse.devices.forEach({ deviceJSON in
                        Device.createProductDevice(fromJSON: deviceJSON, onContext: Context)
                    })
                    
                    do {
                        try Context.save()
                    } catch let error {
                        print("Failing CoreData saving context \(error.localizedDescription)")
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
    
    //MARK: - Update
    
    func update(WithUserInformation userInfos:UserUpdateInformations) {
        self.firstName_ = userInfos.firstName
        self.lastName_ = userInfos.lastName
        self.country_ = userInfos.country
        self.city_ = userInfos.city
        self.street_ = userInfos.street
        self.streetCode_ = userInfos.streetCode
        self.objectWillChange.send()
    }
    
    func update(Light:Bool, RollerShutter:Bool, Heater:Bool) {
        
        do {
            
            let devices = try self.managedObjectContext?.fetch(Device.fetchRequest(.all))
            
            devices?.forEach({ device in
                switch device.type {
                case .Heater: device.isSelected_ = Heater
                case .Light: device.isSelected_ = Light
                case .RollerShutter: device.isSelected_ = RollerShutter
                default: print("Unknow device detected!")
                }
            })
            
            self.heaterSelection_ = Heater
            self.ligthSelection_ = Light
            self.rollerShutterSelection_ = RollerShutter
            
        }
        catch let error {
            print("Fetching request failed \(error.localizedDescription)")
        }
    }
    
}

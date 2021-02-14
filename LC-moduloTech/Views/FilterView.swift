//
//  FilterView.swift
//  LC-moduloTech
//
//  Created by Luc Casimir on 13/02/2021.
//

import SwiftUI

struct UserSelectionPreference {
    var showLight, showRollerShutter, showHeater : Bool
}

struct FilterView: View {
    
    @FetchRequest(fetchRequest: Device.fetchRequest(.all)) var alldevices: FetchedResults<Device>
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var preferences : UserSelectionPreference
    
    private var user : User
        
    init(MainUser:User) {
        _preferences = State(initialValue: UserSelectionPreference(
                                showLight: MainUser.ligthSelection_,
                                showRollerShutter: MainUser.rollerShutterSelection_,
                                showHeater: MainUser.heaterSelection_))
        self.user = MainUser
    }
    
    var body: some View {
        
        Form {
            
            Toggle(isOn: self.$preferences.showLight, label: {
                Text("\(Device.ProductType.Light.rawValue)")
            })
            Toggle(isOn: self.$preferences.showRollerShutter, label: {
                Text("\(Device.ProductType.RollerShutter.rawValue)")
            })
            Toggle(isOn: self.$preferences.showHeater, label: {
                Text("\(Device.ProductType.Heater.rawValue)")
            })
            
        }
        .navigationTitle("User Preferences")
        .onAppear(perform: {PersistenceController.shared.save()})
        .onDisappear(perform: {updateSelectedDevicesTypes()})
    }
    
    /// Should update when the user leave this view
    func updateSelectedDevicesTypes() {
        self.user.update(Light: self.preferences.showLight, RollerShutter: self.preferences.showRollerShutter, Heater: self.preferences.showHeater)
    }
}

//
//  FilterView.swift
//  LC-moduloTech
//
//  Created by Luc Casimir on 13/02/2021.
//

import SwiftUI

struct FilterView: View {
    
    @FetchRequest(fetchRequest: Device.fetchRequest(.all)) var alldevices: FetchedResults<Device>
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var preferences : User.UserSelectionPreference
    @ObservedObject var user : User
    
    @State var showLight = false
    
    init(MainUser:User, Preference:Binding<User.UserSelectionPreference>) {
        _preferences = State(wrappedValue: Preference.wrappedValue)
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
        .onDisappear(perform: {updateSelectedDevicesTypes()})
    }
    
    func updateSelectedDevicesTypes() {
        Device.updateSelectionForType(
            ForUser: self.user, Light: self.showLight,
            RollerShutter: self.preferences.showRollerShutter,
            Heater: self.preferences.showHeater,
            onContext: self.viewContext)
    }
}

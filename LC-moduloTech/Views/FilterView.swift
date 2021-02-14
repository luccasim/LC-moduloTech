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
    
    @State var preferences : UserSearchPreference
    
    init(Preference:Binding<UserSearchPreference>) {
        _preferences = State(wrappedValue: Preference.wrappedValue)
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
            Light: self.preferences.showLight,
            RollerShutter: self.preferences.showRollerShutter,
            Heater: self.preferences.showHeater,
            onContext: self.viewContext)
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(Preference: .constant(UserSearchPreference()))
    }
}

//
//  UserView.swift
//  LC-moduloTech
//
//  Created by Luc Casimir on 14/02/2021.
//

import SwiftUI

struct UserUpdateInformations {
    var firstName, lastName, country, street, streetCode, city  : String
}

struct UserView: View {
    
    private var user : User
    
    @Environment(\.managedObjectContext) private var viewContext
    @State var informations : UserUpdateInformations
    @State var edit = false
    @State var shouldResetData = false
    
    init(MainUser:User) {
        self.user = MainUser
        _informations = State(initialValue: UserUpdateInformations(
            firstName: MainUser.firstName_ ?? "",
            lastName: MainUser.lastName_ ?? "",
            country: MainUser.country_ ?? "",
            street: MainUser.street_ ?? "",
            streetCode: MainUser.streetCode_ ?? "",
            city: MainUser.city_ ?? ""
        ))
    }
    
    var body: some View {
        
        Form {
            
            dansLeBoule(label: "FirstName", Binding: $informations.firstName)
            dansLeBoule(label: "LastName", Binding:$informations.lastName)
            dansLeBoule(label: "Country", Binding: $informations.country)
            dansLeBoule(label: "City", Binding: $informations.city)
            dansLeBoule(label: "Street", Binding: $informations.street)
            dansLeBoule(label: "Street Code", Binding:$informations.streetCode)
            
            Button(self.buttonMessage) {
                self.shouldResetData.toggle()
            }

        }
        .onDisappear(perform: {
            self.reloadData()
        })
        .navigationTitle("User informations")
    }
    
    var buttonMessage : String {
        return self.shouldResetData ? "Conserve Data" : "Reset and Reload The User Data"
    }
    
    @ViewBuilder
    func dansLeBoule(label:String, Binding:Binding<String>) -> some View {
        if self.edit {
            HStack {
                Text(label)
                TextField("", text: Binding)
            }
        } else {
            HStack {
                Text(label)
                Spacer()
                Text(Binding.wrappedValue)
            }
        }
    }
    
    func reloadData() {
        if self.shouldResetData {
            self.user.fetchDeviceList(Context: self.viewContext)
        }
    }
}

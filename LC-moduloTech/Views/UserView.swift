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
            
            dansLeBoule(label: "FirstName", Value:user.firstName_, Binding: $informations.firstName)
            dansLeBoule(label: "LastName", Value:user.lastName_, Binding:$informations.lastName)
            dansLeBoule(label: "Country", Value:user.country_, Binding: $informations.country)
            dansLeBoule(label: "City", Value:user.city_, Binding: $informations.city)
            dansLeBoule(label: "Street", Value:user.street_, Binding: $informations.street)
            dansLeBoule(label: "Street Code", Value:user.streetCode_, Binding:$informations.streetCode)

            Button("Fetch User Info") {
                self.fetchUserInfo()
            }
        }
        .onDisappear(perform: {
            self.updateValue()
        })
        .navigationTitle("User informations")
    }
    
    @ViewBuilder
    func dansLeBoule(label:String, Value:String?, Binding:Binding<String>) -> some View {
        if self.edit {
            HStack {
                Text(label)
                TextField("", text: Binding)
            }
        } else {
            HStack {
                Text(label)
                Spacer()
                Text(Value ?? "")
            }
        }
    }
    
    func updateValue() {
        self.user.update(WithUserInformation: self.informations)
    }
    
    func fetchUserInfo() {
        self.user.fetchDeviceList(Context: self.viewContext)
    }
}

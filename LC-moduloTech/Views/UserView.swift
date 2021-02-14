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
    
    @State var informations : UserUpdateInformations
    
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
            TextField("FirstName", text: $informations.firstName)
            TextField("LastName", text: $informations.lastName)
            TextField("Country", text: $informations.country)
            TextField("City", text: $informations.city)
            TextField("Street", text: $informations.street)
            TextField("Street Code", text: $informations.streetCode)
        }
        .onDisappear(perform: {
            self.updateValue()
        })
    }
    
    func updateValue() {
        self.user.update(WithUserInformation: self.informations)
    }
}

//struct UserView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserView()
//    }
//}

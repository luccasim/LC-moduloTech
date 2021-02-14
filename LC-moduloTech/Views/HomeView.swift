//
//  HomeView.swift
//  LC-moduloTech
//
//  Created by Luc Casimir on 13/02/2021.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var devices: FetchedResults<Device>
    
    @State var preferences : User.UserSelectionPreference
    
    @ObservedObject var user : User
    
    init(MainUser:User) {
        let request = Device.fetchRequest(.isSelected)
        _devices = FetchRequest(fetchRequest: request)
        _preferences = State(initialValue: MainUser.preferences)
        self.user = MainUser
    }
        
    var body: some View {
    
        NavigationView {
            
            List {
                
                ForEach(self.devices, id: \.self) { device in
                    NavigationLink(destination: DetailView(Device: device)) {
                        Text("\(device.name)")
                     }
                }
                .onDelete(perform: self.deleteItem(at:))
            }
            .navigationTitle("Devices")
            .toolbar {
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FilterView(Preference: self.$preferences).environment(\.managedObjectContext, self.viewContext)) {
                         Text("Filter")
                     }
                }
                
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    NavigationLink(destination: ProfilView()) {
                         Text("Profil")
                     }
                }
            }
        }
    }
    
    private func deleteItem(at offsets: IndexSet) {
        offsets.map { devices[$0] }.forEach(viewContext.delete)
    }
    
}

struct ProfilView: View {
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(.green)
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            HomeView()
//                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//        }
//    }
//}

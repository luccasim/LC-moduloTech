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
    
    @ObservedObject var user : User
    
    init(MainUser:User) {
        _devices = FetchRequest(fetchRequest: Device.fetchRequest(.isSelected))
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
            .navigationTitle("Devices List")
            .toolbar {
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FilterView(MainUser: self.user).environment(\.managedObjectContext, self.viewContext)) {
                         Text("Filter")
                     }
                }
                
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    NavigationLink(destination: UserView(MainUser: self.user).environment(\.managedObjectContext, self.viewContext)) {
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

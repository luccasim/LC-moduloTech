//
//  HomeView.swift
//  LC-moduloTech
//
//  Created by Luc Casimir on 13/02/2021.
//

import SwiftUI
import CoreData

struct UserSearchPreference {
    var showLight : Bool = false
    var showRollerShutter : Bool = false
    var showHeater : Bool = false
}

struct HomeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var devices: FetchedResults<Device>
    
    @State var preferences : UserSearchPreference = UserSearchPreference()
    
    init() {
        let request = Device.fetchRequest(.isSelected)
        _devices = FetchRequest(fetchRequest: request)
        print("View created with \(request)")
    }
        
    var body: some View {
    
        NavigationView {
            
            List {
                
                ForEach(self.devices, id: \.self) { Device in
                    NavigationLink(destination: DetailView()) {
                        Text("\(Device.name)")
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
//        self.list.remove(atOffsets: offsets)
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


struct DetailView: View {
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(.red)
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}

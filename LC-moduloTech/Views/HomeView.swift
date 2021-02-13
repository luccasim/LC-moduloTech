//
//  HomeView.swift
//  LC-moduloTech
//
//  Created by Luc Casimir on 13/02/2021.
//

import SwiftUI

struct HomeView: View {
    
    @State private var list = (0...10).map({$0})
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Device.id_, ascending: true)],
        animation: .default)
    private var devices: FetchedResults<Device>
    
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

                    NavigationLink(destination: FilterView()) {
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
        self.list.remove(atOffsets: offsets)
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

struct FilterView: View {
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(.blue)
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

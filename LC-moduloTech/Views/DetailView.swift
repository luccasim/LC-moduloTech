//
//  DetailView.swift
//  LC-moduloTech
//
//  Created by Luc Casimir on 14/02/2021.
//

import SwiftUI

struct DetailView: View {
    
    private var device : Device
    
    init(Device:Device) {
        self.device = Device
    }
    
    var body: some View {
        deviceTypeView()
    }
    
    @ViewBuilder func deviceTypeView() -> some View {
        switch self.device.type {
        case .RollerShutter: RollerShutterView()
        case .Heater: HeaterView()
        case .Light: LightView()
        default: HomeView()
        }
    }
    
}

struct HeaterView: View {
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(.red)
        }
    }
}

struct LightView: View {
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(.blue)
        }
    }
}

struct RollerShutterView: View {
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(.green)
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(Device: <#Device#>)
//    }
//}

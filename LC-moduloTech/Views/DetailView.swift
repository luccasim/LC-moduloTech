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
        default: LightView()
        }
    }
    
}

/// We didnt need split theses view on others files, they're pretty straighforward.

private struct HeaterView: View {
    
    @State var mode : Bool = false
    @State var temperature : Double = 0
    
    var calculedTemp : Double {
        let temp = Int(temperature / 2)
        let mod = Int(temperature) % 2
        return 7.0 + Double(temp) + Double(mod) * 0.5
    }
    
    var body: some View {
        VStack {
            Form {
                Toggle("Mode \(self.mode ? "ON" : "OFF")", isOn: self.$mode)
                VStack {
                    Text("temperature \(String(format: "%.1f", self.calculedTemp))")
                    Slider(value: self.$temperature, in: 0...42)
                }
            }
        }
    }
}

private struct LightView: View {
    
    @State var mode : Bool = false
    @State var intensity : Double = 0
    
    var body: some View {
        VStack {
            Form {
                Toggle("Mode \(self.mode ? "ON" : "OFF")", isOn: self.$mode)
                VStack {
                    Text("Intensity \(String(format: "%.0f", self.intensity))")
                    Slider(value: self.$intensity, in: 0...100)
                }
            }
        }
    }
}

private struct RollerShutterView: View {
    
    @State private var position = 0.0

    var body: some View {
        VStack {
            Form {
                Text("Position \(self.position)")
                Slider(value: self.$position, in: 0...100)
                    .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .rotationEffect(.init(degrees: 90))
            }
        }
    }
}

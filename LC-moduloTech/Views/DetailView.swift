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
        
        case .RollerShutter:
            if let roller = device as? RollerShutter {
                RollerShutterView(Roller:roller)
            }
            
        case .Heater:
            if let heater = device as? Heater {
                HeaterView(heater: heater)
            }
            
        case .Light:
            if let light = device as? Light {
                LightView(Light: light)
            }
            
        default: Text("C'est pas normal cette vue, Tu doutes!")
        }
    }
}

/// We didnt need split theses view on others files, they're pretty straighforward.
private struct HeaterView: View {
    
    private var heater : Heater

    @State var mode : Bool = false
    @State var temperature : Double = 0
    
    init(heater:Heater) {
        _mode = State(initialValue: heater.mode)
        _temperature = State(initialValue: heater.temperature)
        self.heater = heater
    }
    
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
        .navigationTitle(self.heater.name)
        .onDisappear(perform: {
            self.updateDevice()
        })
    }
    
    func updateDevice() {
        self.heater.update(NewTemperature: self.calculedTemp, NewMode: self.mode)
    }
}

private struct LightView: View {
    
    private  var light : Light
    
    @State var mode : Bool = false
    @State var intensity : Double = 0
    
    init(Light:Light) {
        _mode = State(initialValue: Light.mode_)
        _intensity = State(initialValue: Light.intensity)
        self.light = Light
    }
    
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
        .navigationTitle(self.light.name)
        .onDisappear(perform: {
            self.light.udpate(NewIntensity: self.intensity, NewMode: self.mode)
        })
    }
}

private struct RollerShutterView: View {
    
    private var roller : RollerShutter
    
    @State private var position = 0.0
    
    init(Roller:RollerShutter) {
        _position = State(initialValue: Roller.position)
        self.roller = Roller
    }

    var body: some View {
        VStack {
            Form {
                Text("Position \(String(format: "%.0f", self.position))")
                Slider(value: self.$position, in: 0...100)
                    .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .rotationEffect(.init(degrees: 270))
            }
        }
        .navigationTitle(self.roller.name)
        .onDisappear(perform: {
            self.roller.update(newPosition: self.position)
        })
    }
}

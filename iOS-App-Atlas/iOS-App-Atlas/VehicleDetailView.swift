//
//  VehicleDetailView.swift
//  Vehicle App
//
//  Created by Arnaldo Vera on 24/12/23.
//

import SwiftUI
import RealmSwift

struct VehicleDetailView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var showNetworkAlert = false
    
    @ObservedRealmObject var vehicle: vehicle_data
    var realm: Realm
    @State private var showingCommandView = false
    @State private var observer: NSKeyValueObservation?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("CONTROLS")) {
                    Toggle(isOn: $vehicle.LightsOn) {
                        Text("Truck On")
                    }
                    Toggle(isOn: $vehicle.Driver_Door_Open) {
                        Text("Open Trailer Door")
                    }
                    
                }
                Section(header: Text("Battery")) {
                    HStack {
                        Text("Temperature")
                        Spacer()
                        Text(String(format: "%.1f °C", vehicle.Battery_Temp ?? 1.0))
                    }
                    HStack {
                        Text("Charge Limit")
                        Spacer()
                        Text(String(format: "%.0f %%", vehicle.Battery_Current ?? 1.0))
                        //                        Text("\(vehicle.Powertrain?.Battery?.SOC?.Current ?? 0)")
                    }
                    HStack {
                        Text("Status")
                        Spacer()
                        // This is not the most accurate in terms of real application MIL isn't related to battery status. But just for demo pursposes.
                        if (vehicle.Battery_Status_OK == true) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            
                        } else {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                                .imageScale(.large)
                        }
                    }
                }
                
                Button(action: {showingCommandView = true}){
                    Text("Send Command").frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationBarTitle("Connected to Atlas")
        .onChange(of: networkMonitor.isConnected) { connection in
            showNetworkAlert = connection == false
        }
        .alert(
            "Network connection seems to be offline.",
            isPresented: $showNetworkAlert
        ) {}
    }
}

struct DeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let realm = try! Realm()
        VehicleDetailView(vehicle: vehicle_data(), realm: realm)
    }
}

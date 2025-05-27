//
//  ComputerList.swift
//  Assignment
//
//  Created by Kunal on 03/01/25.
//

import SwiftUI

struct DevicesList: View {
    let devices: [DeviceData]
    let onSelect: (DeviceData) -> Void // Callback for item selection

    var body: some View {
        List(devices) { device in
            Button {
                onSelect(device)
            } label: {
                buttonView(device)
            }
        }
    }
    
    private func buttonView(_ device: DeviceData) -> some View {
        VStack(alignment: .leading) {
            AssignmentText(text: device.name)
            if let data = device.data {
                if let color = data.color {
                    AssignmentText(text: "Color: \(color)", font: .caption)
                }
                if let price = data.price {
                    AssignmentText(text: "Price: $\(price)", font: .caption)
                }
                if let description = data.description {
                    AssignmentText(text: "Description: \(description)", font: .caption)
                }
            }
        }
    }
}

//
//  ContentView.swift
//  Assignment
//
//  Created by Kunal on 03/01/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var path: [DeviceData] = [] // Navigation path

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                VStack {
                    textFieldView()
                    
                    if let computers = viewModel.data, !computers.isEmpty {
                        if !viewModel.searchedData.isEmpty {
                            DevicesList(devices: viewModel.searchedData) { selectedComputer in
                                viewModel.navigateToDetail(navigateDetail: selectedComputer)
                            }
                        } else {
                            DevicesList(devices: computers) { selectedComputer in
                                viewModel.navigateToDetail(navigateDetail: selectedComputer)
                            }
                        }
                    } else {
                        ProgressView("Loading...")
                    }
                    Spacer()
                }
            }
            .onChange(of: viewModel.navigateDetail, {
                let navigate = viewModel.navigateDetail
                path.append(navigate!)
            })
            .navigationTitle("Devices")
            .navigationDestination(for: DeviceData.self) { computer in
                DetailView(device: computer)
            }
            .task {
                viewModel.fetchAPI()
            }
        }
    }
    
    private func textFieldView() -> some View {
        TextField("Search text", text: $viewModel.textFieldText)
            .padding()
            .background(Color.gray.opacity(0.7))
            .cornerRadius(8.0)
    }
}

#Preview {
    ContentView()
}

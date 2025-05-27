//
//  ContentViewModel.swift
//  Assignment
//
//  Created by Kunal on 10/01/25.
//

import Foundation
import Combine
import Network


class ContentViewModel : ObservableObject {
    
    private let apiService = ApiService()
    @Published var navigateDetail: DeviceData? = nil
    @Published var data: [DeviceData]? = []
    @Published var textFieldText = ""
    @Published var searchedData: [DeviceData] = []
    @Published var isUserConnectedWithInternet: Bool = true
    private var cancellables = Set<AnyCancellable>()
    private let userDefaultKey = "AppData"
    private let monitor = NWPathMonitor()
    
    init() {
        monitorInternetConnection()
        subscribeTextFieldText()
        subscribeInternetConnection()
    }
    
    func subscribeInternetConnection() {
        $isUserConnectedWithInternet
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let welf = self else {
                    return
                }
                
                if value {
                    welf.fetchAPI()
                } else {
                    welf.getPersistentData()
                }
            }
            .store(in: &cancellables)
    }

    private func fetchAPI() {
        apiService.fetchDeviceDetails(completion: { [weak self] item in
            guard let welf = self else { return }
            
            welf.data = item
            welf.saveData(item)
        })
    }
    
    func navigateToDetail(navigateDetail: DeviceData) {
        self.navigateDetail = navigateDetail
    }
}


// MARK: TextField
extension ContentViewModel {
    private func subscribeTextFieldText() {
        $textFieldText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let welf = self else {
                    return
                }
                
                welf.searchDataUpdate(text)
            }
            .store(in: &cancellables)
    }
    
    private func searchDataUpdate(_ text: String) {
        self.searchedData.removeAll()
        
        guard let data = data else { return }
        
        for item in data {
            if item.name.localizedStandardContains(text) {
                searchedData.append(item)
            }
        }
        
        print("searchedData -> \(searchedData)")
    }
}

extension ContentViewModel {
    func getPersistentData() {
        if let storedData = UserDefaults.standard.string(forKey: userDefaultKey) {
            print("Prashant- \(storedData)")
        }
    }
    
    private func saveData(_ data: [DeviceData]) {
        UserDefaults.standard.set(data, forKey: userDefaultKey)
    }
}

extension ContentViewModel {
    func monitorInternetConnection () {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let welf = self else {
                return
            }
            
            if path.status == .satisfied {
                print("Internet connection is available")
                welf.isUserConnectedWithInternet = true
            } else {
                print("Internet connection is not available")
                welf.isUserConnectedWithInternet = false
            }
        }
    }
}

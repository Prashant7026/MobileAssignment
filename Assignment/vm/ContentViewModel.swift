//
//  ContentViewModel.swift
//  Assignment
//
//  Created by Kunal on 10/01/25.
//

import Foundation
import Combine


class ContentViewModel : ObservableObject {
    
    private let apiService = ApiService()
    @Published var navigateDetail: DeviceData? = nil
    @Published var data: [DeviceData]? = []
    @Published var textFieldText = ""
    @Published var searchedData: [DeviceData] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        subscribeTextFieldText()
    }

    func fetchAPI() {
        apiService.fetchDeviceDetails(completion: { [weak self] item in
            guard let welf = self else { return }
            
            welf.data = item
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

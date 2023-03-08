//
//  UserListViewModel.swift
//  Genaic Network Layer
//
//  Created by Madushan Senavirathna on 2023-03-08.
//

import Foundation
import Combine

class UserListViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let networkManager = NetworkManager()
    private var cancellable: AnyCancellable?
    
    func fetchUsers() {
        isLoading = true
        cancellable = networkManager.makeRequest(urlString: "https://api.example.com/users",
                                                  httpMethod: "GET")
            .sink(receiveCompletion: { [weak self] result in
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (users: [User]) in
                guard let self = self else { return }
                self.users = users
            })
    }
}

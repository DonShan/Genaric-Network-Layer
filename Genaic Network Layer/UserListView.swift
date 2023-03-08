//
//  UserListView.swift
//  Genaic Network Layer
//
//  Created by Madushan Senavirathna on 2023-03-08.
//

import SwiftUI

struct UserListView: View {
    
    @StateObject var viewModel = UserListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                    } else {
                        List(viewModel.users, id: \.id) { user in
                            VStack(alignment: .leading) {
                                Text(user.name)
                                    .font(.headline)
                                Text(user.email)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Users")
            .onAppear {
                viewModel.fetchUsers()
            }
        }
    }
}


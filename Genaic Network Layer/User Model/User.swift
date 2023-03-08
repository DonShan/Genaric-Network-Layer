//
//  User.swift
//  Genaic Network Layer
//
//  Created by Madushan Senavirathna on 2023-03-08.
//

import Foundation
import Combine

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
}

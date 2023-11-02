//
//  MyErrors.swift
//  Part-time job
//
//  Created by Ильнур Закиров on 31.10.2023.
//

import Foundation

enum NetworkErrors: Error {
    case wrongURL
    
    var localizedDescription: String {
        switch self {
        case .wrongURL:
            "Неверный адрес запроса"
        }
    }
}

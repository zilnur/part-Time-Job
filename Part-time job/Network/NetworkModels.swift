//
//  NetworkModels.swift
//  Part-time job
//
//  Created by Ильнур Закиров on 31.10.2023.
//

import Foundation

struct PartTimeJob: Decodable, Hashable {
    let profession: String
    let salary: Double
    let logo: String?
    let date: String
    let employer: String
    let id: String
}

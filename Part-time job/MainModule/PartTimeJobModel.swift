//
//  PartTimeJobModel.swift
//  Part-time job
//
//  Created by Ильнур Закиров on 02.11.2023.
//

import Foundation

struct PartTimeJobModel: Hashable {
    let profession: String
    let salary: Double
    let logo: String?
    let date: String
    let employer: String
    let id: String
    var isSelected: Bool
}

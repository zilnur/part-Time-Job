//
//  String+.swift
//  Part-time job
//
//  Created by Ильнур Закиров on 01.11.2023.
//

import Foundation

extension String {
    
    enum Format: String {
        case date = "dd.MM"
        case time = "hh:mm"
    }
    
    ///Преобразование строки в дату и обратно в строку с заданным форматом
    func toDate(format: Format) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = format.rawValue
            return dateFormatter.string(from: date)
        } else {
            return "Ошибка"
        }
    }
}

//
//  NetworkService.swift
//  Part-time job
//
//  Created by Ильнур Закиров on 31.10.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func task<model: Decodable>(modelType: model.Type, handler: @escaping (Result<model, Error>) -> Void) throws
}

class NetworkService {
    
    //Ввиду отсутствия альтернативных путей в метод не добавлены параметры path и queryItems
    ///Создание URL из строки с помощью URLComponents
    private func url() throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "taverna.su"
        components.path = "/jobs"
        if let url = components.url {
            return url
        } else {
            throw NetworkErrors.wrongURL
        }
    }
    
    ///Декодирование данных в указанный тип
    private func decoder<model: Decodable>(data: Data, modelType: model.Type) throws -> model {
        let decoder = JSONDecoder()
        let model = try decoder.decode(modelType.self, from: data)
        return model
    }
}

extension NetworkService: NetworkServiceProtocol {
    ///Запрос в сеть с дальнейшей обработкой результата в замыкании
    func task<model: Decodable>(modelType: model.Type, handler: @escaping (Result<model, Error>) -> Void) throws {
        let url = try url()
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _ , error in
            guard let self else { return }
            if let data {
                do {
                    let model = try self.decoder(data: data, modelType: modelType)
                    handler(.success(model))
                } catch let jsonError {
                    handler(.failure(jsonError))
                }
            } else if let error {
                handler(.failure(error))
            }
        }
        task.resume()
    }
}

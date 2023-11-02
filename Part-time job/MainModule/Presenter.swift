//
//  Presenter.swift
//  Part-time job
//
//  Created by Ильнур Закиров on 31.10.2023.
//

import Foundation

protocol PresenterProtocol {
    func fetchModel(searchFilter: String)
    func getModel(searchFilter: String) -> [PartTimeJob]
    func jobSelected(searchFilter: String, indexPath: IndexPath)
    func setButtonConfigurationData(searchFilter: String) -> (count: Int, sumSalary: Double) 
}

class Presenter {
    
    var model = [PartTimeJob]()
    var network: NetworkServiceProtocol
    var view: ViewProtocol
    
    init(network: NetworkServiceProtocol, view: ViewProtocol) {
        self.network = network
        self.view = view
    }
    
}

extension Presenter: PresenterProtocol {
    ///Заполнение модели
    func fetchModel(searchFilter: String) {
        do {
            try network.task(modelType: [PartTimeJob].self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let model):
                    self.model = model
                    DispatchQueue.main.async {
                        self.view.reloadViews(model: self.getModel(searchFilter: searchFilter))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.view.alert(rirle: "Ошибка", text: error.localizedDescription, handler: nil)
                    }
                }
            }
        } catch NetworkErrors.wrongURL {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.view.alert(rirle: "Ошибка", text: NetworkErrors.wrongURL.localizedDescription, handler: nil)
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.view.alert(rirle: "Ошибка", text: error.localizedDescription, handler: nil)
            }
        }
    }
    
    ///Передача модели для заполнения UI с учетом фильтрации
    func getModel(searchFilter: String) -> [PartTimeJob] {
        if searchFilter.count > 0 {
            let filteredModel = model.filter {$0.profession.contains(searchFilter) || $0.employer.contains(searchFilter)}
            return filteredModel
        } else {
            return model
        }
    }
    
    ///Сохранение/удаление выбранной работы
    func jobSelected(searchFilter: String, indexPath: IndexPath) {
        if !UserDefaults.standard.bool(forKey: getModel(searchFilter: searchFilter)[indexPath.item].id) {
            UserDefaults.standard.setValue(true, forKey: getModel(searchFilter: searchFilter)[indexPath.item].id)
        } else {
            UserDefaults.standard.removeObject(forKey: getModel(searchFilter: searchFilter)[indexPath.item].id)
        }
    }
    
    ///Передача данных для настройки кнопки
    func setButtonConfigurationData(searchFilter: String) -> (count: Int, sumSalary: Double) {
        var count = 0
        var sumSalary: Double = 0
        let model = getModel(searchFilter: searchFilter)
        model.forEach { job in
            let bool = UserDefaults.standard.bool(forKey: job.id)
            guard bool else { return }
            count += 1
            sumSalary += job.salary
        }
        return (count, sumSalary)
    }
}

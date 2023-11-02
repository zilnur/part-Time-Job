//
//  Factory.swift
//  Part-time job
//
//  Created by Ильнур Закиров on 02.11.2023.
//

import UIKit

protocol FactoryProtocol {
    func addMainModule(network: NetworkServiceProtocol) -> UIViewController
}

class Factory: FactoryProtocol {
    
    var presenter: Presenter?
    
    func addMainModule(network: NetworkServiceProtocol) -> UIViewController {
        let view = ViewController()
        presenter = Presenter(network: network, view: view)
        view.presenter = presenter
        let navigation = UINavigationController(rootViewController: view)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        navigation.navigationBar.standardAppearance = appearance
        navigation.navigationBar.scrollEdgeAppearance = appearance
        return navigation
    }
}

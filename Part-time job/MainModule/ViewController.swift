//
//  ViewController.swift
//  Part-time job
//
//  Created by Ильнур Закиров on 31.10.2023.
//

import UIKit

protocol ViewProtocol {
    func reloadViews(model: [PartTimeJob])
    func alert(rirle: String, text: String, handler: ((UIAlertAction) -> Void)?)
}

class ViewController: UIViewController {
    
    weak var presenter: Presenter?
    
    private let searchBar = UISearchBar()
    private var dataSource: UICollectionViewDiffableDataSource<Int, PartTimeJob>!
    private var mainView: MainView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureMainView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.fetchModel(searchFilter: searchBar.text ?? "")
    }
    
    private func configureMainView() {
        mainView = MainView(delegate: self)
        view = mainView
    }
    
    private func configureSearchBar() {
        searchBar.placeholder = "Поиск"
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
}

// MARK: - ViewProtocol
extension ViewController: ViewProtocol {
    
    ///Перезагрузка коллекции
    func reloadViews(model: [PartTimeJob]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, PartTimeJob>()
        snapshot.appendSections([0])
        snapshot.appendItems(model)
        dataSource.apply(snapshot, animatingDifferences: true)
        mainView.setButtonTitleAndColor(count: presenter!.setButtonConfigurationData(searchFilter: "").count)
    }
    
    ///Вызов алерта
    func alert(rirle: String, text: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default,handler: handler)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

// MARK: - MainViewProtocol
extension ViewController: MainViewProtocol {
    
    ///Создание и настройка DataSource для коллекции
    func dataSource(collectionView: UICollectionView) {
        collectionView.delegate = self
        let cellReginstration = UICollectionView.CellRegistration<CollectionViewCell, PartTimeJob> { cell,indexPath,itemIdentifier in
            guard let presenter = self.presenter else { return }
            cell.setupValues(model: presenter.getModel(searchFilter: self.searchBar.text ?? "")[indexPath.item])
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: {  collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellReginstration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    ///Создание действия при нажатии кнопки
    func buttonActionConfiguration() {
        guard let presenter = presenter else { return }
        let salary = presenter.setButtonConfigurationData(searchFilter: "").sumSalary
        alert(rirle: "Поздравляем", text: "Вы заработали " + String(localized: "\(salary) money")) { [weak self] _ in
            guard let self,
            let presenter = self.presenter else { return }
            presenter.removeSavedJobs()
            self.reloadViews(model: presenter.getModel(searchFilter: self.searchBar.text ?? ""))
        }
    }
    
    ///Обновляет модель и перезагружает коллекцию если потянуть вниз
    func pullToReload() {
        guard let presenter else { return }
        presenter.fetchModel(searchFilter: searchBar.text ?? "")
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell,
              let presenter = presenter else { return }
        presenter.jobSelected(searchFilter: searchBar.text ?? "", indexPath: indexPath)
        cell.cellSelected()
        UIView.animate(withDuration: 0.4) { [unowned self] in
            self.mainView.setButtonTitleAndColor(count: presenter.setButtonConfigurationData(searchFilter: "").count)
        }
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
    //Обновление таблицы при вводе слова в поисковую строку
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let presenter = presenter else { return }
        reloadViews(model: presenter.getModel(searchFilter: searchText))
    }
    
    //Скрытие клавиатуры по нажатию на клавишу "Найти"
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension ViewController: UIScrollViewDelegate {
    //Скритые клавиатуры при скролле
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

//
//  ButtonView.swift
//  Part-time job
//
//  Created by Ильнур Закиров on 01.11.2023.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func dataSource(collectionView: UICollectionView)
    func buttonActionConfiguration()
}

class MainView: UIView {
    
    private var button: UIButton!
    private var backgroundView: UIView!
    var collectionView: UICollectionView!
    weak var delegate: MainViewProtocol!
    
    init(delegate: MainViewProtocol) {
        super.init(frame: .zero)
        self.delegate = delegate
        configureCollectionView()
        configureBackgroundView()
        configureButton()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        button = UIButton()
        button.layer.cornerRadius = 6.93
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func configureBackgroundView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.alpha = 0.8
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(105))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.showsVerticalScrollIndicator = false
        delegate.dataSource(collectionView: collectionView)
        let insets = UIEdgeInsets(top: 8, left: 0, bottom: 84, right: 0)
        collectionView.contentInset = insets
    }
    
    ///Установка Layout
    private func setupView() {
        [collectionView, backgroundView, button].forEach {addSubview($0)}
        backgroundView.anchor(leading: leadingAnchor,
                              bottom: bottomAnchor,
                              trailing: trailingAnchor)
        button.anchor(top: backgroundView.topAnchor,
                      leading: backgroundView.leadingAnchor,
                      bottom: backgroundView.bottomAnchor,
                      trailing: backgroundView.trailingAnchor,
                      padding: UIEdgeInsets(top: 16, left: 16, bottom: 36, right: 16),
                      size: CGSize(width: 0, height: 48))
        collectionView.anchor(top: topAnchor,
                              leading: leadingAnchor,
                              bottom: bottomAnchor,
                              trailing: trailingAnchor)
    }
    
    @objc
    private func buttonTapped() {
        delegate.buttonActionConfiguration()
    }
    
    ///Заполнение сабвью
    func setButtonTitleAndColor(count: Int) {
        let color: UIColor = count == .zero ? .grayBackground : .yellowBackground
        let text = count == .zero ? "Забронировать подработки" : "Забронировать " + String(localized: "\(count) job")
        button.setTitle(text, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.black, for: .normal)
        button.isEnabled = count == .zero ? false : true
    }
}

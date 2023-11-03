//
//  TextWithColorBackground.swift
//  Part-time job
//
//  Created by Ильнур Закиров on 31.10.2023.
//

import UIKit

class TextWithColorBackground: UIView {

    private var textLabel: UILabel!
    
    init(isGray: Bool) {
        super.init(frame: .zero)
        layer.cornerRadius = 4
        backgroundColor = isGray ? .grayBackground : .yellowBackground
        configureSubView()
        addSubiew()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubView() {
        textLabel = UILabel()
        textLabel.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    private func addSubiew() {
        addSubview(textLabel)
        textLabel.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor,
                         padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
    }
    
    func setupText(text: String?) {
        guard let text else { return }
        textLabel.text = text
    }

}

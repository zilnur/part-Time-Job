//
//  CollectionViewCell.swift
//  Part-time job
//
//  Created by Ильнур Закиров on 31.10.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    private var professionLabel: UILabel!
    private var priceLabel: TextWithColorBackground!
    private var logoImageView: UIImageView!
    private var companyLabel: UILabel!
    private var dateLabel: TextWithColorBackground!
    private var timeLabel: TextWithColorBackground!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubViews()
        contentView.backgroundColor = .white
        backgroundColor = .clear
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 15
        layer.masksToBounds = false
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 15)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 20, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX - 20, y: rect.midY))
        path.lineWidth = 1
        let color = UIColor.systemGroupedBackground
        color.setStroke()
        path.stroke()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        professionLabel.text = nil
        priceLabel.setupText(text: nil)
        logoImageView.image = nil
        companyLabel.text = nil
        timeLabel.setupText(text: nil)
        dateLabel.setupText(text: nil)
    }
    
    private func configSubViews() {
        professionLabel = UILabel()
        professionLabel.font = .systemFont(ofSize: 17, weight: .semibold)

        priceLabel = TextWithColorBackground(isGray: false)
        
        logoImageView = UIImageView()
        logoImageView.clipsToBounds = true
        logoImageView.layer.cornerRadius = 16
        logoImageView.layer.borderWidth = 1
        logoImageView.layer.borderColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
        
        companyLabel = UILabel()
        companyLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        dateLabel = TextWithColorBackground(isGray: true)
        
        timeLabel = TextWithColorBackground(isGray: true)
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        [professionLabel, priceLabel, logoImageView, companyLabel, dateLabel, timeLabel].forEach{contentView.addSubview($0)}
        
        professionLabel.anchor(top: contentView.topAnchor,
                               leading: contentView.leadingAnchor,
                               padding: UIEdgeInsets(top: 15, left: 20, bottom: 0, right: 0))
        
        priceLabel.anchor(top: contentView.topAnchor,
                          trailing: contentView.trailingAnchor,
                          padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 20))
        
        logoImageView.anchor(top: professionLabel.bottomAnchor,
                             leading: contentView.leadingAnchor,
                             bottom: contentView.bottomAnchor,
                             padding: UIEdgeInsets(top: 26, left: 20, bottom: 10, right: 0),
                             size: CGSize(width: 32, height: 32))
        
        companyLabel.anchor(leading: logoImageView.trailingAnchor,
                            bottom: contentView.bottomAnchor,
                            padding: UIEdgeInsets(top: 0, left: 12, bottom: 18, right: 0))
        
        timeLabel.anchor(bottom: contentView.bottomAnchor,
                         trailing: contentView.trailingAnchor,
                         padding: UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 20))
        
        dateLabel.anchor(bottom: contentView.bottomAnchor,
                         trailing: timeLabel.leadingAnchor,
                         padding: UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 4))
    }
    
    ///Заполнение SubViews
    func setupValues(model: PartTimeJob) {
        professionLabel.text = model.profession
        priceLabel.setupText(text: model.salary.formatted(.number))
        logoImageView.imageFromServerURL(model.logo ?? "", placeHolder: UIImage(systemName: "hourglass"))
        companyLabel.text = model.employer
        timeLabel.setupText(text: model.date.toDate(format: .time))
        dateLabel.setupText(text: model.date.toDate(format: .date))
        self.layer.shadowColor = UserDefaults.standard.bool(forKey: model.id) ? UIColor.yellowBackground.cgColor : UIColor.grayShadow.cgColor
    }
    
    ///Изменение цвета тени
    func cellSelected() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.layer.shadowColor = self.layer.shadowColor == UIColor.grayShadow.cgColor ? UIColor.yellowBackground.cgColor : UIColor.grayShadow.cgColor
        }
    }
}

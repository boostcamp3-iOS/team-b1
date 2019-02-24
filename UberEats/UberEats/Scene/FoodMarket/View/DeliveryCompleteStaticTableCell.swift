//
//  TableViewCell.swift
//  uberEats
//
//  Created by admin on 24/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common

class DeliveryCompleteStaticTableCell: UITableViewCell {

    public var storeInfo: (state: Bool, storeName: String, storeImageURL: String)? {
        didSet {
            guard let storeInfo = storeInfo else {
                return
            }

            self.storeName.text = storeInfo.storeName
        }
    }

    private var storeName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let deliveryComplete: UILabel = {
        let label = UILabel()
        label.text = "배달 완료"
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let deliveryCompleteSetence: UILabel = {
        let label = UILabel()
        label.text = "주문이 성공적으로 배달되었습니다."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let storeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "discountImage")
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let deliveryRateButton: UIButton = {
       let button = UIButton()
       button.setTitle("주문 평가하기", for: .normal)
       button.translatesAutoresizingMaskIntoConstraints = false
       button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
       return button
    }()

    private let ContactButton: UIButton = {
        let button = UIButton()
        button.setTitle("문의 하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.borderColor = .black
        button.borderWidth = 0.5
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    private func setupLayout() {

        addSubview(storeName)
        addSubview(deliveryComplete)
        addSubview(deliveryCompleteSetence)
        addSubview(storeImage)
        addSubview(deliveryRateButton)
        addSubview(ContactButton)

        NSLayoutConstraint.activate([
            storeName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            storeName.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            storeName.widthAnchor.constraint(equalToConstant: 250),
            storeName.heightAnchor.constraint(equalToConstant: 50),

            deliveryComplete.topAnchor.constraint(equalTo: storeName.bottomAnchor, constant: 0),
            deliveryComplete.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            deliveryComplete.widthAnchor.constraint(equalToConstant: 250),
            deliveryComplete.heightAnchor.constraint(equalToConstant: 45),

            deliveryCompleteSetence.topAnchor.constraint(equalTo: deliveryComplete.bottomAnchor, constant: -3),
            deliveryCompleteSetence.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            deliveryCompleteSetence.widthAnchor.constraint(equalToConstant: 250),
            deliveryCompleteSetence.heightAnchor.constraint(equalToConstant: 40),

            storeImage.widthAnchor.constraint(equalToConstant: 80),
            storeImage.heightAnchor.constraint(equalToConstant: 80),
            storeImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            storeImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),

            deliveryRateButton.widthAnchor.constraint(equalToConstant: 130),
            deliveryRateButton.heightAnchor.constraint(equalToConstant: 33),
            deliveryRateButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            deliveryRateButton.topAnchor.constraint(equalTo: deliveryCompleteSetence.bottomAnchor, constant: 5),

            ContactButton.widthAnchor.constraint(equalToConstant: 130),
            ContactButton.heightAnchor.constraint(equalToConstant: 33),
            ContactButton.leadingAnchor.constraint(equalTo: deliveryRateButton.trailingAnchor, constant: 10),
            ContactButton.topAnchor.constraint(equalTo: deliveryRateButton.topAnchor)

            ])

        backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)

        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

}

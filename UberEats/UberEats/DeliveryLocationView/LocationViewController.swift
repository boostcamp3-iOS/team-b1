//
//  LocationViewController.swift
//  UberEats
//
//  Created by 이혜주 on 02/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {
    private let backButton = UIButton().initButtonWithImage("blackArrow")
    
    private let arrivalTimeHeaderId: String = "orderChecking"
    private let orderNameHeaderId: String = "orderName"
    private let tempHeaderId: String = "tempHeader"
    
    private let separatorFooterId: String = "separator"
    private let totalPriceFooterId: String = "totalPrice"
    private let tempFooterId: String = "tempFooter"
    
    private let orderCancelCellId: String = "orderCancel"
    private let orderMenuCellId: String = "orderedMenu"
    
    private let orders = ["초콜렛 밀크티 (아이스, 라지) Chocolate Milk Tea (Iced, Large)",
                          "아메리카노 (아이스, 라지) Americano (Iced, Large)",
                          "블랙 밀크티+펄(아이스, 라지) Black Milk Tea+Pearl(Iced, Large)"]

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var orderDetailCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCollectionViewLayout()
        setupCollectionView()
    }
    
    private func setupLayout() {
        self.view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            backButton.widthAnchor.constraint(equalToConstant: buttonSize),
            backButton.heightAnchor.constraint(equalToConstant: buttonSize)
            ])
    }
    
    private func setupCollectionViewLayout() {
        if let layout = orderDetailCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
        }
    }
    
    private func setupCollectionView() {
        orderDetailCollectionView.contentInset = UIEdgeInsets(top: view.frame.height * 0.55,
                                                              left: 0,
                                                              bottom: 0,
                                                              right: 0)
        
        let arrivalTimeHeaderNib = UINib(nibName: "OrderCheckingCollectionReusableView",
                                         bundle: nil)
        
        //headers
        orderDetailCollectionView.register(arrivalTimeHeaderNib,
                                           forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                           withReuseIdentifier: arrivalTimeHeaderId)
        
        orderDetailCollectionView.register(OrderNameCollectionReusableView.self,
                                           forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                           withReuseIdentifier: orderNameHeaderId)
        
        orderDetailCollectionView.register(TempCollectionReusableView.self,
                                           forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                           withReuseIdentifier: tempHeaderId)
        
        //footers
        orderDetailCollectionView.register(SeparatorCollectionReusableView.self,
                                           forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                           withReuseIdentifier: separatorFooterId)
        
        orderDetailCollectionView.register(TotalPriceCollectionReusableView.self,
                                           forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                           withReuseIdentifier: totalPriceFooterId)
        
        orderDetailCollectionView.register(TempCollectionReusableView.self,
                                           forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                           withReuseIdentifier: tempFooterId)
        
        //cells
        orderDetailCollectionView.register(OrderCancelCollectionViewCell.self,
                                           forCellWithReuseIdentifier: orderCancelCellId)
        
        orderDetailCollectionView.register(OrderedMenuCollectionViewCell.self,
                                           forCellWithReuseIdentifier: orderMenuCellId)
        
    }

}

extension LocationViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let section = SectionName(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .timeDetail, .sale:
            return 1
        case .orders:
            return orders.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: orderCancelCellId,
                                                          for: indexPath)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: orderMenuCellId,
                                                                for: indexPath) as? OrderedMenuCollectionViewCell else {
                return .init()
            }
            cell.orderMenuLabel.text = orders[indexPath.item]
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
            cell.backgroundColor = .green
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            switch indexPath.section {
            case 0:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: arrivalTimeHeaderId,
                                                                             for: indexPath)
                return header
            case 1:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: orderNameHeaderId,
                                                                             for: indexPath)
                return header
            default:
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: tempHeaderId,
                                                                       for: indexPath)
            }
        } else {
            switch indexPath.section {
            case 0:
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: separatorFooterId,
                                                                             for: indexPath)
                return footer
            case 1:
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: totalPriceFooterId,
                                                                             for: indexPath)
                return footer
            default:
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: tempFooterId,
                                                                       for: indexPath)
            }
        }
    }
}

extension LocationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return .init(width: self.view.frame.width - 20, height: 200)
        case 1:
            return .init(width: self.view.frame.width - 20, height: 60)
        default:
            return .init(width: self.view.frame.width - 20, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        switch section {
        case 1:
            return .init(width: self.view.frame.width - 20, height: 50)
        default:
            return .init(width: self.view.frame.width - 20, height: 10)
        }
    }
}

extension LocationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return .init(width: self.view.frame.width - 20, height: 40)
        default:
            return .init(width: self.view.frame.width - 20, height: 65)
        }
    }
}

private enum SectionName: Int {
    case timeDetail = 0
    case orders
    case sale
}

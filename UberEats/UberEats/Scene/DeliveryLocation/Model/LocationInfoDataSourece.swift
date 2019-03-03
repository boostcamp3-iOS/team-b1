//
//  LocationInfoDataSourece.swift
//  UberEats
//
//  Created by 이혜주 on 03/03/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common

class LocationInfoDataSourece: NSObject, UICollectionViewDataSource {
    var storeName: String
    var orders: [OrderInfoModel]
    var delivererInfo: DelivererInfo
    weak var locationViewController: LocationViewController?

    init(storeName: String,
         orders: [OrderInfoModel],
         delivererInfo: DelivererInfo,
         locationViewController: LocationViewController) {
        self.storeName = storeName
        self.orders = orders
        self.delivererInfo = delivererInfo
        self.locationViewController = locationViewController
        super.init()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = SectionName(rawValue: section) else {
            return 0
        }

        switch section {
        case .orders:
            return orders.count
        default:
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = SectionName(rawValue: indexPath.section) else {
            return .init()
        }

        switch section {
        case .deliveryManInfo:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as OrderCancelCollectionViewCell

            cell.configure(status: true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak cell] in
                cell?.configure(status: false)
            }

            return cell
        case .timeDetail:
            return collectionView.dequeueReusableCell(for: indexPath) as OrderCancelCollectionViewCell
        case .orders:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as OrderedMenuCollectionViewCell

            cell.configure(orderInfo: orders[indexPath.item])

            return cell
        case .sale:
            return collectionView.dequeueReusableCell(for: indexPath) as SaleCollectionViewCell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard let section = SectionName(rawValue: indexPath.section) else {
            return .init()
        }

        if kind == UICollectionView.elementKindSectionHeader {
            switch section {
            case .deliveryManInfo:
                let header
                    = collectionView
                        .dequeueReusableSupplementaryView(for: indexPath,
                                                          kind: kind) as DeliveryManInfoCollectionReusableView

                DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak header] in
                    header?.isHidden = false
                }

                header.configure(delivererInfo: delivererInfo)
                header.changeScrollDelegate = locationViewController

                return header
            case .timeDetail:
                let header
                    = collectionView.dequeueReusableSupplementaryView(for: indexPath,
                                                                      kind: kind) as OrderCheckingCollectionReusableView

                DispatchQueue.main.asyncAfter(deadline: .now() + 15) { [weak header] in
                    header?.progressStatus = .preparingFood
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak header] in
                    header?.progressStatus = .delivering
                }

                let currentTime = NSDate().addingTimeInterval(60)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"

                guard let locationViewController = locationViewController else {
                    return .init()
                }

                header.configure(storeName: storeName,
                                 time: dateFormatter.string(from: currentTime as Date),
                                 status: .verifyingOrder,
                                 locationViewController: locationViewController)

                return header
            case .orders:
                return collectionView.dequeueReusableSupplementaryView(for: indexPath,
                                                                       kind: kind) as OrderNameCollectionReusableView
            case .sale:
                return collectionView.dequeueReusableSupplementaryView(for: indexPath,
                                                                       kind: kind) as SeparatorCollectionReusableView
            }
        } else {
            switch section {
            case .deliveryManInfo, .timeDetail:
                return collectionView.dequeueReusableSupplementaryView(for: indexPath,
                                                                       kind: kind) as SeparatorCollectionReusableView
            case .orders:
                let footer
                    = collectionView.dequeueReusableSupplementaryView(for: indexPath,
                                                                      kind: kind) as TotalPriceCollectionReusableView

                var totalPrice = 0

                orders.forEach {
                    totalPrice += $0.price * $0.amount
                }

                footer.configure(totalPrice: String(totalPrice.formattedWithSeparator))

                return footer
            case .sale:
                return collectionView.dequeueReusableSupplementaryView(for: indexPath,
                                                                       kind: kind) as TempCollectionReusableView
            }
        }
    }
}

//
//  Reusable.swift
//  UberEats
//
//  Created by 이혜주 on 02/03/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

protocol Reusable {}

extension Reusable where Self: UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension Reusable where Self: UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: Reusable {

}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ : T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionViewCell>(nib: UINib, _ : T.Type) {
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionReusableView>(_ : T.Type, kind: String) {
        register(T.self,
                 forSupplementaryViewOfKind: kind,
                 withReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionReusableView>(nib: UINib, _ : T.Type, kind: String) {
        register(nib,
                 forSupplementaryViewOfKind: kind,
                 withReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier,
                                             for: indexPath) as? T else {
                                                return .init()
        }
        return cell
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(for indexPath: IndexPath, kind: String) -> T {
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind,
                                                          withReuseIdentifier: T.reuseIdentifier,
                                                          for: indexPath) as? T else {
            return .init()
        }
        return cell
    }
}

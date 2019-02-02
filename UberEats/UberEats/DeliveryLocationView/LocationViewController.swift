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
    private let arrivalTimeCellId: String = "OrderCheckingCollectionViewCell"

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var orderDetailCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCollectionView()
    }
    
    func setupLayout() {
        self.view.backgroundColor = .white
    }
    
    func setupCollectionView() {
        orderDetailCollectionView.contentInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
        
        let arrivalTimeNib = UINib(nibName: "OrderCheckingCollectionViewCell", bundle: nil)
        orderDetailCollectionView.register(arrivalTimeNib, forCellWithReuseIdentifier: arrivalTimeCellId)
    }

}

extension LocationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: arrivalTimeCellId, for: indexPath)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
            return cell
        }
    }
}

extension LocationViewController: UICollectionViewDelegate {
    
}

extension LocationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        case 0:
            return .init(width: self.view.frame.width - 20, height: 100)
        default:
            return .init(width: self.view.frame.width - 20, height: 50)
        }
    }
}

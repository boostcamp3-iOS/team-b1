//
//  LocationViewController.swift
//  UberEats
//
//  Created by 이혜주 on 02/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class LocationViewController: UIViewController {
    private let topInset: CGFloat = 450
    // 배달이 시작되면 130으로 아니면 0으로 바꿀것
    private var deliveryStartInfoHeight: CGFloat = 0

    private let backButton = UIButton().initButtonWithImage("blackArrow")
    private let moveCurrentLocationButton = UIButton().initButtonWithImage("btCurrentlocation")
    private let contactButton = UIButton().initButtonWithImage("btInquiry")

    private let orders = ["초콜렛 밀크티 (아이스, 라지) Chocolate Milk Tea (Iced, Large)",
                          "아메리카노 (아이스, 라지) Americano (Iced, Large)",
                          "블랙 밀크티+펄(아이스, 라지) Black Milk Tea+Pearl(Iced, Large)"]

    private let sectionHeader = UICollectionView.elementKindSectionHeader
    private let sectionFooter = UICollectionView.elementKindSectionFooter

    private let deliveryStartView = DeliveryStartNoticeView()
    private var mapView: GMSMapView?
    private let locationManager = CLLocationManager()
    private var userLocation = CLLocationCoordinate2D(latitude: 37.49646975398706, longitude: 127.02905088660754)

    private var isStartingDelivery: Bool = false

    let contactLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "문의하기"
        label.font = .systemFont(ofSize: 11)
        return label
    }()

    lazy var orderDetailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = #colorLiteral(red: 0.9525781274, green: 0.9469152093, blue: 0.9569309354, alpha: 1)
        collectionView.contentInset = UIEdgeInsets(top: self.view.frame.height * 0.4 + deliveryStartInfoHeight, left: 10, bottom: 0, right: 10)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        orderDetailCollectionView.delegate = self
        orderDetailCollectionView.dataSource = self
        setupMapView()
        setupLayout()
        setupCollectionView()
    }

    private func setupMapView() {
        // 장치에서 위치 서비스가 사용된다면
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            //위치 데이터 정확도 설정
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            // 얼마큼 이동했을 때 위치 갱신할 것인지
            locationManager.distanceFilter = 500.0
            locationManager.startUpdatingLocation()
        }

        // user와 deliverer의 중간 지점으로 설정할 것
        let camera = GMSCameraPosition(latitude: (userLocation.latitude + 37.499862) / 2,
                                       longitude: (userLocation.longitude + 127.030378) / 2,
                                       zoom: 17)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView?.padding = UIEdgeInsets(top: 0, left: 10, bottom: self.view.frame.height - 500 + 10, right: 0)
        orderDetailCollectionView.backgroundView = mapView

        let userMarker = GMSMarker(position: userLocation)
        userMarker.icon = UIImage(named: "first")
        userMarker.title = "메리츠타워"
        userMarker.map = mapView

        let delivererLocation = CLLocationCoordinate2D(latitude: 37.499862, longitude: 127.030378)
        let delivererMarker = GMSMarker(position: delivererLocation)
        delivererMarker.icon = UIImage(named: "second")
        delivererMarker.title = "공차"
        delivererMarker.map = mapView
    }

    private func setupLayout() {
        self.view.addSubview(orderDetailCollectionView)
        self.orderDetailCollectionView.backgroundView?.addSubview(moveCurrentLocationButton)
        self.orderDetailCollectionView.backgroundView?.addSubview(deliveryStartView)
        self.orderDetailCollectionView.addSubview(backButton)
        self.orderDetailCollectionView.addSubview(contactButton)
        self.orderDetailCollectionView.addSubview(contactLabel)

        backButton.addTarget(self, action: #selector(touchUpBackButton(_:)),
                             for: .touchUpInside)
        moveCurrentLocationButton.addTarget(self,
                                            action: #selector(touchUpMoveCurrentLocationButton(_:)),
                                            for: .touchUpInside)

        backButton.addTarget(self, action: #selector(touchUpBackButton(_:)), for: .touchUpInside)

        NSLayoutConstraint.activate([

            orderDetailCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            orderDetailCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            orderDetailCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            orderDetailCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            backButton.widthAnchor.constraint(equalToConstant: buttonSize),
            backButton.heightAnchor.constraint(equalToConstant: buttonSize),

            contactButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            contactButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            contactButton.widthAnchor.constraint(equalToConstant: buttonSize),
            contactButton.heightAnchor.constraint(equalToConstant: buttonSize),

            contactLabel.centerYAnchor.constraint(equalTo: contactButton.centerYAnchor),
            contactLabel.trailingAnchor.constraint(equalTo: contactButton.leadingAnchor, constant: -5),

            moveCurrentLocationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                                constant: -15),
            moveCurrentLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                              constant: topInset - 10),
            moveCurrentLocationButton.widthAnchor.constraint(equalToConstant: 32),
            moveCurrentLocationButton.heightAnchor.constraint(equalToConstant: 32),

            deliveryStartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            deliveryStartView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            deliveryStartView.heightAnchor.constraint(equalToConstant: 70),
            deliveryStartView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }

    private func setupCollectionView() {
        //headers
        let deliveryManInfoHeaderNib = UINib(nibName: "DeliveryManInfoCollectionReusableView",
                                             bundle: nil)

        orderDetailCollectionView.register(deliveryManInfoHeaderNib, forSupplementaryViewOfKind: sectionHeader, withReuseIdentifier: Identifiers.deliveryManInfoHeaderId)

        let arrivalTimeHeaderNib = UINib(nibName: "OrderCheckingCollectionReusableView",
                                         bundle: nil)

        orderDetailCollectionView.register(arrivalTimeHeaderNib,
                                           forSupplementaryViewOfKind: sectionHeader,
                                           withReuseIdentifier: Identifiers.arrivalTimeHeaderId)

        orderDetailCollectionView.register(OrderNameCollectionReusableView.self,
                                           forSupplementaryViewOfKind: sectionHeader,
                                           withReuseIdentifier: Identifiers.orderNameHeaderId)

        orderDetailCollectionView.register(TempCollectionReusableView.self,
                                           forSupplementaryViewOfKind: sectionHeader,
                                           withReuseIdentifier: Identifiers.tempHeaderId)

        orderDetailCollectionView.register(SeparatorCollectionReusableView.self,
                                           forSupplementaryViewOfKind: sectionHeader,
                                           withReuseIdentifier: Identifiers.separatorHeaderId)

        //footers
        orderDetailCollectionView.register(SeparatorCollectionReusableView.self,
                                           forSupplementaryViewOfKind: sectionFooter,
                                           withReuseIdentifier: Identifiers.separatorFooterId)

        orderDetailCollectionView.register(TotalPriceCollectionReusableView.self,
                                           forSupplementaryViewOfKind: sectionFooter,
                                           withReuseIdentifier: Identifiers.totalPriceFooterId)

        orderDetailCollectionView.register(TempCollectionReusableView.self,
                                           forSupplementaryViewOfKind: sectionFooter,
                                           withReuseIdentifier: Identifiers.tempFooterId)

        //cells
        orderDetailCollectionView.register(OrderCancelCollectionViewCell.self,
                                           forCellWithReuseIdentifier: Identifiers.orderCancelCellId)

        orderDetailCollectionView.register(OrderedMenuCollectionViewCell.self,
                                           forCellWithReuseIdentifier: Identifiers.orderMenuCellId)

        orderDetailCollectionView.register(EmptyCollectionViewCell.self,
                                           forCellWithReuseIdentifier: Identifiers.emptyCellId)

    }

    @objc private func touchUpBackButton(_: UIButton) {
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func touchUpMoveCurrentLocationButton(_: UIButton) {
        mapView?.animate(to: GMSCameraPosition(latitude: (userLocation.latitude + 37.499862) / 2,
                                                longitude: (userLocation.longitude + 127.030378) / 2,
                                                zoom: 17))
    }
}

extension LocationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentScroll = scrollView.contentOffset.y

        print("currentScroll \(currentScroll)")

        if currentScroll > -deliveryStartInfoHeight {
            mapView?.alpha = 0
        } else {
            mapView?.alpha = -currentScroll / (view.frame.height * 0.4 + deliveryStartInfoHeight)
        }
    }
}

extension LocationViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let section = SectionName(rawValue: section) else {
            return 0
        }

        switch section {
        case .deliveryManInfo, .timeDetail, .sale:
            return 1
        case .orders:
            return orders.count
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let section = SectionName(rawValue: indexPath.section) else {
            return .init()
        }

        switch section {
        case .deliveryManInfo:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.orderCancelCellId,
                                                                for: indexPath) as? OrderCancelCollectionViewCell else {
                                                                    return .init()
            }

            cell.cancelLabel.text = "연락처"
            cell.isHidden = true

            return cell
        case .timeDetail:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.orderCancelCellId,
                                                          for: indexPath)
            return cell
        case .orders:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.orderMenuCellId,
                                                                for: indexPath) as? OrderedMenuCollectionViewCell else {
                return .init()
            }
            cell.orderMenuLabel.text = orders[indexPath.item]

            return cell
        case .sale:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.emptyCellId, for: indexPath)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard let section = SectionName(rawValue: indexPath.section) else {
            return .init()
        }

        var identifier = ""

        if kind == UICollectionView.elementKindSectionHeader {
            switch section {
            case .deliveryManInfo:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: Identifiers.deliveryManInfoHeaderId,
                                                                             for: indexPath)
                header.isHidden = true

                return header
            case .timeDetail:
                identifier = Identifiers.arrivalTimeHeaderId
            case .orders:
                identifier = Identifiers.orderNameHeaderId
            case .sale:
                identifier = Identifiers.separatorHeaderId
            }
        } else {
            switch section {
            case .deliveryManInfo, .timeDetail:
                identifier = Identifiers.separatorFooterId
            case .orders:
                identifier = Identifiers.totalPriceFooterId
            case .sale:
                identifier = Identifiers.tempFooterId
            }
        }

        return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                               withReuseIdentifier: identifier,
                                                               for: indexPath)
    }
}

extension LocationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {

        guard let section = SectionName(rawValue: section) else {
            return .init(width: 0, height: 0)
        }

        switch section {
        case .deliveryManInfo:
            return .init(width: self.view.frame.width - 20, height: 90)
        case .timeDetail:
            return .init(width: self.view.frame.width - 20, height: 200)
        case .orders:
            return .init(width: self.view.frame.width - 20, height: 60)
        case .sale:
            return .init(width: self.view.frame.width - 20, height: 10)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {

        guard let section = SectionName(rawValue: section) else {
            return .init(width: 0, height: 0)
        }

        switch section {
        case .orders:
            return .init(width: self.view.frame.width - 20, height: 50)
        case .deliveryManInfo, .timeDetail, .sale:
            return .init(width: self.view.frame.width - 20, height: 10)
        }
    }
}

extension LocationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let section = SectionName(rawValue: indexPath.section) else {
            return .init(width: 0, height: 0)
        }

        switch section {
        case .deliveryManInfo, .timeDetail:
            return .init(width: self.view.frame.width - 20, height: 40)
        case .orders:
            return .init(width: self.view.frame.width - 20, height: 65)
        case .sale:
            return .init(width: self.view.frame.width - 20, height: 100)
        }
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location")
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        self.userLocation = locValue
    }
}

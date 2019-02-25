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
import Common

class LocationViewController: UIViewController {
    private let topInset: CGFloat = 450
    // 배달이 시작되면 130으로 아니면 0으로 바꿀것
    private var deliveryStartInfoHeight: CGFloat = 0

    @IBOutlet weak var coveredBackButton: UIButton!
    @IBOutlet weak var coveredContactButton: UIButton!

    private let backButton = UIButton().initButtonWithImage("blackArrow")
    private let moveCurrentLocationButton = UIButton().initButtonWithImage("btCurrentlocation")
    private let contactButton = UIButton().initButtonWithImage("btInquiry")

    private let delivererInfo = DelivererInfo.init(name: "중현",
                                                   rate: 100,
                                                   image: UIImage(named: "deliverer"),
                                                   vehicle: "motorbike",
                                                   phoneNumber: "01020313421",
                                                   email: "delivery@gmail.com")

    var orders: [OrderInfoModel]?

    var storeName: String?
    var storeLocationInfo: Location?
    var storeImageURL: String?

    private let sectionHeader = UICollectionView.elementKindSectionHeader
    private let sectionFooter = UICollectionView.elementKindSectionFooter

    private let deliveryStartView = DeliveryStartNoticeView()
    private var mapView: GMSMapView?
    private let userWindow = UserLocationView()
    private let storeWindow = StoreLocationView()
    private let locationManager = CLLocationManager()
    private var storeLocationCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    private var userLocationCoordinate = CLLocationCoordinate2D(latitude: 37.49646975398706, longitude: 127.02905088660754)

    private var userMarker = GMSMarker()
    private var storeMarker = GMSMarker()

    private var isStartingDelivery: Bool = false

    let contactLabel: UILabel = {
        let label = UILabel().setupWithFontSize(11)
        label.text = "문의하기"
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
        collectionView.contentInset = UIEdgeInsets(top: self.view.frame.height * 0.4 + deliveryStartInfoHeight - 30,
                                                   left: 10,
                                                   bottom: self.view.frame.height * 0.2,
                                                   right: 10)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        storeWindow.storeName = storeName

        orderDetailCollectionView.delegate = self
        orderDetailCollectionView.dataSource = self
        setupMapView()
        setupLayout()
        setupCollectionView()

        DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak self] in
            guard let self = self else {
                return
            }

            self.backButton.setImage(UIImage(named: "btnClose"), for: .normal)
            self.coveredBackButton.setImage(UIImage(named: "btnClose"), for: .normal)
            self.deliveryStartView.isHidden = false
            self.deliveryStartInfoHeight = 130
            self.orderDetailCollectionView.contentInset = UIEdgeInsets(top: self.view.frame.height * 0.4
                                                                            + self.deliveryStartInfoHeight - 30,
                                                                       left: 10,
                                                                       bottom: 0,
                                                                       right: 10)

            self.orderDetailCollectionView.contentOffset.y = self.orderDetailCollectionView.contentOffset.y - 130
            self.view.layoutIfNeeded()
        }
    }

    private func setupMapView() {
        guard let locationInfo = storeLocationInfo else {
            return
        }

        storeLocationCoordinate = CLLocationCoordinate2D(latitude: locationInfo.latitude,
                                                         longitude: locationInfo.longtitude)

        locationManager.customInit(delegate: self)
        let zoom = getZoomValue(userLocation2D: userLocationCoordinate, storeLocation2D: storeLocationCoordinate)

        let camera = GMSCameraPosition(latitude: (userLocationCoordinate.latitude + storeLocationCoordinate.latitude) / 2,
                                       longitude: (userLocationCoordinate.longitude + storeLocationCoordinate.longitude) / 2,
                                       zoom: zoom)

        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView?.padding = UIEdgeInsets(top: 0,
                                        left: 10,
                                        bottom: view.frame.height
                                            - (view.frame.height * 0.4 + 130
                                                - deliveryStartInfoHeight),
                                        right: 0)
        mapView?.delegate = self
        orderDetailCollectionView.backgroundView = mapView

        userMarker = GMSMarker(position: userLocationCoordinate)
        userMarker.icon = UIImage(named: "icMarkUser")
        userMarker.map = mapView

        storeMarker = GMSMarker(position: storeLocationCoordinate)
        storeMarker.icon = UIImage(named: "icMarkDelivery")
        storeMarker.map = mapView
    }

    private func getZoomValue(userLocation2D: CLLocationCoordinate2D, storeLocation2D: CLLocationCoordinate2D) -> Float {
        let userLocation = CLLocation(latitude: userLocation2D.latitude, longitude: userLocation2D.longitude)
        let storeLocation = CLLocation(latitude: storeLocation2D.latitude, longitude: storeLocation2D.longitude)

        let distance = userLocation.distance(from: storeLocation)

        if distance > 3000 {
            return 13
        } else if distance > 2000 {
            return 14
        } else if distance > 1000 {
            return 15
        } else {
            return 16
        }
    }

    private func setupLayout() {
        deliveryStartView.delivererName = delivererInfo.name

        self.view.addSubview(orderDetailCollectionView)
        self.orderDetailCollectionView.backgroundView?.addSubview(moveCurrentLocationButton)
        self.orderDetailCollectionView.backgroundView?.addSubview(deliveryStartView)
        self.orderDetailCollectionView.backgroundView?.addSubview(userWindow)
        self.orderDetailCollectionView.backgroundView?.addSubview(storeWindow)
        self.orderDetailCollectionView.addSubview(backButton)
        self.orderDetailCollectionView.addSubview(contactButton)
        self.orderDetailCollectionView.addSubview(contactLabel)

        backButton.addTarget(self,
                             action: #selector(touchUpBackButton(_:)),
                             for: .touchUpInside)

        moveCurrentLocationButton.addTarget(self,
                                            action: #selector(touchUpMoveCurrentLocationButton(_:)),
                                            for: .touchUpInside)

        backButton.addTarget(self,
                             action: #selector(touchUpBackButton(_:)),
                             for: .touchUpInside)
        coveredContactButton.addTarget(self,
                                       action: #selector(touchUpBackButton(_:)),
                                       for: .touchUpInside)

        let buttonTopConstant = getButtonTopConstraint(UIScreen.main.nativeBounds.height)

        NSLayoutConstraint.activate([
            coveredBackButton.widthAnchor.constraint(equalToConstant: buttonSize),
            coveredBackButton.heightAnchor.constraint(equalToConstant: buttonSize),

            coveredContactButton.widthAnchor.constraint(equalToConstant: buttonSize),
            coveredContactButton.heightAnchor.constraint(equalToConstant: buttonSize),

            orderDetailCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            orderDetailCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            orderDetailCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            orderDetailCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: buttonTopConstant),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            backButton.widthAnchor.constraint(equalToConstant: buttonSize),
            backButton.heightAnchor.constraint(equalToConstant: buttonSize),

            contactButton.topAnchor.constraint(equalTo: view.topAnchor, constant: buttonTopConstant),
            contactButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            contactButton.widthAnchor.constraint(equalToConstant: buttonSize),
            contactButton.heightAnchor.constraint(equalToConstant: buttonSize),

            contactLabel.centerYAnchor.constraint(equalTo: contactButton.centerYAnchor),
            contactLabel.trailingAnchor.constraint(equalTo: contactButton.leadingAnchor, constant: -5),

            moveCurrentLocationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                                constant: -15),
            moveCurrentLocationButton.bottomAnchor.constraint(equalTo: view.topAnchor,
                                                              constant: view.frame.height * 0.4 + 130 - deliveryStartInfoHeight - 10),
            moveCurrentLocationButton.widthAnchor.constraint(equalToConstant: 32),
            moveCurrentLocationButton.heightAnchor.constraint(equalToConstant: 32),

            deliveryStartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            deliveryStartView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            deliveryStartView.heightAnchor.constraint(equalToConstant: 70),
            deliveryStartView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }

    private func getButtonTopConstraint(_ height: CGFloat) -> CGFloat {
        switch height {
        case 960, 1136, 1334, 1920, 2208:
            return 25
        case 1792, 2436, 2688:
            return 45
        default:
            return 0
        }
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

        orderDetailCollectionView.register(SaleCollectionViewCell.self,
                                           forCellWithReuseIdentifier: Identifiers.saleCellId)

    }

    @IBAction func touchUpCoveredBackButton(_ sender: UIButton) {
        touchUpBackButton(sender)
        navigationController?.isNavigationBarHidden = true
    }

    @objc private func touchUpBackButton(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc private func touchUpMoveCurrentLocationButton(_: UIButton) {
        mapView?.animate(to: GMSCameraPosition(latitude: (userLocationCoordinate.latitude + storeLocationCoordinate.latitude) / 2,
                                                longitude: (userLocationCoordinate.longitude + storeLocationCoordinate.longitude) / 2,
                                                zoom: 17))
    }
}

extension LocationViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        var userWindowPoint = mapView.projection.point(for: userMarker.position)
        userWindowPoint.x += 9
        userWindowPoint.y -= 60
        userWindow.frame = CGRect(x: userWindowPoint.x, y: userWindowPoint.y, width: 150, height: 40)

        var storeWindowPoint = mapView.projection.point(for: storeMarker.position)
        storeWindowPoint.x += 8
        storeWindowPoint.y += 2
        storeWindow.frame = CGRect(x: storeWindowPoint.x, y: storeWindowPoint.y, width: 150, height: 50)

    }

}

extension LocationViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        func getMapViewAlpha(_ currentY: CGFloat) -> CGFloat {
            let ret = -currentY / (view.frame.height * 0.4 + deliveryStartInfoHeight)
            return currentY > -deliveryStartInfoHeight ? 0 : ret
        }

        let currentScroll = scrollView.contentOffset.y

        mapView?.alpha = getMapViewAlpha(currentScroll)
        navigationController?.updateNavigationBarStatus(currentScroll, deliveryStartInfoHeight)

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
            return orders?.count ?? 0
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

            DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak cell] in
                cell?.isHidden = false
            }

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

            guard let order = orders?[indexPath.item] else {
                return cell
            }

            cell.foodName = order.orderName
            cell.numberOfFood = order.amount

            return cell
        case .sale:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.saleCellId, for: indexPath)
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
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: Identifiers.deliveryManInfoHeaderId,
                                                                             for: indexPath) as? DeliveryManInfoCollectionReusableView else {
                    return .init()
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak header] in
                    header?.isHidden = false
                }

                header.delivererInfo = delivererInfo
                header.delegate = self

                return header
            case .timeDetail:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: Identifiers.arrivalTimeHeaderId,
                                                                             for: indexPath) as? OrderCheckingCollectionReusableView else {
                    return .init()
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 15) { [weak header] in
                    header?.progressStatus = .preparingFood
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak header] in
                    header?.progressStatus = .delivering
                }

                let currentTime = NSDate().addingTimeInterval(60)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                header.arrivalTime = dateFormatter.string(from: currentTime as Date)
                header.storeNameLabel.text = storeName

                header.progressStatus = .verifyingOrder

                header.changeScrollDelegate = self
                header.deliveryCompleteDelegate = self

                return header
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            guard let chattingVC = UIStoryboard.chatView.instantiateViewController(withIdentifier: "ChattingViewController") as? ChattingViewController else {
                return
            }

            chattingVC.delivererInfo = delivererInfo

            present(chattingVC, animated: true, completion: nil)
        } else if indexPath == IndexPath(row: 0, section: 1) {
            navigationController?.popViewController(animated: true)
        }
    }

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
        guard let _ : CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
    }
}

extension LocationViewController: ChangeScrollDelegate {
    func scrollToTop() {
        orderDetailCollectionView.setContentOffset(CGPoint(x: -10, y: 37 - deliveryStartInfoHeight), animated: true)
    }
}

extension LocationViewController: DeliveryCompleteDelegate {
    func moveToFoodMarket() {
        // 여기서 배달완료 상태값 바꿔주면 될 것 같습니다.
        let foodMarketStoryboard = UIStoryboard(name: "ItemView", bundle: nil)
        guard let foodMarketViewController = foodMarketStoryboard.instantiateViewController(withIdentifier: "itemView")
            as? ItemViewController else {
                return
        }

        guard let storeName = storeName,
            let storeImageURL = storeImageURL else {
                return
        }

        foodMarketViewController.completeState = (state: false, storeName: storeName, storeImageURL: storeImageURL)
        navigationController?.popToRootViewController(animated: true)
    }
}

private extension CLLocationManager {

    func customInit(delegate: CLLocationManagerDelegate) {
        if CLLocationManager.locationServicesEnabled() {
            self.delegate = delegate
            //위치 데이터 정확도 설정
            self.desiredAccuracy = kCLLocationAccuracyBest
            // 얼마큼 이동했을 때 위치 갱신할 것인지
            self.distanceFilter = 500.0
            self.startUpdatingLocation()
        }
    }

}

extension UINavigationController {
    func updateNavigationBarStatus(_ currentY: CGFloat, _ height: CGFloat) {
        let isHidden = currentY > -height ? false : true
        self.setNavigationBarHidden(isHidden, animated: true)
    }
}

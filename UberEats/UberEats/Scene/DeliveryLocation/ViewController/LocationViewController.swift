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

    @IBOutlet weak var coveredBackButton: UIButton!
    @IBOutlet weak var coveredContactButton: UIButton!

    private var zoom: Float = 0
    private var mapView: GMSMapView?
    private var userMarker = GMSMarker()
    private var storeMarker = GMSMarker()
    private var isStartingDelivery: Bool = false
    private var deliveryStartInfoHeight: CGFloat = 0
    private var storeLocationCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    private var userLocationCoordinate = CLLocationCoordinate2D(latitude: 37.49646975398706, longitude: 127.02905088660754)

    private let topInset: CGFloat = 450
    private let userWindow = UserLocationView()
    private let storeWindow = StoreLocationView()
    private let locationManager = CLLocationManager()
    private let deliveryStartView = DeliveryStartNoticeView()
    private let backButton = UIButton().initButtonWithImage("blackArrow")
    private let contactButton = UIButton().initButtonWithImage("btInquiry")
    private let moveCurrentLocationButton = UIButton().initButtonWithImage("btCurrentlocation")

    var storeImageURL: String?
    var storeLocationInfo: Location?
    var locationInfoDataSource: LocationInfoDataSourece?

    private let contactLabel: UILabel = {
        let label = UILabel().setupWithFontSize(11)
        label.text = "문의하기"
        return label
    }()

    private lazy var orderDetailCollectionView: UICollectionView = {
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

        orderDetailCollectionView.delegate = self
        orderDetailCollectionView.dataSource = locationInfoDataSource

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
        guard let locationInfo = storeLocationInfo,
            let storeName = locationInfoDataSource?.storeName else {
            return
        }

        storeWindow.configure(storeName: storeName)

        storeLocationCoordinate = CLLocationCoordinate2D(latitude: locationInfo.latitude,
                                                         longitude: locationInfo.longtitude)

        zoom = getZoomValue(userLocation2D: userLocationCoordinate, storeLocation2D: storeLocationCoordinate)

        let camera = GMSCameraPosition(latitude: (userLocationCoordinate.latitude
                                                    + storeLocationCoordinate.latitude) / 2,
                                       longitude: (userLocationCoordinate.longitude
                                                    + storeLocationCoordinate.longitude) / 2,
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

    private func setupLayout() {
        guard let delivererName = locationInfoDataSource?.delivererInfo.name else {
            return
        }
        deliveryStartView.configure(delivererName: delivererName)

        view.addSubview(orderDetailCollectionView)
        orderDetailCollectionView.backgroundView?.addSubview(moveCurrentLocationButton)
        orderDetailCollectionView.backgroundView?.addSubview(deliveryStartView)
        orderDetailCollectionView.backgroundView?.addSubview(userWindow)
        orderDetailCollectionView.backgroundView?.addSubview(storeWindow)
        orderDetailCollectionView.addSubview(backButton)
        orderDetailCollectionView.addSubview(contactButton)
        orderDetailCollectionView.addSubview(contactLabel)

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

            backButton.topAnchor.constraint(equalTo: view.topAnchor,
                                            constant: buttonTopConstant),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: 15),
            backButton.widthAnchor.constraint(equalToConstant: buttonSize),
            backButton.heightAnchor.constraint(equalToConstant: buttonSize),

            contactButton.topAnchor.constraint(equalTo: view.topAnchor,
                                               constant: buttonTopConstant),
            contactButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                    constant: -15),
            contactButton.widthAnchor.constraint(equalToConstant: buttonSize),
            contactButton.heightAnchor.constraint(equalToConstant: buttonSize),

            contactLabel.centerYAnchor.constraint(equalTo: contactButton.centerYAnchor),
            contactLabel.trailingAnchor.constraint(equalTo: contactButton.leadingAnchor,
                                                   constant: -5),

            moveCurrentLocationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                                constant: -15),
            moveCurrentLocationButton.bottomAnchor.constraint(equalTo: view.topAnchor,
                                                              constant: view.frame.height * 0.4
                                                                + 130 - deliveryStartInfoHeight - 10),
            moveCurrentLocationButton.widthAnchor.constraint(equalToConstant: 32),
            moveCurrentLocationButton.heightAnchor.constraint(equalToConstant: 32),

            deliveryStartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                   constant: 60),
            deliveryStartView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                     multiplier: 0.9),
            deliveryStartView.heightAnchor.constraint(equalToConstant: 70),
            deliveryStartView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }

    private func setupCollectionView() {
        //headers
        let deliveryManInfoHeaderNib = UINib(nibName: "DeliveryManInfoCollectionReusableView",
                                             bundle: nil)

        orderDetailCollectionView.register(nib: deliveryManInfoHeaderNib,
                                           DeliveryManInfoCollectionReusableView.self,
                                           kind: ElementKind.sectionHeader)

        let arrivalTimeHeaderNib = UINib(nibName: "OrderCheckingCollectionReusableView",
                                         bundle: nil)

        orderDetailCollectionView.register(nib: arrivalTimeHeaderNib,
                                           OrderCheckingCollectionReusableView.self,
                                           kind: ElementKind.sectionHeader)

        orderDetailCollectionView.register(OrderNameCollectionReusableView.self,
                                           kind: ElementKind.sectionHeader)

        orderDetailCollectionView.register(SeparatorCollectionReusableView.self,
                                           kind: ElementKind.sectionHeader)

        //footers
        orderDetailCollectionView.register(SeparatorCollectionReusableView.self,
                                           kind: ElementKind.sectionFooter)

        orderDetailCollectionView.register(TotalPriceCollectionReusableView.self,
                                           kind: ElementKind.sectionFooter)

        orderDetailCollectionView.register(TempCollectionReusableView.self,
                                           kind: ElementKind.sectionFooter)

        //cells
        orderDetailCollectionView.register(OrderCancelCollectionViewCell.self)

        orderDetailCollectionView.register(OrderedMenuCollectionViewCell.self)

        orderDetailCollectionView.register(SaleCollectionViewCell.self)

    }

    @IBAction func touchUpCoveredBackButton(_ sender: UIButton) {
        touchUpBackButton(sender)
        navigationController?.isNavigationBarHidden = true
    }

    @objc private func touchUpBackButton(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc private func touchUpMoveCurrentLocationButton(_: UIButton) {
        mapView?.animate(to: GMSCameraPosition(latitude: (userLocationCoordinate.latitude
                                                            + storeLocationCoordinate.latitude) / 2,
                                                longitude: (userLocationCoordinate.longitude
                                                            + storeLocationCoordinate.longitude) / 2,
                                                zoom: zoom))
    }
}

extension LocationViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        var userWindowPoint = mapView.projection.point(for: userMarker.position)
        userWindowPoint.x += 9
        userWindowPoint.y -= 60
        userWindow.frame = CGRect(x: userWindowPoint.x,
                                  y: userWindowPoint.y,
                                  width: 150,
                                  height: 40)

        var storeWindowPoint = mapView.projection.point(for: storeMarker.position)
        storeWindowPoint.x += 8
        storeWindowPoint.y += 2
        storeWindow.frame = CGRect(x: storeWindowPoint.x,
                                   y: storeWindowPoint.y,
                                   width: 150,
                                   height: 50)

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
        navigationController?.updateNavigationBarStatus(currentScroll,
                                                        deliveryStartInfoHeight)
    }

}

extension LocationViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            guard let chattingVC = UIStoryboard.chatView
                                               .instantiateViewController(withIdentifier: "ChattingViewController")
                                                as? ChattingViewController else {
                return
            }

            chattingVC.delivererInfo = locationInfoDataSource?.delivererInfo

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
        default:
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
        case .orders:
            return .init(width: self.view.frame.width - 20, height: 65)
        case .sale:
            return .init(width: self.view.frame.width - 20, height: 100)
        default:
            return .init(width: self.view.frame.width - 20, height: 40)
        }
    }

}

extension LocationViewController: ChangeScrollDelegate {
    func scrollToTop() {
        orderDetailCollectionView.setContentOffset(CGPoint(x: -10,
                                                           y: 37 - deliveryStartInfoHeight),
                                                   animated: true)
    }
}

extension LocationViewController: DeliveryCompleteDelegate {
    func moveToFoodMarket() {
        guard let foodMarketViewController = navigationController?.viewControllers[0]
                                                        as? ItemViewController else {
            return
        }

        guard let storeName = locationInfoDataSource?.storeName,
            let storeImageURL = storeImageURL else {
                return
        }

        foodMarketViewController.completeState = (state: true,
                                                  storeName: storeName,
                                                  storeImageURL: storeImageURL)

        navigationController?.popToRootViewController(animated: true)
    }
}

extension UINavigationController {
    func updateNavigationBarStatus(_ currentY: CGFloat, _ height: CGFloat) {
        let isHidden = currentY > -height ? false : true
        self.setNavigationBarHidden(isHidden, animated: true)
    }
}

//
//  SeeMoreRestViewController.swift
//  UberEats
//
//  Created by admin on 20/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common
import Service
import ServiceInterface
import DependencyContainer

class SeeMoreRestViewController: UIViewController {

    private var tableView: UITableView = {
        let tableView = UITableView()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    lazy var dataIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.view.frame.width,
                                 height: self.view.frame.height)
        indicator.hidesWhenStopped = true
        indicator.style = .gray
        indicator.backgroundColor = .white
        return indicator
    }()

    private var foods: [FoodForView]?

    private var stores: [StoreForView]?

    public var section: TableViewSection?

    private var foodMarketService: FoodMarketService = DependencyContainer.share.getDependency(key: .foodMarketService)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        view.addSubview(dataIndicator)

        tableView.separatorStyle = .none

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

        guard let collectionViewTag = section else {
            return
        }

        initFoodMarket(section: collectionViewTag)
        setupTableView()

    }

    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.navigationBar.backItem?.setLeftBarButton(UIBarButtonItem(image: #imageLiteral(resourceName: "blackArrow"), style: .plain, target: self, action: #selector(popAction)), animated: true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @objc private func popAction() {
        self.navigationController?.popViewController(animated: true)
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        let SeeMoreRestTableViewCellNIB = UINib(nibName: "SeeMoreRestTableViewCell", bundle: nil)
        tableView.register(SeeMoreRestTableViewCellNIB, forCellReuseIdentifier: "SeeMoreRestTableViewCellId")

        tabBarController?.tabBar.isHidden = true
    }

    private func initFoodMarket(section: TableViewSection) {
        dataIndicator.startAnimating()
        switch section {
        case .expectedTime, .nearestRest, .newRest:
            reloadTableViewStoreData(section: section)
            self.title = setTitle(section: section)
        default:
            break
        }
    }

    private func setTitle(section: TableViewSection) -> String {
        switch section {
        case .expectedTime:
            return "예상시간 30분 이하"
        case .nearestRest:
            return "가까운 인기 레스토랑"
        case .newRest:
            return "새로운 레스토랑"
        case .recommendFood:
            return "추천 요리"
        default:
            return ""
        }
    }

    private func reloadTableViewStoreData(section: TableViewSection) {
        foodMarketService.requestFoodMarketMore(dispatchQueue: DispatchQueue.global(), section: section) { [weak self] (dataResponse) in
            if dataResponse.isSuccess {
                switch section {
                case .expectedTime:
                    guard let expectTimeRest = dataResponse.value else {
                        return
                    }
                    self?.stores = expectTimeRest
                case .nearestRest:
                    guard let nearestRest = dataResponse.value else {
                        return
                    }
                    self?.stores = nearestRest
                case .newRest:
                    guard let newRest = dataResponse.value else {
                        return
                    }
                    self?.stores = newRest
                default:
                    break
                }
            } else {
                fatalError()
            }

            self?.tableView.reloadData()
            self?.dataIndicator.stopAnimating()
        }
    }

}

extension SeeMoreRestViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let foods = self.foods {
            return foods.count
        }

        if let stores = self.stores {
            return stores.count
        }

        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let collectionViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "CollectionViewController")
                as? StoreCollectionViewController else {
                    return
            }

            guard let stores = stores else {
                return
            }

            collectionViewController.passingData(status: SelectState.store(stores[indexPath.row].id))

            tabBarController?.tabBar.isHidden = true
            navigationController?.setNavigationBarHidden(true, animated: false)
            navigationController?.pushViewController(collectionViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let moreRestTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "SeeMoreRestTableViewCellId",
            for: indexPath) as? SeeMoreRestTableViewCell else {
                return .init()
        }

        if let stores = self.stores {
            if stores.count > indexPath.row {
                moreRestTableViewCell.moreRests = stores[indexPath.row]

                guard let imageURL = URL(string: stores[indexPath.row].mainImage) else {
                    return moreRestTableViewCell
                }

                ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { [weak moreRestTableViewCell] (downloadImage, error) in
                    if error != nil {
                        return
                    }

                    guard moreRestTableViewCell?.moreRests?.mainImage == imageURL.absoluteString else {
                        return
                    }

                    moreRestTableViewCell?.mainImage.image = downloadImage
                }
            }
        }

        if let foods = self.foods {
            if foods.count > indexPath.row {
                moreRestTableViewCell.moreFoods = foods[indexPath.row]

                guard let imageURL = URL(string: foods[indexPath.row].foodImageURL) else {
                    return moreRestTableViewCell
                }

                ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { [weak moreRestTableViewCell] (downloadImage, error) in
                    if error != nil {
                        return
                    }

                    guard moreRestTableViewCell?.moreFoods?.foodImageURL == imageURL.absoluteString else {
                        return
                    }

                    moreRestTableViewCell?.mainImage.image = downloadImage
                }
            }
        }

        return moreRestTableViewCell
    }
}

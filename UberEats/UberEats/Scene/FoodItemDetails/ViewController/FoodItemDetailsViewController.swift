//
//  FoodItemDetailsViewController.swift
//  UberEats
//
//  Created by 장공의 on 27/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import DependencyContainer
import ServiceInterface

class FoodItemDetailsViewController: UIViewController {

    @IBOutlet weak var toolbar: UIView!

    @IBOutlet weak var coverToolBar: UIView!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var stretchableHeaderHeight: NSLayoutConstraint!

    @IBOutlet weak var coveredToolBarBottom: NSLayoutConstraint!

    @IBOutlet weak var orderButton: UIButton!

    private var style: UIStatusBarStyle = .lightContent

    fileprivate var foodOptionItemModels = [[FoodOptionItemModelType]](repeating: [],
                                                              count: FoodOptionSection.allCases.count)

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        self.coveredToolBarBottom.constant = -toolbar.frame.height

        tableView.contentInset = UIEdgeInsets(top: FoodDetailDimensions.stretchableHeaderImageHeight,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)

        tableView.rowHeight = UITableView.automaticDimension
        orderButton.layer.cornerRadius = FoodDetailDimensions.orderButtonCornerRadius
    }

    @IBAction func clickedBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickedCartButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
        let cartViewController = storyboard.instantiateViewController(withIdentifier: "CartVC") as! CartViewController
        self.navigationController?.pushViewController(cartViewController, animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }

}

extension FoodItemDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let foodOptionSection = FoodOptionSection(rawValue: section) ?? .empty
        return foodOptionItemModels[foodOptionSection.rawValue].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let model = foodOptionItemModels[indexPath.section][indexPath.row]

        switch model {
        case .requiredOptions(let requiredOptionsModel):
            break
        case .additionalOptions(let additionalOptionModel):
            break
        case .specialRequests(let specialRequestsModel):
            break
        case .checkBox(let checkBoxModel):
            break
        case .radioButton(let radioButtonModel):
            break
        default:
            return .init()
        }

        return .init()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return FoodOptionSection.allCases.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

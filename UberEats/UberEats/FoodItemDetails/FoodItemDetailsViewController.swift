//
//  FoodItemDetailsViewController.swift
//  UberEats
//
//  Created by 장공의 on 27/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class FoodItemDetailsViewController: UIViewController {
    
    @IBOutlet weak var toolbar: UIView!

    @IBOutlet weak var coverToolBar: UIView!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var stretchableHeaderHeight: NSLayoutConstraint!

    @IBOutlet weak var coveredToolBarBottom: NSLayoutConstraint!

    @IBOutlet weak var orderButton: UIButton!

    private static let cellIdebtifier = "foodItemDetailsCell"

    private static let stretchableHeaderImageHeight: CGFloat = 170

    private static let orderButtonCornerRadius: CGFloat = 4

    private static let coveredToolbarAnimationInterval = 500
    
    private lazy var stretchableHeaderMinumumHeight = {
        return self.toolbar.frame.height
    }

    private lazy var stretchableHeaderMaximumHeight = {
        return self.view.frame.height
    }

    private var style: UIStatusBarStyle = .lightContent

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
 
    private func initView() {
        self.coveredToolBarBottom.constant = -toolbar.frame.height
        tableView.contentInset = UIEdgeInsets(top: FoodItemDetailsViewController.stretchableHeaderImageHeight, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        orderButton.layer.cornerRadius = FoodItemDetailsViewController.orderButtonCornerRadius
    }
    
    @IBAction func clickedBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let stretchableHeaderY = -scrollView.contentOffset.y

        let height = min(max(stretchableHeaderY, stretchableHeaderMinumumHeight()), stretchableHeaderMaximumHeight())
        stretchableHeaderHeight.constant = height
        changeStatusWithCoveredToolbar(height)
    }

    private func changeStatusWithCoveredToolbar(_ stretchableHeaderHeight: CGFloat) {

        func coveredToolBarStatus() -> CoveredToolBarStatus {
            if stretchableHeaderHeight <= stretchableHeaderMinumumHeight() {
                return .covered
            }
            return .uncovered
        }

        func coveredToolBarHeight(status: CoveredToolBarStatus) -> CGFloat {
            return coveredToolBarStatus() == .uncovered ? -self.toolbar.frame.height : 0
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.coveredToolBarBottom.constant = coveredToolBarHeight(status: coveredToolBarStatus())
            self.setNeedsStatusBarAppearanceUpdate()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }
}

private class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let gradientLayer = layer as? CAGradientLayer else { return }

        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.55).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor
        ]
    }
}

extension FoodItemDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FoodItemDetailsViewController.cellIdebtifier,
            for: indexPath) as? FoodItemDetailsCell else {
                return .init()
        }

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

private enum CoveredToolBarStatus {
    case covered
    case uncovered
}

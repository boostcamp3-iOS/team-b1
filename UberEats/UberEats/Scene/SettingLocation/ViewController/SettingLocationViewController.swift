//
//  SettingLocationViewController.swift
//  UberEats
//
//  Created by 이혜주 on 14/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class SettingLocationViewController: UIViewController {

    private let HeightOfcompleteButton: CGFloat = 50
    private let nubmerOfSections: Int = 3
    private let tapGesture = UITapGestureRecognizer()

    struct HeaderHeight {
        static let moment: CGFloat = 40
        static let basic: CGFloat = 8
    }

    struct NumberOfRows {
        static let newAddress: Int = 1
        static let basic: Int = 2
    }

    let locationInfo: [LocationCellModel] = [LocationCellModel("icCurrentlocation",
                                          "현재 위치",
                                          "대한민국 서울특별시 강남구 역삼1동 825-11",
                                          "문 앞까지 배달"),
                        LocationCellModel("icClock",
                                          "메리츠 타워",
                                          "대한민국 서울특별시 강남구 역삼동 강남대로 382",
                                          "차량에서 대기")]

    let moment: [MomentCellModel] = [.init(imageName: "icStopwatch", title: "최대한 빨리"),
                                         .init(imageName: "icReservation", title: "주문 예약")]

    let deliveryDetailTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = #colorLiteral(red: 0.9489392638, green: 0.9490228295, blue: 0.9532163739, alpha: 1)
        tableView.tableFooterView = UIView()
        return tableView
    }()

    let completeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.368627451, green: 0.6274509804, blue: 0.2274509804, alpha: 1)
        button.setTitle("완료", for: .normal)
        button.isHidden = true
        return button
    }()

    let toolBarView = ToolBarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        toolBarView.delegate = self
        tapGesture.delegate = self
        setupLayout()
        setupTableView()
    }

    private func setupTableView() {
        deliveryDetailTableView.dataSource = self
        deliveryDetailTableView.delegate = self

        //cells
        deliveryDetailTableView.register(NewAddressTableViewCell.self, forCellReuseIdentifier: SettingLocationCellId.newAddress.rawValue)
        deliveryDetailTableView.register(LocationTableViewCell.self, forCellReuseIdentifier: SettingLocationCellId.location.rawValue)
        deliveryDetailTableView.register(MomentTableViewCell.self, forCellReuseIdentifier: SettingLocationCellId.moment.rawValue)
    }

    private func setupLayout() {
        self.view.backgroundColor = .white

        self.view.addSubview(deliveryDetailTableView)
        self.view.addSubview(completeButton)
        self.view.addSubview(toolBarView)
        self.view.addGestureRecognizer(tapGesture)

        completeButton.addTarget(self, action: #selector(touchUpCompleteButton(_:)), for: .touchUpInside)

        NSLayoutConstraint.activate([
            deliveryDetailTableView.topAnchor.constraint(equalTo: toolBarView.bottomAnchor),
            deliveryDetailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            deliveryDetailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deliveryDetailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            completeButton.heightAnchor.constraint(equalToConstant: HeightOfcompleteButton),

            toolBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toolBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }

    @objc private func touchUpCompleteButton(_: UIButton) {

    }
}

extension SettingLocationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        view.endEditing(true)
        return false
    }
}

extension SettingLocationViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return nubmerOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SectionOfSettingLocation(rawValue: section) else {
            return .init()
        }

        switch section {
        case .newAddress:
            return NumberOfRows.newAddress
        default:
            return NumberOfRows.basic
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = SectionOfSettingLocation(rawValue: section) else {
            return .init()
        }

        switch section {
        case .moment:
            return MomentHeaderView()
        default:
            return .init()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionOfSettingLocation(rawValue: indexPath.section) else {
            return .init()
        }

        switch section {
        case .newAddress:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingLocationCellId.newAddress.rawValue, for: indexPath)
            return cell
        case .location:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingLocationCellId.location.rawValue, for: indexPath) as? LocationTableViewCell else {
            return .init()
            }

            cell.locationInfo = locationInfo[indexPath.row]

            return cell
        case .moment:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingLocationCellId.moment.rawValue, for: indexPath) as? MomentTableViewCell else {
                return .init()
            }

            cell.moment = moment[indexPath.row]

            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SectionOfSettingLocation.location.rawValue {
            let anotherRow = (indexPath.row == 0 ? 1 : 0)
            let anotherIndex = IndexPath(row: anotherRow, section: 1)

            guard let anotherCell = tableView.cellForRow(at: anotherIndex) as? LocationTableViewCell,
            let cell = tableView.cellForRow(at: indexPath) as? LocationTableViewCell else {
                return
            }

            if cell.selectStatusImageView.isHidden {
                cell.selectStatusImageView.isHidden = false
            }

            if !cell.selectStatusImageView.isHidden && !anotherCell.selectStatusImageView.isHidden {
                anotherCell.selectStatusImageView.isHidden = anotherCell.selectStatusImageView.isHidden ? false : true
            }

            completeButton.isHidden = false
        }
    }
}

extension SettingLocationViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = SectionOfSettingLocation(rawValue: section) else {
            return .init()
        }

        switch section {
        case .moment:
            return HeaderHeight.moment
        default:
            return HeaderHeight.basic
        }
    }

}

extension SettingLocationViewController: CloseDelegate {

    func dismissModal() {
        dismiss(animated: true, completion: nil)
    }

}

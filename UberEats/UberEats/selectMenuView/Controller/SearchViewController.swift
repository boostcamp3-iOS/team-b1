//
//  SearchViewController.swift
//  UberEats
//
//  Created by 이혜주 on 25/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    private func setupLayout() {
        searchTextField.becomeFirstResponder()
    }

}

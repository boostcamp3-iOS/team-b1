//
//  QuantityControlVIew.swift
//  UberEats
//
//  Created by 장공의 on 21/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class QuantityControlView: UIView, QuantityValueChanged {

    private static let xibName = "QuantityControlView"

    @IBOutlet var quantityControlContantVIew: UIView!

    @IBOutlet weak var quantityLabel: UILabel!

    private var quantity = Quantity()

    weak var quantitychanged: QuantityValueChanged? {
        didSet {
            quantitychanged?.quantityValueChanged(newQuantity: quantity.value)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initNib()
    }

    @IBAction func onClickedMinusButton(_ sender: Any) {
        quantity.minus()
    }

    @IBAction func onClickedPlusButton(_ sender: Any) {
        quantity.plus()
    }

    func quantityValueChanged(newQuantity: Int) {
        quantitychanged?.quantityValueChanged(newQuantity: newQuantity)
        quantityLabel?.text = "\(newQuantity)"
    }

    private func initNib() {
        Bundle.main.loadNibNamed(QuantityControlView.xibName, owner: self, options: nil)
        quantityControlContantVIew.fixInView(self)
        quantity.quantitychanged = self
    }

}

private class Quantity {

    private static let maximum = 99
    private static let minimum = 1
    private (set) var value = Quantity.minimum

    weak var quantitychanged: QuantityValueChanged?

    func plus() {
        guard value <= Quantity.maximum else {
            return
        }

        value += 1
        quantitychanged?.quantityValueChanged(newQuantity: value)
    }

    func minus() {
        guard value > Quantity.minimum else {
            return
        }

        value -= 1
        quantitychanged?.quantityValueChanged(newQuantity: value)
    }

}

protocol QuantityValueChanged: class {
    func quantityValueChanged(newQuantity: Int)
}

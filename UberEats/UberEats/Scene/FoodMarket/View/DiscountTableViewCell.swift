import UIKit

class DiscountTableViewCell: UITableViewCell {

    public let discountLabel: UILabel = {
        let label = UILabel()
        label.text = "주문 시 ₩5,000 할인받기"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public let discountImageView = UIImageView().initImageView("discountImage")

    init(_ section: TableViewSection) {
        switch section {
        case .moreRest:
            self.discountLabel.text = "레스토랑 더보기"
        case .discount:
            self.discountLabel.text = "주문 시 ₩5,000 할인받기"
        default:
            break
        }
        super.init(style: .default, reuseIdentifier: nil)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(discountLabel)
        addSubview(discountImageView)

        NSLayoutConstraint.activate([
            discountImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            discountImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            discountImageView.heightAnchor.constraint(equalToConstant: 60),
            discountImageView.widthAnchor.constraint(equalToConstant: 50),

            discountLabel.leadingAnchor.constraint(equalTo: discountImageView.trailingAnchor, constant: 15),
            discountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            discountLabel.widthAnchor.constraint(equalToConstant: 200),
            discountLabel.heightAnchor.constraint(equalToConstant: 30)
            ])

        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

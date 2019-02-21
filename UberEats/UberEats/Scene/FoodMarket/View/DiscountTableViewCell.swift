import UIKit

class DiscountTableViewCell: UITableViewCell {

    public let discountLabel: UILabel = {
        let label = UILabel()
        label.text = "주문 시 ₩5,000 할인받기"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public let discountImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "discountImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

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

        discountImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        discountImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        discountImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        discountImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true

        discountLabel.leadingAnchor.constraint(equalTo: discountImageView.trailingAnchor, constant: 15).isActive = true
        discountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        discountLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        discountLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

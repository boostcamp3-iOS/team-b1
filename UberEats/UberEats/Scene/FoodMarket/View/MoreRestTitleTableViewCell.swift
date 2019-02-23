import UIKit

class MoreRestTitleTableViewCell: UITableViewCell {

    public let discountLabel: UILabel = {
        let label = UILabel()
        label.text = "레스토랑 더보기"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(discountLabel)

        NSLayoutConstraint.activate([
            discountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            discountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            discountLabel.widthAnchor.constraint(equalToConstant: 200),
            discountLabel.heightAnchor.constraint(equalToConstant: 30)
            ])

        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

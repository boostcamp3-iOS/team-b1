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

        discountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        discountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        discountLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        discountLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

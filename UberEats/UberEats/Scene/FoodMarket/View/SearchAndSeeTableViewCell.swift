import UIKit

class SearchAndSeeTableViewCell: UITableViewCell {

    public let discountLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 및 보기"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public let discountImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "discountImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

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

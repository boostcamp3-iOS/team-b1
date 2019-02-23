import UIKit

class ChatMesageCell: UICollectionViewCell {

    let messageLabel: UILabel = {
        let label = UILabel().setupWithFontSize(16)
        label.numberOfLines = 0
        return label
    }()

    let chatBubbleView: UIView = {
        let chatBubbleView = UIView()
        chatBubbleView.layer.cornerRadius = 10
        chatBubbleView.layer.masksToBounds = true
        chatBubbleView.translatesAutoresizingMaskIntoConstraints = false
        return chatBubbleView
    }()

    let isReadLabel: UILabel = {
        let isRead = UILabel()
        isRead.translatesAutoresizingMaskIntoConstraints = false
        return isRead
    }()

    var bubbleViewWidhAnchor: NSLayoutConstraint?
    var bubbleViewTrailingAnchor: NSLayoutConstraint?
    var bubbleViewLeadingAnchor: NSLayoutConstraint?
    var bubbleViewHeightAnchor: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(chatBubbleView)
        addSubview(messageLabel)

        bubbleViewWidhAnchor = chatBubbleView.widthAnchor.constraint(equalToConstant: 300)
        bubbleViewLeadingAnchor = chatBubbleView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                                          constant: 3)
        bubbleViewTrailingAnchor = chatBubbleView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                                            constant: -10)
        bubbleViewHeightAnchor = chatBubbleView.heightAnchor.constraint(equalToConstant: 1000)

        bubbleViewWidhAnchor?.isActive = true
        bubbleViewLeadingAnchor?.isActive = true
        bubbleViewTrailingAnchor?.isActive = true
        bubbleViewHeightAnchor?.isActive = true

        NSLayoutConstraint.activate([
            chatBubbleView.topAnchor.constraint(equalTo: topAnchor),
            chatBubbleView.heightAnchor.constraint(equalTo: heightAnchor),

            messageLabel.leadingAnchor.constraint(equalTo: chatBubbleView.leadingAnchor,
                                                  constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: chatBubbleView.trailingAnchor,
                                                   constant: -8),
            messageLabel.topAnchor.constraint(equalTo: chatBubbleView.topAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: chatBubbleView.bottomAnchor)
            ])

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func fromEmail(userEmail: String) {
        if userEmail == "user@gmail.com" {
            messageLabel.backgroundColor = UIColor(displayP3Red: 10 / 255,
                                                    green: 128 / 255,
                                                    blue: 2 / 255,
                                                    alpha: 1.0)
            messageLabel.textColor = .white

            chatBubbleView.backgroundColor = UIColor(displayP3Red: 10 / 255,
                                                     green: 128 / 255,
                                                     blue: 2 / 255,
                                                     alpha: 1.0)

            chatBubbleView.layer.maskedCorners = [.layerMaxXMinYCorner,
                                                  .layerMinXMaxYCorner,
                                                  .layerMinXMinYCorner]

            bubbleViewLeadingAnchor?.isActive = false
            bubbleViewTrailingAnchor?.isActive = true
        } else {
            messageLabel.backgroundColor = .blue
            messageLabel.textColor = .white
            chatBubbleView.backgroundColor = .blue
            chatBubbleView.layer.maskedCorners = [.layerMaxXMinYCorner,
                                                  .layerMaxXMaxYCorner,
                                                  .layerMinXMaxYCorner]

            bubbleViewLeadingAnchor?.isActive = true
            bubbleViewTrailingAnchor?.isActive = false
        }
    }
}

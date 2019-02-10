import UIKit

class ChatMesageCell: UICollectionViewCell {

    let textFieldView: UITextView = {
        let textView = UITextView()
        textView.text = "Sample Text"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(chatBubbleView)
        addSubview(textFieldView)

        chatBubbleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        chatBubbleView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        bubbleViewWidhAnchor = chatBubbleView.widthAnchor.constraint(equalToConstant: 300)
        bubbleViewLeadingAnchor = chatBubbleView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                                          constant: 3)
        bubbleViewTrailingAnchor = chatBubbleView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                                            constant: -10)

        bubbleViewWidhAnchor?.isActive = true
        bubbleViewLeadingAnchor?.isActive = true

        textFieldView.leadingAnchor.constraint(equalTo: chatBubbleView.leadingAnchor,
                                               constant: 10).isActive = true
        textFieldView.trailingAnchor.constraint(equalTo: chatBubbleView.trailingAnchor,
                                                constant: -8).isActive = true
        textFieldView.topAnchor.constraint(equalTo: chatBubbleView.topAnchor).isActive = true
        textFieldView.bottomAnchor.constraint(equalTo: chatBubbleView.bottomAnchor).isActive = true

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func fromEmail(userEmail: String) {
        if userEmail == "user@gmail.com" {
            textFieldView.backgroundColor = UIColor(displayP3Red: 10 / 255,
                                                    green: 128 / 255,
                                                    blue: 2 / 255,
                                                    alpha: 1.0)
            textFieldView.textColor = .white

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
            textFieldView.backgroundColor = .blue
            textFieldView.textColor = .white
            chatBubbleView.backgroundColor = .blue
            chatBubbleView.layer.maskedCorners = [.layerMaxXMinYCorner,
                                                  .layerMaxXMaxYCorner,
                                                  .layerMinXMaxYCorner]

            bubbleViewLeadingAnchor?.isActive = true
            bubbleViewTrailingAnchor?.isActive = false
        }
    }
}

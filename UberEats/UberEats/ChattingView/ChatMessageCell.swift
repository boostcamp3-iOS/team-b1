import UIKit

internal class ChatMesageCell: UICollectionViewCell {
    
    let textFieldView: UITextView = {
        let textView = UITextView()
        textView.text = "Sample Text"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let chatBubbleView: UIView = {
        let bubbleView = UIView()
        bubbleView.backgroundColor = UIColor(red: 0.10, green: 0.60, blue: 0.91, alpha: 1.0)
        bubbleView.layer.cornerRadius = 10
        bubbleView.layer.masksToBounds = true
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        return bubbleView
    }()
    
    let isReadLabel: UILabel = {
        let isRead = UILabel()
        isRead.translatesAutoresizingMaskIntoConstraints = false
        return isRead
    }()
    
    private var bubbleViewWidhAnchor: NSLayoutConstraint?
    private var bubbleViewRightAnchor: NSLayoutConstraint?
    private var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(chatBubbleView)
        addSubview(textFieldView)
        addSubview(isReadLabel)
        
        NSLayoutConstraint.activate([
            chatBubbleView.topAnchor.constraint(equalTo: topAnchor),
            chatBubbleView.heightAnchor.constraint(equalTo: heightAnchor),
            bubbleViewRightAnchor = chatBubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -3)
            
            
            ])
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

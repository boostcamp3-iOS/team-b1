//
//  ChattingViewController.swift
//  UberEats
//
//  Created by admin on 31/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//
import UIKit
import Firebase

class ChattingViewController: UIViewController {
    @IBOutlet private weak var deliveryInfoVIew: UIView!
    @IBOutlet private weak var chattingCollecionView: UICollectionView!

    @IBOutlet weak var messageTextField: UITextView!

    @IBOutlet weak var chatMessageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatMessageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatMessageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatMessageTrailingConstraint: NSLayoutConstraint!

    @IBOutlet weak var sendButton: UIButton!

    private let chatMessageCellId = "chatMessageCellId"

    var deliveryInfo: (Email: String, phone: String, name: String, transPort: String)? {
        didSet {

        }
    }

    private var messages: [Message] = []

    private lazy var defaultTextFieldOriginY: CGFloat = {
       return self.messageTextField.frame.origin.y
    }()

    @IBAction func moveToParentVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    private var keyboardAppearState: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardAppearState = false

        observeMessages()

        setupChattingCollectionView()

        addNotificationObserver()

        sendButton.isHidden = true

        messageTextField.delegate = self
        messageTextField.dropShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: 1, height: -1), radius: 5.0, scale: true)
        messageTextField.returnKeyType = .send
    }

    public func textViewDidChange(_ textView: UITextView) {
        if textView.text.last == "\n" { //Check if last char is newline
            textView.text.removeLast()
            sendMessaage()
        }
    }

    private func observeMessages() {
        let messageFromGroup = Database.database().reference().child("groups").child("-LXbWKQsskziJ50aw8qN")

        messageFromGroup.observe(.childAdded) { [weak self] (snapshot) in
            let messageRef = Database.database().reference().child("message").child(snapshot.key)
            messageRef.observe(.value, with: { (messageSnapshot) in
                if let dictionary = messageSnapshot.value as? [String: Any] {

                    guard let text = dictionary["text"] as? String else {
                        return
                    }

                    guard let userEmail = dictionary["userEmail"] as? String else {
                        return
                    }

                    //guard let timestamp = dictionary["timestamp"] as? String else {return}
                    let messageInstance = Message(text: text, userEmail: userEmail)
                    self?.messages.append(messageInstance)
                    self?.chattingCollecionView.reloadData()

                    self?.scrollToBottom()

                    guard let keyboardAppear = self?.keyboardAppearState else {
                        return
                    }

                    if keyboardAppear {
                        self?.chattingCollecionView.contentInset = UIEdgeInsets(top: 8, left: 10, bottom: UIDevice.current.keyboardAppearBottomEdgeInset, right: 10)
                    } else {
                        self?.chattingCollecionView.contentInset = UIEdgeInsets(top: 8, left: 10, bottom: 75, right: 10)
                    }
                }
            })
        }
    }

    @IBAction func callAction(_ sender: Any) {
        if let phoneCallURL = URL(string: "tel://\(+82-10-2031-3421)") {
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)

//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
//                                               name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    private func setupChattingCollectionView() {
        chattingCollecionView.delegate = self
        chattingCollecionView.dataSource = self

        chattingCollecionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardHide)))

        chattingCollecionView.register(ChatMesageCell.self, forCellWithReuseIdentifier: chatMessageCellId)

        chattingCollecionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        chattingCollecionView.alwaysBounceVertical = true
        chattingCollecionView.reloadData()

        let cellSize = CGSize(width: 300, height: 300)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = cellSize

        //chattingCollecionView.contentInset = UIEdgeInsets(top: 8, left: 10, bottom: 110, right: 10)
    }

    func scrollToBottom() {
        DispatchQueue.main.async {
            if self.messages.count > 0 {
                let lastIndex = IndexPath(item: self.messages.count-1, section: 0)

                self.chattingCollecionView.scrollToItem(at: lastIndex, at: .bottom, animated: false)
            }
        }
    }

    private func sendMessaage() {
        let messageRef = FirebaseDataService.instance.messageRef.childByAutoId()

        //let userUID = "9HOhFlNg8jhYLP8sW2cz9ecjABE2"
        //let deliveryUID = "yJI58ZZYyiZVaatNUrIMaBdNsL42"

        let data: Dictionary<String, AnyObject> = [
            "userEmail": "delivery@gmail.com" as AnyObject,
            "text": messageTextField.text as AnyObject,
            "timestamp": NSNumber(value: Date().timeIntervalSince1970)
        ]

        self.messageTextField.text = ""

        messageRef.updateChildValues(data) { (error, ref) in
            guard error == nil else {
                return
            }

            guard let postData: Dictionary<String, AnyObject> = [ref.key: 1] as? [String: AnyObject] else {
                return
            }

            Database.database().reference().child("groups").child("-LXbWKQsskziJ50aw8qN").updateChildValues(postData)
        }
    }

    @IBAction private func sendMessages(_ sender: Any) {
        sendMessaage()
    }

}

// MARK: - UITextViewDelegate
extension ChattingViewController: UITextViewDelegate {

    @objc private func keyboardWillShow(_ notification: NSNotification) {
        keyboardAppearState = true
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {

            UIView.animate(withDuration: 0.9, delay: 0.0, options: .curveEaseIn, animations: {

//                self.chattingCollecionView.setContentOffset(CGPoint(x: 0, y: self.chattingCollecionView.contentSize.height - (self.view.frame.height * 0.135 + 120) ), animated: true)

                if self.chattingCollecionView.contentSize.height > 250 {
                    self.chattingCollecionView.setContentOffset(CGPoint(x: 0,
                                                                        y: self.chattingCollecionView.contentSize.height - keyboardSize.height),
                                                                animated: true)
                }

                self.chattingCollecionView.contentInset = UIEdgeInsets(top: 8, left: 10, bottom: 15, right: 10)

                self.chatMessageTrailingConstraint.constant = 0
                self.chatMessageLeadingConstraint.constant = 0

                self.chatMessageBottomConstraint.constant -= (keyboardSize.height - 8)

                self.view.layoutIfNeeded()

            }, completion: nil)
        }
    }

    @objc private func keyboardHide() {

        keyboardAppearState = false

        self.messageTextField.endEditing(true)

        UIView.animate(withDuration: 0.3, animations: { () -> Void in

            //self.chatMessageTrailingConstraint.constant = 16
            self.chatMessageLeadingConstraint.constant = 16

            self.chatMessageBottomConstraint.constant = -33

            self.chattingCollecionView.contentInset = UIEdgeInsets(top: 8, left: 10, bottom: 89, right: 10)

            self.view.layoutIfNeeded()
        })
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        sendButton.isHidden = false
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        sendButton.isHidden = true
    }

    //FIXME: - 텍스트 뷰 다음줄로 넘어가면서 커지는 부분
    /*
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView.text?.count ?? 0) % 20 == 0 && (textView.text?.count ?? 0) != 0 {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.chatMessageHeightConstraint.constant += 30
                self.view.layoutIfNeeded()
            })
        }
        return true
    }
     */
}

// MARK: - CollectionviewDelegate
extension ChattingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatMessageCellId,
                                                            for: indexPath) as? ChatMesageCell else {
            return .init()
        }

        let message = messages[indexPath.item]

        guard let fromEmail = message.userEmail else {
            return cell
        }

        if let text = messages[indexPath.item].text {
            cell.bubbleViewWidhAnchor?.constant = text.estimateCGRect.width + 32
            cell.bubbleViewHeightAnchor?.constant = text.estimateCGRect.height + 15
        }

        cell.fromEmail(userEmail: fromEmail)

        guard let messageText = message.text else {
            return cell
        }
        cell.messageLabel.text = messageText
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        //get estimated height
        if let text = messages[indexPath.row].text {
            height = text.estimateCGRect.height
        }

        return CGSize(width: view.frame.width, height: height + 15)
    }
}

extension UITextField {

    func applyCustomEffect() {
        self.borderStyle = .none
        self.backgroundColor = UIColor.groupTableViewBackground // Use anycolor that give you a 2d look.

        //To apply corner radius
        self.layer.cornerRadius = self.frame.size.height / 2

        //To apply border
        self.layer.borderWidth = 0.25
        self.layer.borderColor = UIColor.white.cgColor

        //To apply Shadow
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1.0
        self.layer.shadowOffset = CGSize.zero // Use any CGSize
        self.layer.shadowColor =
            UIColor.lightGray.cgColor

        self.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
    }
}

extension UITextView {
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 2
    }
}

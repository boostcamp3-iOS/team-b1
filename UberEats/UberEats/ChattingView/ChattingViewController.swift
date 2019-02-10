//
//  ChattingViewController.swift
//  UberEats
//
//  Created by admin on 31/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//
import UIKit
import Firebase

// swiftlint:disable all
// 채팅방에서 delivertUID를 알고 있고 서로 1대일 채팅 한다는 가정을 하자.
class ChattingViewController: UIViewController {
    @IBOutlet private weak var deliveryInfoVIew: UIView!
    @IBOutlet private weak var chattingCollecionView: UICollectionView!
    @IBOutlet private weak var messageTextField: UITextField!
    
    private let chatMessageCellId = "chatMessageCellId"
    
    private var messages: [Message] = []
    
    private func observeMessages() {
        let messageFromGroup = Database.database().reference().child("groups").child("-LXbWKQsskziJ50aw8qN")
        
        messageFromGroup.observe(.childAdded) { (snapshot) in
            //print(snapshot.key)
            let messageRef = Database.database().reference().child("message").child(snapshot.key)
            messageRef.observe(.value, with: { (messageSnapshot) in
                if let dictionary = messageSnapshot.value as? [String: Any] {
                    
                    guard let text = dictionary["text"] as? String else {return}
                    guard let userEmail = dictionary["userEmail"] as? String else {return}
                    //guard let timestamp = dictionary["timestamp"] as? String else {return}
                    
                    let messageInstance = Message(text: text, userEmail: userEmail)
                    self.messages.append(messageInstance)
                    self.chattingCollecionView.reloadData()
                    
                    
                    self.scrollToBottom()
                    self.chattingCollecionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
                }
            })
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChattingCollectionView()
        setupTextFieldNoti()
        observeMessages()
        
        messageTextField.dropShadow(color: .gray, offSet: CGSize.zero)
    }
    
    @IBAction func callAction(_ sender: Any) {
        if let phoneCallURL = URL(string: "tel://\(+82-10-2031-3421)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func setupTextFieldNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        adjustingHeight(show: true, notification: notification)
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        // 1
        var userInfo = notification.userInfo!
        // 2
        let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        // 3
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 4
        var changeInHeight = (keyboardFrame.height) * (show ? -1 : 1)
        
        if changeInHeight > 0 {
           changeInHeight -= 37
        }
        
        //5
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            //self.bottomConstraint.constant += changeInHeight
            self.view.frame.origin.y += changeInHeight
        })
        
    }
    
    private func setupChattingCollectionView() {
        chattingCollecionView.delegate = self
        chattingCollecionView.dataSource = self
        chattingCollecionView.register(ChatMesageCell.self, forCellWithReuseIdentifier: chatMessageCellId)
        
        chattingCollecionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        chattingCollecionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        chattingCollecionView.alwaysBounceVertical = true
        let indexPathOfMessage = IndexPath(item: self.messages.count - 1, section: 0)
        
        chattingCollecionView.scrollToItem(at: indexPathOfMessage, at: .bottom, animated: true)
        chattingCollecionView.reloadData()
        
        let cellSize = CGSize(width: 300, height: 300)
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = cellSize
        //chattingCollecionView.setCollectionViewLayout(layout, animated: true)
        //self.scrollToBottom()
    }
    
    override func viewDidLayoutSubviews() {
        //self.scrollToBottom()
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let lastIndex = IndexPath(item: self.messages.count-1, section: 0)
            self.chattingCollecionView.scrollToItem(at: lastIndex, at: .bottom, animated: false)
        }
    }
    
    @IBAction private func sendMessages(_ sender: Any) {
        let messageRef = FirebaseDataService.instance.messageRef.childByAutoId()
        
        let userUID = "9HOhFlNg8jhYLP8sW2cz9ecjABE2"
        let deliveryUID = "yJI58ZZYyiZVaatNUrIMaBdNsL42"
        
        let data: Dictionary<String, AnyObject> = [
            "userEmail": "@gmail.com" as AnyObject,
            "text" : messageTextField.text as AnyObject,
            "timestamp": NSNumber(value: Date().timeIntervalSince1970)
        ]
        
        messageRef.updateChildValues(data) { (error, ref) in 
            guard error == nil else {
                print(error as Any)
                return
            }
            guard let postData: Dictionary<String, AnyObject> = [ref.key:1] as? [String : AnyObject] else {return}
            Database.database().reference().child("groups").child("-LXbWKQsskziJ50aw8qN").updateChildValues(postData)
        }
    }
    @IBAction private func loginAction(_ sender: Any) {
        
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size,
                                                   options: option,
                                                   attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)],
                                                   context: nil)
    }
}

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
        guard let fromEmail = message.userEmail else {return .init()}
        
        if let text = messages[indexPath.item].text {
            cell.textFieldView.text = text
            cell.bubbleViewWidhAnchor?.constant = estimateFrameForText(text: text).width + 32
        }
        cell.fromEmail(userEmail: fromEmail)
        cell.textFieldView.text = message.text!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        //get estimated height
        if let text = messages[indexPath.row].text {
            height = estimateFrameForText(text: text).height
        }
        return CGSize(width: view.frame.width, height: height + 15)
    }
}

extension UITextField {
    //뷰 라운드 처리 설정
    func makeRounded(cornerRadius : CGFloat?){
        if let cornerRad = cornerRadius {
            self.layer.cornerRadius = cornerRad
        } else {
            self.layer.cornerRadius = self.layer.frame.height/2
        }
        self.layer.masksToBounds = true
    }
    
    //뷰 그림자 설정
    //color: 색상, opacity: 그림자 투명도, offset: 그림자 위치, radius: 그림자 크기
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        
        layer.cornerRadius = 10.0
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offSet
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowPath = nil
        layer.shouldRasterize = true

//
//        layer.masksToBounds = false
//        layer.shadowColor = color.cgColor
//        layer.shadowOpacity = opacity
//        layer.shadowOffset = offSet
//        layer.shadowRadius = radius
//        layer.cornerRadius = 10.0
//
//        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        layer.shouldRasterize = true
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow2(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -0.0, height: -3.0)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        
        //layer.rasterizationScale = scale ? UIScreen.main.scale : 1
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

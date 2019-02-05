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
    
    @IBOutlet private var deliveryInfoVIew: UIView!
    @IBOutlet weak var chattingCollecionView: UICollectionView!
    @IBOutlet private var messageTextField: UITextField!
    
    private let chatMessageCellId = "chatMessageCellId"
    
    var messages: [Message] = [
//        Message(text: "안녕하세요", userEmail: "user@gmail.com"),
//        Message(text: "안녕하세요1asdgasdgasddgasdgasddgasdgasdgasdgasdgasdgasdgasdgasdgasdgasdgasdgasdgasdgsagasdgasdgasdgadsgasdgasdgasdgasdgasdgasdgasdg", userEmail: "user@gmail.com"),
//        Message(text: "안녕하세요2", userEmail: "user@gmail.com"),
//        Message(text: "안녕하세요3", userEmail: "user@gmail.com"),
//        Message(text: "안녕하세요4", userEmail: "delivery@gmail.com"),
//        Message(text: "안녕하세요5", userEmail: "delivery@gmail.com"),
//        Message(text: "안녕하세요6", userEmail: "delivery@gmail.com"),
//        Message(text: "안녕하세요7", userEmail: "delivery@gmail.com"),
    ]
    
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
                    
//                    print(messageSnapshot)
                    
                    self.scrollToBottom()
                    self.chattingCollecionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
                }
            })

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChattingCollectionView()
        observeMessages()
        
    }
    
    private func setupChattingCollectionView(){
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
            "userEmail": "user@gmail.com" as AnyObject,
            "text" : messageTextField.text as AnyObject,
            "timestamp": NSNumber(value: Date().timeIntervalSince1970)
        ]
        
        messageRef.updateChildValues(data) { (error, ref) in //
            guard error == nil else {
                print(error as Any)
                return
            }
            guard let postData: Dictionary<String, AnyObject> = [ref.key:1] as? [String: AnyObject] else {return}
            Database.database().reference().child("groups").child("-LXbWKQsskziJ50aw8qN").updateChildValues(postData)
        }
        

    }
    
    @IBAction private func loginAction(_ sender: Any) {
        
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
//    private func identifyUserDelivery(cell: ChatMesageCell, message: Message) {
//        
//    }
    
}

extension ChattingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatMessageCellId, for: indexPath) as? ChatMesageCell else {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        //get estimated height
        if let text = messages[indexPath.row].text {
            height = estimateFrameForText(text: text).height
        }
        return CGSize(width: view.frame.width, height: height+15)
    }
}







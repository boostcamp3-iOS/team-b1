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
    @IBOutlet private var chattingCollecionView: UICollectionView!
    @IBOutlet private var messageTextField: UITextField!
    
    private static let chatMessageCellId = "chatMessageCellId"
    
    var messages: [Message] = [
        Message(text: "안녕하세요", userEmail: "user@gmail.com"),
        Message(text: "안녕하세요1", userEmail: "user@gmail.com"),
        Message(text: "안녕하세요2", userEmail: "user@gmail.com"),
        Message(text: "안녕하세요3", userEmail: "user@gmail.com"),
        Message(text: "안녕하세요4", userEmail: "delivery@gmail.com"),
        Message(text: "안녕하세요5", userEmail: "delivery@gmail.com"),
        Message(text: "안녕하세요6", userEmail: "delivery@gmail.com"),
        Message(text: "안녕하세요7", userEmail: "delivery@gmail.com"),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChattingCollectionView()
    }
    
    private func setupChattingCollectionView(){
        
        chattingCollecionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        chattingCollecionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        chattingCollecionView.delegate = self
        chattingCollecionView.dataSource = self
        chattingCollecionView.register(ChatMesageCell.self, forCellWithReuseIdentifier: ChattingViewController.chatMessageCellId)
        
        let indexPathOfMessage = IndexPath(item: self.messages.count - 2, section: 0)
       // chattingCollecionView.scrollToItem(at: indexPathOfMessage, at: .bottom, animated: true)
        
        chattingCollecionView.reloadData()
        chattingCollecionView.alwaysBounceVertical = true
        
        let cellSize = CGSize(width: 300, height: 500)
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = cellSize
        chattingCollecionView.setCollectionViewLayout(layout, animated: true)
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
}

extension ChattingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingViewController.chatMessageCellId, for: indexPath) as? ChatMesageCell else {
            return .init()
        }
        
        
        let message = messages[indexPath.item]
        
        cell.textFieldView.text = message.text
        print(cell.textFieldView.text)
        
        
        return cell
    }
}






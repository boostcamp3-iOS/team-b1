//
//  ChatModel.swift
//  FirebaseAuth
//
//  Created by admin on 01/02/2019.
//

// swiftlint:disable all
import Foundation

//말풍선 하나
struct ChatMessage {
    var fromUserId: String
    var text: String
    var timestamp: NSNumber
}

//채팅방
struct Group {
    var key: String
    var name: String
    var messages: Dictionary<String, Int>
    
    init(key: String, name: String) {
        self.key = key
        self.name = name
        self.messages = [:]
    }
    
    init(key:String, data: Dictionary<String, AnyObject>){
        self.key = key
        self.name = data["messages"] as! String
        
        if let messages = data["messages"] as? Dictionary<String, Int> {
            self.messages = messages
        }else {
            self.messages = [:]
        }
    }
}

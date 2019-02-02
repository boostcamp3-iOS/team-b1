//
//  FirebaseSingleton.swift
//  UberEats
//
//  Created by admin on 01/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import Firebase

//모든 데이터의 루트 (ubereats-ada19) 를 의미
fileprivate let baseRef = Database.database().reference()

class FirebaseDataService {
    static let instance = FirebaseDataService()
    
    //특정 데이터들이 저장되는 장소에 대한 레퍼런스
    //user :특정 사용자
    
    let userRef = baseRef.child("user")
    
    let groupRef = baseRef.child("groups")
    
    let messageRef = baseRef.child("message")
    
    //현재 접속중인 유저의 uid
    var currentUserUID: String? {
        get {
            guard let uid = Auth.auth().currentUser?.uid else {
                return nil
            }
            return uid
        }
    }
    
    //신규 유저 만들기
    func createUserInfoFromAuth(uid: String , userData: Dictionary<String, String> ) {
        userRef.child(uid).updateChildValues(userData)
    }
    
    //사용자 로그인 하기
    func singIn(email withEmail: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password) { (user, error) in
            guard error == nil else {
                print("Error Occurred during Sign In")
                return
            }
            completion()
        }
    }
}

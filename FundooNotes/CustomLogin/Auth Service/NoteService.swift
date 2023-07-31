//
//  NoteService.swift
//  CustomLogin
//
//  Created by YE002 on 11/07/23.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class NoteService {
    
    var isLoadingNotes = false
    
    static func fetchData(isDeleted: Bool, hasReminder: Bool, completion: @escaping ([Note]) -> Void ) {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).collection("notes").whereField("isDeleted", isEqualTo: isDeleted).whereField("hasReminder", isEqualTo: hasReminder).getDocuments { querySnapshot, error in
            if error != nil{
                completion([])
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion([])
                return
            }
            let notes = documents.map({ queryDocumentSnapshot -> Note  in
                let data = queryDocumentSnapshot.data()
                let uid = data["id"] as? String ?? ""
                let note = data["description"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let isDeleted = data["isDeleted"] as? Bool ?? false
                
                return Note(uId: uid, title: title, description: note, isDeleted: isDeleted)
                
            })
            completion(notes)
        }
    }
    
    static func fetchUserProfile(completion: @escaping (User?) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).getDocument { snapshot, error in
            if error != nil{
                completion(nil)
                return
            }
            
            guard let data = snapshot?.data() else { return }
           
            let firstName = data["firstname"] as? String ?? ""
            let lastName = data["lastname"] as? String ?? ""
            
            completion(User(firstName: firstName, lastName: lastName))
        }
    }
    
}



//var isPaginating = false
//
//func fetchData(pagination: Bool = false, completion: @escaping (Result<[String], Error>) -> Void) {
//    if pagination {
//        isPaginating = true
//    }
//    DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 3 : 2), execute: {
//        let originalData = [
//            "Apple",
//            "Google",
//            "Facebook",
//            "Apple",
//            "Google",
//            "Facebook",
//            "Apple",
//            "Google",
//            "Facebook",
//            "Apple",
//            "Google",
//            "Facebook",
//            "Apple",
//            "Google",
//            "Facebook",
//            "Apple",
//            "Google",
//            "Facebook",
//            "Apple",
//            "Google",
//            "Facebook",
//            "Apple",
//            "Google",
//            "Facebook",
//            "Apple",
//            "Google",
//            "Facebook"
//        ]
//
//        let newData = [
//            "banana", "oranges", "grapes", "food"
//        ]
//        completion(.success(pagination ? newData : originalData ))
//        if pagination {
//            self.isPaginating = false
//        }
//    })
//}

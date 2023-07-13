//
//  UserManager.swift
//  itinerary
//
//  Created by yuchenbo on 5/7/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct DBUser: Codable {
    let userId: String
    let email : String?
    let photoUrl : String?
    let dateCreated : Date?
    
    init(userId: String, email: String?, photoUrl: String?, dateCreated: Date?) {
        self.userId = userId
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
    }
    
    
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
    }
    
    
}




final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    } ()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    } ()
    
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
    }
    
    
    
//    func createNewUser(auth: AuthDataResultModel) async throws {
//
//        var userData: [String:Any] = [
//            "user_id" : auth.uid,
//            "date_created" : Timestamp(),
//        ]
//        if let email = auth.email {
//            userData["email"] = auth.email
//        }
//        if let photoUrl = auth.photoUrl {
//            userData["photoUrl"] = auth.photoUrl
//        }
//
//        try await userDocument(userId: auth.uid).setData(userData, merge: false)
//
//    }

    
    func getUser(userId: String) async throws -> DBUser {
        
         try await userDocument(userId: userId).getDocument(as: DBUser.self, decoder: decoder)
   
    }
    
    
    
//    func getUser(userId: String) async throws -> DBUser {
//        let snapshot = try await userDocument(userId: userId).getDocument()
//        
//        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
//            throw URLError(.badServerResponse)
//        }
//        
//        
//        let email = data["email"] as? String
//        let photoUrl = data["photoUrl"] as? String
//        let dateCreated = data["date_created"] as? Date
//        
//        return DBUser(userId: userId, email: email, photoUrl: photoUrl, dateCreated: dateCreated)
//    }
    
}

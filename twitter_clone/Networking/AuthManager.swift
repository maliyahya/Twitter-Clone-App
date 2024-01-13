//
//  AuthManager.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 8.01.2024.
//

import Foundation
import Firebase
import FirebaseAuthCombineSwift
import Combine

class AuthManager {
    static let shared = AuthManager()
    func registerUser(with email: String, password: String) -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    promise(.failure(error))
                } else if let user = result?.user {
                    promise(.success(user))
                } else {
                    // Handle unexpected case
                    let unknownError = NSError(domain: "YourDomain", code: 0, userInfo: nil)
                    promise(.failure(unknownError))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    func loginuser(with email:String,password:String ) -> Future<User,Error>{
        return Future<User, Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password){ result, error in
            if let error = error {
                promise(.failure(error))
            } else if let user = result?.user {
                promise(.success(user))
            } else {
                let unknownError = NSError(domain: "YourDomain", code: 0, userInfo: nil)
                promise(.failure(unknownError))
            }
        }
        } }
}

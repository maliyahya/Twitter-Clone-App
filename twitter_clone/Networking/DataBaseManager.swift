//
//  DataBaseManager.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 8.01.2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuthCombineSwift
import Combine


class DataBaseManager {
    static let shared = DataBaseManager()
    let db = Firestore.firestore()
    let usersPath = "users"
    let tweetPath="tweets"
    
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error> {
        let twitterUser = TwitterUserModel(from: user)
        return Future<Bool, Error> { [self] promise in
            do {
                try db.collection(usersPath).document(twitterUser.id).setData(from: twitterUser) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(true))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func collectionUsers(retrieve id: String) -> AnyPublisher<TwitterUserModel, Error> {
          return Future<TwitterUserModel, Error> { promise in
              let docRef = self.db.collection(self.usersPath).document(id)
              docRef.getDocument { (document, error) in
                  if let error = error {
                      promise(.failure(error))
                  } else if let document = document, document.exists {
                      do {
                          let twitterUser = try document.data(as: TwitterUserModel.self)
                          promise(.success(twitterUser))
                      } catch {
                          promise(.failure(error))
                      }
                  } else {
                      let customError = NSError(domain: "YourAppDomain", code: 404, userInfo: nil)
                      promise(.failure(customError))                      
                  }
              }
          }
          .eraseToAnyPublisher()
      }
    
    func collectionUsers(updateFields: [String: Any], for id: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            self.db.collection(self.usersPath).document(id).updateData(updateFields) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(true))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func collectionTweets(dispatch tweet: TweetModel) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            do {
                try self.db.collection(self.tweetPath).document(tweet.id).setData(from: tweet) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(true))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    func collectionTweets(forUserID: String) -> AnyPublisher<[TweetModel], Error> {
        return Future<[TweetModel], Error> { promise in
            self.db.collection(self.tweetPath)
                .whereField("authorID", isEqualTo: forUserID)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    do {
                        let tweets = try querySnapshot?.documents.map {
                            try $0.data(as: TweetModel.self)
                        } ?? []
                        promise(.success(tweets))
                    } catch {
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    func collectionTweets() -> AnyPublisher<[TweetModel], Error> {
        return Future<[TweetModel], Error> { promise in
            self.db.collection(self.tweetPath).order(by: "authorID", descending: false)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    do {
                        let tweets = try querySnapshot?.documents.map {
                            try $0.data(as: TweetModel.self)
                        } ?? []
                        promise(.success(tweets))
                    } catch {
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
  }
    
    
    

    
    

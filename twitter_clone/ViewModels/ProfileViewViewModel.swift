//
//  ProfileViewViewModel.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 13.01.2024.
//

import Foundation
import Combine
import FirebaseAuth

final class ProfileViewViewModel:ObservableObject{
    public var subscriptions:Set<AnyCancellable> = []
    @Published var user:TwitterUserModel?
    @Published var error:String?
    @Published var tweets:[TweetModel] = []
    func retrieveUser(){
        guard let id = Auth.auth().currentUser?.uid else { return}
        DataBaseManager.shared.collectionUsers(retrieve: id).handleEvents(receiveOutput: { [weak self ] user in
            self?.user = user
            self?.fetchTweets()
        })
            .sink {[weak self] completion in
            if case .failure(let error) = completion{
                self?.error=error.localizedDescription
            }
        } receiveValue: { [weak self] user in
            self?.user=user
            print(user)
        }
        .store(in: &subscriptions)
    }
    func retrieveUser(id:String){
        DataBaseManager.shared.collectionUsers(retrieve: id).handleEvents(receiveOutput: { [weak self ] user in
            self?.user = user
            self?.fetchTweets()
        })
            .sink {[weak self] completion in
            if case .failure(let error) = completion{
                self?.error=error.localizedDescription
            }
        } receiveValue: { [weak self] user in
            self?.user=user
            print(user)
        }
        .store(in: &subscriptions)
    }
    func getFormattedData(with date: Date)->String{
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "MMM YYYY"
        return dataFormatter.string(from:date)
    }
    func fetchTweets(){
        guard let userID=user?.id else{
            return
        }
        DataBaseManager.shared.collectionTweets(forUserID: userID).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.error=error.localizedDescription
            }
        } receiveValue: { [weak self] retreivedTweets in
            self?.tweets=retreivedTweets
            
        }
        .store(in: &subscriptions)

    }
    
    
}

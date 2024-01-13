//
//  HomeViewViewModel.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 12.01.2024.
//

import Foundation
import Firebase
import Combine


final class HomeViewViewModel:ObservableObject{
    @Published var user:TwitterUserModel?
    @Published var error:String?
    @Published var tweets:[TweetModel] = []
    private var subscriptions:Set<AnyCancellable> = []
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
    func fetchTweets(){
        DataBaseManager.shared.collectionTweets().sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.error=error.localizedDescription
            }
        } receiveValue: { [weak self] retreivedTweets in
            self?.tweets=retreivedTweets
        }
        .store(in: &subscriptions)

    }
    
    
    
}

//
//  TweetComposeViewViewModel.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 13.01.2024.
//

import Foundation
import Combine
import FirebaseAuth

final class TweetComposeViewViewModel:ObservableObject{
    public var subscriptions:Set<AnyCancellable> = []
    
    @Published var isValidToTweet:Bool = false
    @Published var error:String?
    @Published var shouldDismissCompose:Bool = false
    var tweetContent:String=""
    private var user:TwitterUserModel?

    func getUserData(){
        guard let userID=Auth.auth().currentUser?.uid else {
            return
        }
        DataBaseManager.shared.collectionUsers(retrieve: userID).sink { completion in
            if case .failure(let error) = completion{
                self.error=error.localizedDescription
                
            }
        } receiveValue: { [weak self] twitterUser in
            self?.user=twitterUser
            
        }
        .store(in: &subscriptions)

    }
    
    func validateToTweet()
    {
        isValidToTweet = !tweetContent.isEmpty
    }
    
    func dispatchTweet()
    {
        guard let user=user else {
            return
        }
        let tweet=TweetModel(author: user, authorID: user.id, tweetContent: tweetContent, likesCount: 0, likers: [], isReply: false, parentReference: nil)
        DataBaseManager.shared.collectionTweets(dispatch: tweet).sink {[weak self] completion in
            if case .failure(let error) = completion{
                self?.error=error.localizedDescription
            }
        } receiveValue: { [weak self] state in
            self?.shouldDismissCompose=state
            
        }.store(in: &subscriptions)

    }
    
    
    
}

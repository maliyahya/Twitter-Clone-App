//
//  SearchViewViewModel.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 14.01.2024.
//

import Foundation
import FirebaseAuth
import FirebaseStorageCombineSwift
import Combine

class SearchViewViewModel:ObservableObject{
    
    @Published var error:String?
    @Published var users:[TwitterUserModel]?
    @Published var subscriptions: Set<AnyCancellable> = []
    func getUserData(){
        DataBaseManager.shared.collectionUsers().sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.error=error.localizedDescription
            }
        } receiveValue: { [weak self ] users in
            self?.users=users
        }.store(in: &subscriptions)
    }
    func searchUserDatawithUsername(prefix:String){
        DataBaseManager.shared.searchUserDatawithUsername(prefix).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.error=error.localizedDescription
            }
        }receiveValue: { [weak self ] users in
            self?.users=users
        }.store(in: &subscriptions)
    }
    func searchUserDatawithDisplayname(prefix:String){
        DataBaseManager.shared.searchUserDatawithDisplayname(prefix).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.error=error.localizedDescription
            }
        }receiveValue: { [weak self ] users in
            self?.users=users
        }.store(in: &subscriptions)
    }
    
}

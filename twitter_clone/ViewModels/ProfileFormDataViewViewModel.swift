//
//  ProfileFormDataViewViewModel.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 12.01.2024.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorageCombineSwift
import FirebaseStorage
import Combine

final class ProfileFormDataViewViewModel:ObservableObject{
    
    private var subscription:Set<AnyCancellable> = []
    @Published var displayName:String?
    @Published var username:String?
    @Published var bio:String?
    @Published var avatarPath:String?
    @Published var imageData:UIImage?
    @Published var isFormValid:Bool?
    @Published var error:String?
    @Published var url:URL?
    @Published var isOnBoradingFinished:Bool=false
    
    
    func validateUserProfileForm(){
        guard let displayName = displayName,
              displayName.count > 2,
              let username = username,
              username.count>2,
              let bio=bio,
              bio.count > 2,
                imageData != nil else{
            isFormValid=false
            return
        }
        isFormValid=true
    }
    
    func uploadAvatar(){
        let randomID=UUID().uuidString
        guard let imageData = imageData?.jpegData(compressionQuality: 0.5 ) else{ return }
        let metaData = StorageMetadata()
        metaData.contentType="image/jpeg"
        StorageManager.shared.uploadProfilePhoto(with: randomID, image: imageData, metaData: metaData)
            .flatMap({ metaData in
                StorageManager.shared.getDownloadURL(for: metaData.path)
            })
            .sink { [weak self] completion in
                switch completion{
                case .failure(let error):
                        self?.error=error.localizedDescription
                case .finished:
                    self?.updateUserData()

                }
            } receiveValue: { [weak self] url in
                self?.avatarPath=url.absoluteString
            }.store(in: &subscription)

    }
    private func updateUserData(){
        guard let displayName,
                let username,
                let bio,
                let avatarPath,
                let id = Auth.auth().currentUser?.uid
        else { return}
        let updateFields:[String:Any] = [
            "displayName":displayName,
            "username":username,
            "bio":bio,
            "avatarPath":avatarPath,
            "isUserOnboarded":true
        ]
        DataBaseManager.shared.collectionUsers(updateFields: updateFields, for: id).sink { completion in
            if case .failure(let error) = completion{
                print(error.localizedDescription)
                self.error=error.localizedDescription
            }
        } receiveValue: {[weak self] onboardingState in
            self?.isOnBoradingFinished=onboardingState
        }
        .store(in: &subscription)

    }
    
    
    
}

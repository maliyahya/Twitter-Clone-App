//
//  StorageManager.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 12.01.2024.
//

import Foundation
import Combine
import FirebaseStorageCombineSwift
import FirebaseStorage

enum FireStorageError:Error{
    case invalidImageID
}
class StorageManager{
    static let shared=StorageManager()
    let storage=Storage.storage()
    func getDownloadURL(for id:String?)->AnyPublisher<URL,Error>{
        guard let id = id else{
            return Fail(error: FireStorageError.invalidImageID)
                .eraseToAnyPublisher()
        }
        return storage
            .reference(withPath: id)
            .downloadURL()
            .eraseToAnyPublisher()
            
    }
    func uploadProfilePhoto(with randomID:String,image:Data,metaData:StorageMetadata) -> AnyPublisher<StorageMetadata,Error>{
        return storage
            .reference()
            .child("images/\(randomID).jpg")
            .putData(image,metadata: metaData)
            .eraseToAnyPublisher()
    }
    
}

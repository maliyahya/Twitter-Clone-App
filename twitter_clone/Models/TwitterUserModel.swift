//
//  TwitterUserModel.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 8.01.2024.
//

import Foundation
import Firebase

struct TwitterUserModel:Codable{
    let id:String
    var displayName:String=""
    var username:String=""
    var folloverCount:Int=0
    var followingCount:Int=0
    var createdOn:Date=Date()
    var bio:String=""
    var avatarPath:String=""
    var isUserOnboarded:Bool=false
    
    init(from user: User)  {
        self.id=user.uid
    }
    
    
}

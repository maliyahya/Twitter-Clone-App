//
//  ProfileTableViewCell.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 14.01.2024.
//

import Foundation
import UIKit

protocol ProfileTableViewCellDelegate:AnyObject{
    func tweetTableViewCellDidTapReply()
    func tweetTableViewCellDidRetweet()
    func tweetTableViewCellDidTapLike()
    func tweetTableViewCellDidTapShare()
}

class ProfileTableViewCell:UITableViewCell{
    static let identifier="ProfileTableViewCell"
    weak var delegate:ProfileTableViewCellDelegate?
    
    private let followButton:UIButton={
        let followButton=UIButton(type : .system)
        followButton.translatesAutoresizingMaskIntoConstraints=false
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = .twitterBlueColor
        followButton.tintColor = .white
        followButton.layer.cornerRadius=10
        followButton.clipsToBounds=true
        followButton.layer.masksToBounds=true
        return followButton
    }()
    private let avatarImageView:UIImageView={
        let imageView=UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints=false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds=true
        imageView.clipsToBounds=true
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private let displaynameLabel:UILabel={
        let label=UILabel()
        label.font = .systemFont(ofSize: 15,weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    private let usernameLabel:UILabel={
        let label=UILabel()
        label.font = .systemFont(ofSize: 15,weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(displaynameLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(followButton)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     func configureUsers(displayname:String,username:String,avatarPath:String){
        displaynameLabel.text=displayname
        usernameLabel.text=username
        avatarImageView.sd_setImage(with: URL(string:avatarPath))
    }
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 30),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            avatarImageView.heightAnchor.constraint(equalToConstant: 35),
            avatarImageView.widthAnchor.constraint(equalToConstant: 35),
            
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 3),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            displaynameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor,constant: 10),
            displaynameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 18),
            displaynameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            followButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            followButton.heightAnchor.constraint(equalToConstant: 30),
            followButton.widthAnchor.constraint(equalToConstant: 90),
            followButton.topAnchor.constraint(equalTo: avatarImageView.topAnchor,constant: 5)
            
        ])
    }
}



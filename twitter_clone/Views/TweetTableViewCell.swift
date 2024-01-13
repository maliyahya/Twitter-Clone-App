//
//  TweetTableViewCell.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 7.01.2024.
//

import UIKit

protocol TweetTableViewCellDelegate:AnyObject{
    func tweetTableViewCellDidTapReply()
    func tweetTableViewCellDidRetweet()
    func tweetTableViewCellDidTapLike()
    func tweetTableViewCellDidTapShare()
}
class TweetTableViewCell: UITableViewCell {
    static let identifier="TweetTableViewCell"
    weak var delegate:TweetTableViewCellDelegate?
    private let avatarImageView:UIImageView={
        let imageView=UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints=false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds=true
        imageView.clipsToBounds=true
        imageView.image=UIImage(systemName: "person")
        imageView.backgroundColor = .red
        return imageView
    }()
    private let displayNameLabel:UILabel={
        let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18,weight: .bold)
        return label
    }()
    private let usernameLabel:UILabel={
        let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16,weight: .regular)
        return label
    }()
    private let tweetLabel:UILabel={
        let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.numberOfLines=10
        return label
    }()
    private let retweetButton:UIButton={
        let button=UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setImage(UIImage(systemName: "arrow.2.squarepath"), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    private let likeButton:UIButton={
        let button=UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    private let shareButton:UIButton={
        let button=UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    private let commentButton:UIButton={
        let button=UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(displayNameLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(tweetLabel)
        contentView.addSubview(retweetButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(commentButton)
        configureConstraints()
        configureButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func didTapReply(){
        delegate?.tweetTableViewCellDidTapReply()
    }
     func configureTweets(tweetContextText:String,displayName:String,username:String,avatarPath:String){
        tweetLabel.text=tweetContextText
        displayNameLabel.text=displayName
        usernameLabel.text=username
        avatarImageView.sd_setImage(with: URL(string: avatarPath))
    }
    @objc private func didTapLike(){
        delegate?.tweetTableViewCellDidTapLike()
    }
    @objc private func didTapRetweet(){
        delegate?.tweetTableViewCellDidRetweet()
    }
    @objc private func didTapShare(){
        delegate?.tweetTableViewCellDidTapShare()
    }
    private func configureButtons(){
        commentButton.addTarget(self ,action: #selector(didTapReply), for: .touchUpInside)
        likeButton.addTarget(self ,action: #selector(didTapLike), for: .touchUpInside)
        shareButton.addTarget(self ,action: #selector(didTapShare), for: .touchUpInside)
        retweetButton.addTarget(self ,action: #selector(didTapRetweet), for: .touchUpInside)
    }
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 14),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            
            usernameLabel.topAnchor.constraint(equalTo: displayNameLabel.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.trailingAnchor,constant: 7),
            
            displayNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor,constant: 10),
            displayNameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            
            tweetLabel.topAnchor.constraint(equalTo: displayNameLabel.topAnchor,constant: 20),
            tweetLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: 13),
            tweetLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            
            commentButton.topAnchor.constraint(equalTo: tweetLabel.bottomAnchor,constant: 10),
            commentButton.leadingAnchor.constraint(equalTo: tweetLabel.leadingAnchor),
            
            retweetButton.topAnchor.constraint(equalTo: tweetLabel.bottomAnchor,constant: 10),
            retweetButton.leadingAnchor.constraint(equalTo: tweetLabel.leadingAnchor,constant: 80),
            
            likeButton.topAnchor.constraint(equalTo: tweetLabel.bottomAnchor,constant: 10),
            likeButton.leadingAnchor.constraint(equalTo: tweetLabel.leadingAnchor,constant: 160),
            
            shareButton.topAnchor.constraint(equalTo: tweetLabel.bottomAnchor, constant: 5),
            shareButton.leadingAnchor.constraint(equalTo: tweetLabel.leadingAnchor,constant: 240),
        
        ])
    }
    
}

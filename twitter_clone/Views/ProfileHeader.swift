//
//  ProfileHeader.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 7.01.2024.
//

import UIKit

class ProfileHeader: UIView {
    private var tabs:[UIButton] = ["Tweets","Tweets & Replies","Media","Likes"].map { buttonTitle in
        let button=UIButton(type: .system)
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints=false
        return button
    }
    private lazy var sectionStack:UIStackView={
       let stackView=UIStackView(arrangedSubviews: tabs)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    var profileAvatarImage:UIImageView={
        let imageView=UIImageView()
        imageView.clipsToBounds=true
        imageView.translatesAutoresizingMaskIntoConstraints=false
        imageView.layer.cornerRadius=25
        imageView.backgroundColor = . yellow
        return imageView
    }()
    var profileHeaderImage:UIImageView={
       let imageView=UIImageView()
        imageView.image=UIImage(named: "banner")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints=false
        imageView.clipsToBounds=true
        return imageView
    }()
    private let calendarImage:UIImageView={
        let imageView=UIImageView()
        imageView.image=UIImage(systemName: "calendar")
        imageView.clipsToBounds=true
        imageView.translatesAutoresizingMaskIntoConstraints=false
        return imageView
    }()
    var userNameLabel:UILabel={
        let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = .systemFont(ofSize: 15,weight: .light)
        label.textColor = .label
        return label
    }()
    var displayNameLabel:UILabel={
        let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = .systemFont(ofSize: 22,weight: .bold)
        label.textColor = .label
        return label
    }()
    var userBioLabel:UILabel={
        let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.textColor = .label
        label.font = .systemFont(ofSize: 15,weight: .bold)

        return label
    }()
    var joinDateLabel:UILabel={
        let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = .systemFont(ofSize: 15,weight: .light)
        label.textColor = .label
        return label
    }()
    private let followerTextLabel:UILabel={
        let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.text="Followers"
        label.font = .systemFont(ofSize: 15,weight: .light)
        label.textColor = .label
        return label
    }()
    var followerCountLabel:UILabel={
        let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = .systemFont(ofSize: 15,weight: .bold)
        label.textColor = .label
        return label
    }()
    private let followingTextLabel:UILabel={
        let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.text="Following"
        label.font = .systemFont(ofSize: 15,weight: .light)
        label.textColor = .label
        return label
    }()
    var followingCountLabel:UILabel={
        let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = .systemFont(ofSize: 15,weight: .bold)
        label.textColor = .label
        return label
    }()
    private let  indicator:UIView={
       let view=UIView()
        view.translatesAutoresizingMaskIntoConstraints=false
        view.backgroundColor = .twitterBlueColor
        return view
    }()
    private func configureStackButton(){
        for(i,button) in sectionStack.arrangedSubviews.enumerated(){
            guard let button = button as? UIButton else { return }
            if i==selectedTab{
                button.tintColor = .label
            }
            else{
                button.tintColor = .secondaryLabel
            }
            button.addTarget(self, action: #selector(didTapTab(_:)), for: .touchUpInside)
        }
    }
    private enum SectionTabs:String{
        case tweets="Tweets"
        case tweetAndReplies="Tweets & Replies"
        case media="Media"
        case likes="Likes"
        var index:Int{
            switch self{
        case .tweets:
            return 0
        case .tweetAndReplies:
            return 1
        case .media:
            return 2
        case .likes:
            return 3
            }  }
    }
    @objc private func didTapTab(_ sender:UIButton){
        guard let label=sender.titleLabel?.text else { return}
        switch label{
        case SectionTabs.tweets.rawValue:
            selectedTab=0
        case SectionTabs.tweetAndReplies.rawValue:
            selectedTab=1
        case SectionTabs.media.rawValue:
            selectedTab=2
        case SectionTabs.likes.rawValue:
            selectedTab=3
        default:
            selectedTab=0
        }
    }
    private var  selectedTab:Int=0{
        didSet{
            for i in 0..<tabs.count{
                UIView.animate(withDuration: 0.3, delay: 0,options: .curveEaseInOut){
                    [weak self] in
                    self?.sectionStack.arrangedSubviews[i].tintColor = i == self?.selectedTab ? .label : .secondaryLabel
                    self?.leadingAnchors[i].isActive = i == self?.selectedTab ? true : false
                    self?.trailingAnchors[i].isActive = i == self?.selectedTab ? true : false
                    self?.layoutIfNeeded()
                }
            completion:{ _ in
            }
            }
    }
    }
    private var leadingAnchors:[NSLayoutConstraint] = []
    private var trailingAnchors: [NSLayoutConstraint] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileHeaderImage)
        addSubview(profileAvatarImage)
        addSubview(calendarImage)
        addSubview(displayNameLabel)
        addSubview(userNameLabel)
        addSubview(userBioLabel)
        addSubview(calendarImage)
        addSubview(joinDateLabel)
        addSubview(followingTextLabel)
        addSubview(followingCountLabel)
        addSubview(followerTextLabel)
        addSubview(followerCountLabel)
        addSubview(sectionStack)
        addSubview(indicator)
        configureConstraints()
        configureStackButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints(){
        for i in 0..<tabs.count{
            let leadingAnchor=indicator.leadingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].leadingAnchor)
            leadingAnchors.append(leadingAnchor)
            let trailingAnchor=indicator.trailingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].trailingAnchor)
            trailingAnchors.append(trailingAnchor)
        }
        let indicatorConstraints = [
            leadingAnchors[0],
            trailingAnchors[0],
        indicator.topAnchor.constraint(equalTo: sectionStack.arrangedSubviews[0].bottomAnchor),
        indicator.heightAnchor.constraint(equalToConstant: 2),
        ]
        NSLayoutConstraint.activate([
            profileHeaderImage.topAnchor.constraint(equalTo:topAnchor,constant: -180),
            profileHeaderImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5),
            profileHeaderImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            profileHeaderImage.bottomAnchor.constraint(equalTo: bottomAnchor,constant:5),
            
            profileAvatarImage.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
            profileAvatarImage.topAnchor.constraint(equalTo: topAnchor,constant: 160 ),
            profileAvatarImage.heightAnchor.constraint(equalToConstant: 60),
            profileAvatarImage.widthAnchor.constraint(equalToConstant: 60),
            
            displayNameLabel.topAnchor.constraint(equalTo: profileAvatarImage.bottomAnchor, constant:5),
            displayNameLabel.leadingAnchor.constraint(equalTo: profileAvatarImage.leadingAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 2),
            userNameLabel.leadingAnchor.constraint(equalTo: profileAvatarImage.leadingAnchor),
            
            userBioLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2),
            userBioLabel.leadingAnchor.constraint(equalTo: profileAvatarImage.leadingAnchor),
            
            calendarImage.topAnchor.constraint(equalTo: userBioLabel.bottomAnchor,constant: 2),
            calendarImage.leadingAnchor.constraint(equalTo: profileAvatarImage.leadingAnchor),
            calendarImage.heightAnchor.constraint(equalToConstant: 22),
            calendarImage.widthAnchor.constraint(equalToConstant: 22),
            
            joinDateLabel.topAnchor.constraint(equalTo: userBioLabel.bottomAnchor,constant: 4),
            joinDateLabel.leadingAnchor.constraint(equalTo: calendarImage.trailingAnchor,constant:2),
            
            followingCountLabel.topAnchor.constraint(equalTo: joinDateLabel.bottomAnchor, constant: 4),
            followingCountLabel.leadingAnchor.constraint(equalTo: profileAvatarImage.leadingAnchor),
            
            followingTextLabel.topAnchor.constraint(equalTo: joinDateLabel.bottomAnchor,constant: 4),
            followingTextLabel.leadingAnchor.constraint(equalTo: followingCountLabel.trailingAnchor,constant: 4),
            
            followerCountLabel.topAnchor.constraint(equalTo: joinDateLabel.bottomAnchor, constant:4),
            followerCountLabel.leadingAnchor.constraint(equalTo: followingTextLabel.trailingAnchor,constant: 4),
            
            followerTextLabel.topAnchor.constraint(equalTo: joinDateLabel.bottomAnchor, constant: 4),
            followerTextLabel.leadingAnchor.constraint(equalTo: followerCountLabel.trailingAnchor,constant: 4),
            
            sectionStack.topAnchor.constraint(equalTo: followerTextLabel.bottomAnchor,constant: 5),
            sectionStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            sectionStack.heightAnchor.constraint(equalToConstant: 35)
        ])
        NSLayoutConstraint.activate(indicatorConstraints)
    }
}

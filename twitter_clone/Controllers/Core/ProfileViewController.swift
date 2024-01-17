//
//  ProfileViewController.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 7.01.2024.
//

import UIKit
import Combine
import SDWebImage

class ProfileViewController: UIViewController {
    private var viewModel=ProfileViewViewModel()
    private lazy var headerView=ProfileHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 380))
    private var subscriptions:Set<AnyCancellable> = []

     private let profileTableView:UITableView={
        let tableView=UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints=false
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title="Profile"
        view.addSubview(profileTableView)
        profileTableView.delegate=self
        profileTableView.dataSource=self
        profileTableView.tableHeaderView=headerView
        configureConstraints()
        bindViews()
    }
    private func bindViews(){
        viewModel.$user.sink { [weak self] user in
            guard let user=user else { return }
            self?.headerView.displayNameLabel.text=user.displayName
            self?.headerView.userNameLabel.text="@\(user.username)"
            self?.headerView.followerCountLabel.text="\(user.folloverCount)"
            self?.headerView.followingCountLabel.text="\(user.followingCount)"
            self?.headerView.userBioLabel.text=user.bio
            self?.headerView.profileAvatarImage.sd_setImage(with: URL(string: user.avatarPath))
            self?.headerView.joinDateLabel.text="Joined \(self?.viewModel.getFormattedData(with:user.createdOn) ?? "")"
            
        }.store(in: &subscriptions)
        
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async{
                self?.profileTableView.reloadData()
            }
        }.store(in: &subscriptions)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retrieveUser()
    }

    
    
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            profileTableView.topAnchor.constraint(equalTo:view.topAnchor),
            profileTableView.trailingAnchor.constraint(equalTo:view.trailingAnchor),
            profileTableView.leadingAnchor.constraint(equalTo:view.leadingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo:view.bottomAnchor),
        ]
        )
    }
}


extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier,for: indexPath) as?
                TweetTableViewCell else{
            return UITableViewCell()
        }
        let model=viewModel.tweets[indexPath.row]
        cell.configureTweets(tweetContextText: model.tweetContent, displayName: model.author.displayName, username: model.author.username, avatarPath: model.author.avatarPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}

//
//  HomeViewController.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 7.01.2024.
//

import UIKit
import FirebaseAuth
import Combine

class HomeViewController: UIViewController {
    private var viewModel=HomeViewViewModel()
    private var subscriptions:Set<AnyCancellable> = []
    private func configureNavigationBar(){
        let size:CGFloat=36
        let logoImageView=UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image=UIImage(named: "twitter")
        let middleView=UIView(frame: CGRect(x: 0, y: 0, width:size, height: size))
        middleView.addSubview(logoImageView)
        navigationItem.titleView=middleView
        let profileImage=UIImage(systemName: "person")
        navigationItem.leftBarButtonItem=UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(didTapProfile))
        let logoutImage=UIImage(systemName: "rectangle.portrait.and.arrow.right")
        navigationItem.rightBarButtonItem=UIBarButtonItem(image: logoutImage, style: .plain, target: self, action:#selector(didTapQuit))
    }
    @objc private func didTapProfile(){
        let vc=ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func didTapQuit(){
        try? Auth.auth().signOut()
        handleAuthentication()

    }
    private lazy var composeTweetButton:UIButton={
        let button=UIButton(type: .system,primaryAction: UIAction{ [weak self] _ in
            self?.navigateToTweetCompose()
        })
        button.translatesAutoresizingMaskIntoConstraints=false
        button.backgroundColor = .twitterBlueColor
        button.tintColor = .white
        let plusSing = UIImage(systemName: "plus",withConfiguration: UIImage.SymbolConfiguration(pointSize: 18,weight: .bold))
        button.setImage(plusSing, for: .normal)
        button.layer.cornerRadius=30
        button.clipsToBounds=true
        return button
    }()
    private let timelineTableView:UITableView = {
        let tableView=UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()
    override func viewDidLoad(){
        super.viewDidLoad()
        view.addSubview(timelineTableView)
        view.addSubview(composeTweetButton)
        timelineTableView.delegate=self
        timelineTableView.dataSource=self
        configureNavigationBar()
        bindViews()
        configureConstraints()
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        timelineTableView.frame = view.frame
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        viewModel.retrieveUser()
    }
    
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            composeTweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -25),
            composeTweetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -120),
            composeTweetButton.widthAnchor.constraint(equalToConstant: 60),
            composeTweetButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    private func navigateToTweetCompose(){
        let vc=UINavigationController(rootViewController: TweetComposeViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: true)
    }
    private func handleAuthentication(){
        if Auth.auth().currentUser == nil{
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc,animated: false)
        }
    }
    private func completeUserOnBoarding(){
        let vc = ProfileFormDataViewController()
        present(vc,animated: true)
    }
    private func bindViews(){
        viewModel.$user.sink {[weak self] user in
            guard let user = user else{
                return
            }
            print(user.isUserOnboarded)
            if !user.isUserOnboarded{
                self?.completeUserOnBoarding()
            }
        }
        .store(in: &subscriptions)
        
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async{
                self?.timelineTableView.reloadData()
            }
        }.store(in: &subscriptions)
        
    }
}
extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tweets.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell=tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier,for: indexPath) as?
                TweetTableViewCell else{
            return UITableViewCell()
        }
        let model=viewModel.tweets[indexPath.row]
        cell.configureTweets(tweetContextText: model.tweetContent, displayName: model.author.displayName, username: "@\(model.author.username)", avatarPath: model.author.avatarPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

extension HomeViewController:TweetTableViewCellDelegate{
    func tweetTableViewCellDidTapReply() {
        print("reply")
    }
    
    func tweetTableViewCellDidRetweet() {
        print("retweet")

    }
    
    func tweetTableViewCellDidTapLike() {
        print("like")

    }
    
    func tweetTableViewCellDidTapShare() {
        print("share")

    }
    
    
}

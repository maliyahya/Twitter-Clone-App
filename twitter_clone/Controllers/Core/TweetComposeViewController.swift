//
//  TweetComposeViewController.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 13.01.2024.
//

import UIKit
import Combine

class TweetComposeViewController: UIViewController {
    private var viewModel=TweetComposeViewViewModel()
    private var subscriptions:Set<AnyCancellable> = []
    
    private let tweetButton:UIButton={
        let button=UIButton(type: .system)
        button.setTitle("Tweet", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .twitterBlueColor
        button.layer.cornerRadius = 30
        button.clipsToBounds=true
        button.translatesAutoresizingMaskIntoConstraints=false
        button.isEnabled=false
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        return button
        
    }()
    private let tweetTextView:UITextView={
       let tweetText=UITextView()
        tweetText.translatesAutoresizingMaskIntoConstraints=false
        tweetText.layer.masksToBounds = true
        tweetText.layer.cornerRadius = 8
        tweetText.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        tweetText.textColor = .gray
        tweetText.text="What's happening"
        tweetText.font = .systemFont(ofSize: 16)
        return tweetText
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title="Tweet"
        navigationItem.leftBarButtonItem=UIBarButtonItem(title: "Cancel",style:.plain, target: self, action: #selector(didTapToCancel))
        tweetTextView.delegate=self
        view.addSubview(tweetTextView)
        view.addSubview(tweetButton)
        configureConstaints()
        bindViews()
        tweetButton.addTarget(self, action: #selector(didTapToTweet), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserData()

    }
    private func bindViews(){
        viewModel.$isValidToTweet.sink {[weak self] buttonState in
            self?.tweetButton.isEnabled=buttonState
            
        }.store(in: &subscriptions)
        
        viewModel.$shouldDismissCompose.sink { [weak self] succes in
            if succes{
                self?.dismiss(animated: true)
            }
        }
        .store(in: &subscriptions)
        
    }
    @objc private func didTapToTweet(){
        viewModel.dispatchTweet()
        
    }
    @objc private func didTapToCancel(){
        dismiss(animated: true)
    }
    
    private func configureConstaints(){
        NSLayoutConstraint.activate([
            tweetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -120),
            tweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            tweetButton.heightAnchor.constraint(equalToConstant: 60),
            tweetButton.widthAnchor.constraint(equalToConstant: 125),
            
            tweetTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            tweetTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -20),
            tweetTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 15),
            tweetTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
            
        
        ])
    }
}

extension TweetComposeViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tweetTextView.textColor == .gray{
            tweetTextView.text = " "
            tweetTextView.textColor = .label
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if tweetTextView.text.isEmpty{
            tweetTextView.text="What's happening"
            tweetTextView.textColor = .gray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.tweetContent = textView.text
        viewModel.validateToTweet()
    }
}

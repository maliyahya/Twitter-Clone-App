//
//  OnboardingViewController.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 8.01.2024.
//

import UIKit



class OnboardingViewController: UIViewController {
    let onboardLabel:UILabel={
        let label=UILabel()
        label.text="See what's happening in the world right now"
        label.numberOfLines=5
        label.font = .systemFont(ofSize: 35,weight:.bold)
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    let subText:UILabel={
        let label=UILabel()
        label.text="Have an account already ?"
        label.font = .systemFont(ofSize: 12,weight:.bold)
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    let loginButton:UIButton={
        let button=UIButton(type : .system)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemBackground
        button.tintColor = .twitterBlueColor
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)

        return button
    }()
    let createAccountButton:UIButton={
        let button=UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setTitle("Create Account", for: .normal)
        button.backgroundColor = .twitterBlueColor
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.titleLabel?.font = .systemFont(ofSize: 24,weight: .bold)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(onboardLabel)
        view.addSubview(createAccountButton)
        view.addSubview(subText)
        view.addSubview(loginButton)
        configureConstraints()
    }
    @objc private func didTapCreateAccountButton(){
        let vc=RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func didTapLoginButton(){
        let vc=LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func configureConstraints(){
        NSLayoutConstraint.activate([
            onboardLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            onboardLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            onboardLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            
            createAccountButton.topAnchor.constraint(equalTo: onboardLabel.bottomAnchor, constant: 20),
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountButton.widthAnchor.constraint(equalTo: onboardLabel.widthAnchor,constant: -20),
            createAccountButton.heightAnchor.constraint(equalToConstant: 60),
            
            subText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            subText.leadingAnchor.constraint(equalTo: onboardLabel.leadingAnchor),
            
            loginButton.leadingAnchor.constraint(equalTo: subText.trailingAnchor,constant: 15),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -33)
        ])
    }


}



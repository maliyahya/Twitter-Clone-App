//
//  LoginViewController.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 8.01.2024.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    private var viewModel = AuthenticationViewViewModel()
    private var subscription:Set<AnyCancellable> = []
    private let titleLabel:UILabel={
        let label=UILabel()
        label.text="Login to your account"
        label.font = .systemFont(ofSize: 30,weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints=false
        label.numberOfLines=1
        return label
    }()
    private let emailTextField:UITextField={
        let textField=UITextField()
        textField.attributedPlaceholder=NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
        textField.translatesAutoresizingMaskIntoConstraints=false
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
            return textField
    }()
    private let passwordTextField:UITextField={
        let textField=UITextField()
        textField.attributedPlaceholder=NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
        textField.translatesAutoresizingMaskIntoConstraints=false
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isSecureTextEntry=true
            return textField
    }()
    let loginAccountButton:UIButton={
        let button=UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .twitterBlueColor
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.titleLabel?.font = .systemFont(ofSize: 20,weight: .bold)
        button.isEnabled=false
        return button
    }()
    @objc private func didChangeEmailField(){
        viewModel.email=emailTextField.text
        viewModel.validateRegistrationForm()
    }
    @objc private func didChangePasswordField(){
        viewModel.password=passwordTextField.text
        viewModel.validateRegistrationForm()
    }
    private func bindViews(){
        emailTextField.addTarget(self, action: #selector(didChangeEmailField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangePasswordField), for: .editingChanged)
        viewModel.$isAuthenticationFormValid.sink { validationState in
            self.loginAccountButton.isEnabled=validationState
        }
        .store(in: &subscription)
        viewModel.$user.sink{
            [weak self ] user in
            guard user != nil else{
                return
            }
            guard let vc=self?.navigationController?.viewControllers.first as? OnboardingViewController else { return}
            vc.dismiss(animated: true)
            
        }        .store(in: &subscription)
        viewModel.$error.sink { [weak self] errorString in
            guard let error = errorString else { return }
            self?.presentAlert(with: error)
        }
        .store(in: &subscription)

    }
    @objc private func didTapToDismiss(){
        view.endEditing(true)
    }
    @objc private func didTapLoginButton(){
        viewModel.loginuser()
    }
    private func presentAlert(with error:String){
        let alert=UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okeyButton=UIAlertAction(title: "ok", style: .default)
        alert.addAction(okeyButton)
        present(alert,animated: true)
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginAccountButton)
        bindViews()
        loginAccountButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)

        configureConstraints()

    }
    

    private func configureConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant:20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor,constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            loginAccountButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant: 30),
            loginAccountButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            loginAccountButton.widthAnchor.constraint(equalToConstant: 200),
            loginAccountButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
    }
}

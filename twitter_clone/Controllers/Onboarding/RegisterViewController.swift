//
//  RegisterViewController.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 8.01.2024.
//

import UIKit
import Combine

class RegisterViewController: UIViewController {
    private var viewModel = AuthenticationViewViewModel()
    private var subscription:Set<AnyCancellable> = []
    private let titleLabel:UILabel={
        let label=UILabel()
        label.text="Create your account"
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
    let registerAccountButton:UIButton={
        let button=UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setTitle("Create Account", for: .normal)
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
    @objc private func didTapRegister(){
        viewModel.createUser()
    }
    private func bindViews(){
        emailTextField.addTarget(self, action: #selector(didChangeEmailField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangePasswordField), for: .editingChanged)
        viewModel.$isAuthenticationFormValid.sink { validationState in
            self.registerAccountButton.isEnabled=validationState
        }
        .store(in: &subscription)
        viewModel.$user.sink{
            [weak self ] user in
            guard user != nil else{
                return
            }
            guard let vc=self?.navigationController?.viewControllers.first as? OnboardingViewController else { return}
            vc.dismiss(animated: true)
        }      
        .store(in: &subscription)
        
        viewModel.$error.sink { [weak self] errorString in
            guard let error = errorString else { return }
            self?.presentAlert(with: error)
        }
        .store(in: &subscription)

    }
    private func presentAlert(with error:String){
        let alert=UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okeyButton=UIAlertAction(title: "ok", style: .default)
        alert.addAction(okeyButton)
        present(alert,animated: true)
        
    }
    @objc private func didTapToDismiss(){
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerAccountButton)
        registerAccountButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        configureConstraints()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(didTapToDismiss)))
        bindViews()
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
            
            registerAccountButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant: 30),
            registerAccountButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            registerAccountButton.widthAnchor.constraint(equalToConstant: 200),
            registerAccountButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
    }
}

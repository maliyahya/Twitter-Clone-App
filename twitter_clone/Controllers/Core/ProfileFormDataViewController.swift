//
//  ProfileFormDataViewController.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 12.01.2024.
//

import UIKit
import PhotosUI
import Combine

class ProfileFormDataViewController: UIViewController {
    
    private let viewModel=ProfileFormDataViewViewModel()
    private var subscriptions:Set<AnyCancellable>=[]
    
    private let submitButton:UIButton={
        let button=UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.layer.cornerRadius=20
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .twitterBlueColor
        button.layer.masksToBounds=true
        button.isEnabled=false
        return button
    }()
    
    private let hintLabel:UILabel={
        let label=UILabel()
        label.text="Fill in you data"
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let scrollView:UIScrollView={
       let scrollView=UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints=false
        scrollView.alwaysBounceVertical=true
        scrollView.keyboardDismissMode = .onDrag
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    private let avatarImage:UIImageView={
        let image=UIImageView()
        image.translatesAutoresizingMaskIntoConstraints=false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 60
        image.clipsToBounds=true
        image.backgroundColor = .lightGray
        image.tintColor = .gray
        image.image=UIImage(systemName: "camera")
        image.isUserInteractionEnabled=true
        return image
    }()
    private let bioTextView:UITextView={
       let bioText=UITextView()
        bioText.translatesAutoresizingMaskIntoConstraints=false
        bioText.backgroundColor = .secondarySystemFill
        bioText.layer.masksToBounds = true
        bioText.layer.cornerRadius = 8
        bioText.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        bioText.textColor = .gray
        bioText.text="Tell the world about yourself"
        bioText.font = .systemFont(ofSize: 16)
        return bioText
    }()
    private let displayNameTextField:UITextField={
        let textField=UITextField()
        textField.translatesAutoresizingMaskIntoConstraints=false
        textField.keyboardType = .default
        textField.leftViewMode = .always
        textField.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.backgroundColor = .secondarySystemFill
        textField.layer.cornerRadius=8
        textField.layer.masksToBounds=true
        textField.attributedPlaceholder=NSAttributedString(string: "Display Name",attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        return textField
    }()
    private let userNameTextField:UITextField={
        let textField=UITextField()
        textField.translatesAutoresizingMaskIntoConstraints=false
        textField.keyboardType = .default
        textField.leftViewMode = .always
        textField.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.backgroundColor = .secondarySystemFill
        textField.layer.cornerRadius=8
        textField.layer.masksToBounds=true
        textField.attributedPlaceholder=NSAttributedString(string: "Username",attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(avatarImage)
        scrollView.addSubview(hintLabel)
        scrollView.addSubview(displayNameTextField)
        scrollView.addSubview(userNameTextField)
        scrollView.addSubview(bioTextView)
        scrollView.addSubview(submitButton)
        configureConstraints()
        submitButton.addTarget(self, action: #selector(didTabSubmit), for: .touchUpInside)
        isModalInPresentation = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(didTapToDismiss)))
        userNameTextField.delegate=self
        displayNameTextField.delegate=self
        bioTextView.delegate=self
        avatarImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(didTapToUpload)))
        bindViews()
    }
    
    @objc private func didTabSubmit(){
        viewModel.uploadAvatar()
        
    }
    @objc private func didUpdateDisplayname(){
        viewModel.displayName=displayNameTextField.text
        viewModel.validateUserProfileForm()
    }
    @objc private func didUpdateUsername(){
        viewModel.username=userNameTextField.text
        viewModel.validateUserProfileForm()

    }
    
    private func bindViews(){
        displayNameTextField.addTarget(self, action: #selector(didUpdateDisplayname), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(didUpdateUsername), for: .editingChanged)
        viewModel.$isFormValid.sink { [weak self] buttonState in
            self?.submitButton.isEnabled = buttonState ?? false
        }
        .store(in:&subscriptions)
        
        viewModel.$isOnBoradingFinished.sink {[weak self] succes in
            if succes {
                self?.dismiss(animated: true)
            }
                
        }.store(in: &subscriptions)
        
    }
    @objc private func didTapToUpload(){
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate=self
        present(picker,animated: true)
    }
    
    @objc private func didTapToDismiss(){
        view.endEditing(true)
    }
    
    func configureConstraints(){
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            hintLabel.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 15),
            hintLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            avatarImage.topAnchor.constraint(equalTo: hintLabel.bottomAnchor,constant: 10),
            avatarImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            avatarImage.heightAnchor.constraint(equalToConstant: 200),
            avatarImage.widthAnchor.constraint(equalToConstant: 200),
            
            displayNameTextField.topAnchor.constraint(equalTo: avatarImage.bottomAnchor,constant: 20),
            displayNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            displayNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            userNameTextField.topAnchor.constraint(equalTo: displayNameTextField.bottomAnchor,constant: 20),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            bioTextView.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor,constant: 20),
            bioTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bioTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bioTextView.heightAnchor.constraint(equalToConstant: 150),
            
            submitButton.topAnchor.constraint(equalTo: bioTextView.bottomAnchor,constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 40),
            submitButton.widthAnchor.constraint(equalToConstant: 200),
            submitButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor,constant: -20)
            
        ])
    }
    

}

extension ProfileFormDataViewController:UITextViewDelegate,UITextFieldDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textView.frame.origin.y-100), animated: true)

        if textView.textColor == .gray{
            textView.textColor = .label
            textView.text = ""
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        viewModel.bio=bioTextView.text
        viewModel.validateUserProfileForm()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        if textView.text.isEmpty{
            textView.textColor = .gray
            textView.text = "Tell the world about yourself"
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)

    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y-100), animated: true)
    }

}

extension ProfileFormDataViewController:PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                if let image = object as? UIImage{
                    DispatchQueue.main.async {
                        self?.avatarImage.image = image
                        self?.viewModel.imageData=image
                        self?.viewModel.validateUserProfileForm()

                    }
                }
            }
        }
        
    }
}


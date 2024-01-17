//
//  UserTableViewCell.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 14.01.2024.
//

import Foundation
import UIKit

protocol UserTableViewCellDelegate:AnyObject{
    func userTableViewCellDidTapProfile()
}
class UserTableViewCell:UITableViewCell{
    static let identifier="UserTableVievCell"
    weak var delegate:UserTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(displaynameLabel)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
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
    private let usernameLabel:UILabel={
        let label=UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = .systemFont(ofSize: 18,weight: .bold)
        return label
    }()
    private let displaynameLabel:UILabel={
        let label=UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = .systemFont(ofSize: 18,weight: .regular)
        return label
    }()
    
}

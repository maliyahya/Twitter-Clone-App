//
//  SearchViewController.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 7.01.2024.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    private let viewmodel=SearchViewViewModel()
    private var subscriptions:Set<AnyCancellable> = []
    private let searchBar:UISearchBar={
       let searchBar=UISearchBar()
        searchBar.placeholder="Search"
        searchBar.translatesAutoresizingMaskIntoConstraints=false
        return searchBar
    }()
    private let profileTableView:UITableView={
        let profileTableView=UITableView()
        profileTableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        profileTableView.translatesAutoresizingMaskIntoConstraints=false
        return profileTableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchBar)
        self.navigationItem.titleView = searchBar
        searchBar.delegate=self
        view.addSubview(profileTableView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        profileTableView.delegate=self
        profileTableView.dataSource=self
        configureConstraints()
        bindViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewmodel.getUserData()
    }
    @objc private func didTapToDismiss(){
        view.endEditing(true)
    }
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)        ]
        )
    }
    private func bindViews(){
        viewmodel.$users.sink { [weak self] _ in
            DispatchQueue.main.async{
                self?.profileTableView.reloadData()
            }
        }.store(in: &subscriptions)
    }
}
extension SearchViewController:UISearchBarDelegate{
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     //   viewmodel.searchUserDatawithUsername(prefix: searchBar.text ?? "")
        viewmodel.searchUserDatawithDisplayname(prefix: searchBar.text ?? "")
        profileTableView.reloadData()
    }
}
extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.users?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell=tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier,for: indexPath) as?
                ProfileTableViewCell else{
            return UITableViewCell()
        } 
        let model=viewmodel.users?[indexPath.row]
        cell.configureUsers(displayname: model?.displayName ?? "", username: model?.username ?? "", avatarPath: model?.avatarPath ?? "")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedUser = viewmodel.users?[indexPath.row] {
            print(selectedUser.id)
            let vc = GuestProfileViewController(currentUserid: selectedUser.id)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

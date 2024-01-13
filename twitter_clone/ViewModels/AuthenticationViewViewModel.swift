

import Foundation
import Firebase
import Combine
import FirebaseAuth

final class AuthenticationViewViewModel: ObservableObject {
    @Published var email:String?
    @Published var password:String?
    @Published var isAuthenticationFormValid:Bool=false
    @Published var user : User?
    @Published var error:String?
    private var subscriptions:Set<AnyCancellable> = []
    func validateRegistrationForm(){
        guard let email=email,let password=password else{
            isAuthenticationFormValid=false
            return
        }
        isAuthenticationFormValid=isValidEmail(email) && isValidPassword(password)
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func isValidPassword(_ password:String) -> Bool {
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)
    }
    func createUser(){
        guard let email=email,
              let password=password else{
            return
        }
        AuthManager.shared.registerUser(with: email, password: password)
            .handleEvents(receiveOutput: { [weak self] user  in
                self?.user = user
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user  in
                self?.createRecord(for: user)
            }.store(in: &subscriptions)

    }
    func createRecord(for user:User){
        DataBaseManager.shared.collectionUsers(add: user)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { state in
                print("Adding user record to database \(state)")
                
            }
            .store(in: &subscriptions)
    }
    func loginuser(){
        guard let email=email,
              let password=password else{
            return
        }
        AuthManager.shared.loginuser(with: email, password: password)
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)

    }
}

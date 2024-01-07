//
//  FirebaseAccountManager.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class FirebaseAccountManager: AccountManagerProtocol {
    var userLogged: Bool {
        return (nil != user)
    }
    
    var currentUser: UserProtocol? {
        return user
    }
    
    private var user: UserProtocol? = nil
    
    var authHandle: AuthStateDidChangeListenerHandle? = nil
    
    func startListen() {
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let updatedUserName = user?.displayName,
               updatedUserName != self?.user?.name {
                self?.user?.name = updatedUserName
            }
            
            if let updatedUserEmail = user?.email,
               updatedUserEmail != self?.user?.email {
                self?.user?.email = updatedUserEmail
            }
        }
    }
    
    func stopListen() {
        if let authHandle = authHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
    }
    
    func logIn(withEmail email: String,
               password: String,
               completionHandler: @escaping (User?, Error?) -> ()) {
        Auth.auth().signIn(withEmail: email,
                           password: password) { [weak self] authResult, error in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let authResult = authResult else {
                completionHandler(nil, AccountManagementError.noAuthResultRetrievedFromServer)
                return
            }
            
            let user = User(name: authResult.user.displayName ?? "",
                            email: authResult.user.email ?? "")
            
            self?.user = user
            
            completionHandler(user, error)
        }
    }
    
    func signIn(withServiceProvider signInServiceProvider: SignInServiceProvider,
                completionHandler: @escaping (User?, Error?) -> ()) {
        requestCredential { [weak self] authCredential, error in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let authCredential = authCredential else {
                completionHandler(nil, AccountManagementError.noCredentialRetrievedFromServer)
                return
            }
            
            self?.signIn(withCredential: authCredential, completionHandler: { user, error in
                completionHandler(user, error)
            })
        }
    }
    
    func signUp(withEmail email: String,
                password: String,
                completionHandler: @escaping (User?, Error?) -> ()) {
        Auth.auth().createUser(withEmail: email,
                               password: password) { authResult, error in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let authResult = authResult else {
                completionHandler(nil, AccountManagementError.noAuthResultRetrievedFromServer)
                return
            }
            
            let user = User(name: authResult.user.displayName ?? "",
                            email: authResult.user.email ?? "")
            
            completionHandler(user, nil)
        }
    }
    
    func logOut(_ completionHandler: (Error?) -> ()) {
        do {
            try Auth.auth().signOut()
        } catch {
            completionHandler(error)
            return
        }
        
        user = nil
        completionHandler(nil)
    }
    
    // MARK: - Private Functions
    
    private func requestCredential(_ completionHandler: @escaping (AuthCredential?, Error?) -> ()) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: AppCoordinator.shared.homeTabBarController) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let user = result?.user
            else {
                completionHandler(nil, AccountManagementError.noUserRetrievedFromServer)
                return
            }
            
            guard let idToken = user.idToken?.tokenString
            else {
                completionHandler(nil, AccountManagementError.noUserIdTokenRetrievedFromServer)
                return
            }
            
            let googleSignInCredential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                   accessToken: user.accessToken.tokenString)
            completionHandler(googleSignInCredential, nil)
        }
    }
    
    func signIn(withCredential credential: AuthCredential,
                completionHandler: @escaping (User?, Error?) -> ()) {
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let authResult = authResult else {
                completionHandler(nil, AccountManagementError.noAuthResultRetrievedFromServer)
                return
            }
            
            let user = User(name: authResult.user.displayName ?? "",
                            email: authResult.user.email ?? "")
            
            self?.user = user
            
            completionHandler(user, error)
        }
    }
}

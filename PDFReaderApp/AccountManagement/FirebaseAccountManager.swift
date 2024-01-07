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
    
    var userKeeper: UserKeeperProtocol
    
    init(userKeeper: UserKeeperProtocol) {
        self.userKeeper = userKeeper
    }
    
    var userLogged: Bool {
        return (nil != currentUser)
    }
    
    var currentUser: UserProtocol? {
        return userKeeper.currentUser
    }
    
    var authHandle: AuthStateDidChangeListenerHandle? = nil
    
    func startListen() {
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard self?.currentUser?.email == user?.email else { return }
            
            if let updatedUserName = user?.displayName,
               updatedUserName != self?.currentUser?.name {
                self?.userKeeper.updateCurrentUserName(withName: updatedUserName)
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
            
            self?.userKeeper.updateCurrentUser(withUser: user)
            
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
        
        userKeeper.updateCurrentUser(withUser: nil)
        completionHandler(nil)
    }
    
    // MARK: - Private Functions
    
    private func requestCredential(_ completionHandler: @escaping (AuthCredential?, Error?) -> ()) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: AppCoordinator.shared.homeTabBarController) { result, error in
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
            
            self?.userKeeper.updateCurrentUser(withUser: user)
            
            completionHandler(user, error)
        }
    }
}

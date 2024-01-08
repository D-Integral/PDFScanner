//
//  AccountViewController.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 28/12/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AccountViewController: UIViewController {
    
    // MARK: - Constants
    
    struct Constants {
        struct Layout {
            static let inset = 15.0
        }
    }
    
    // MARK: - Properties
    
    private let presenter: AccountPresenter?
    private let signUpViewController: UIViewController?
    
    private let greetingLabel = UILabel(frame: .zero)
    private let logoutButton = UIButton(type: .system)
    
    private let emailTextField = UITextField(frame: .zero)
    private let passwordTextField = UITextField(frame: .zero)
    private let logInButton = UIButton(type: .system)
    private let googleSignInButton: GIDSignInButton = GIDSignInButton(frame: .zero)
    private let signUpButton = UIButton(type: .system)
    
    private let activityView = UIActivityIndicatorView(style: .large)
    
    // MARK: - Life Cycle

    init(presenter: AccountPresenter,
         signUpViewController: UIViewController) {
        self.presenter = presenter
        self.signUpViewController = signUpViewController
        
        super.init(nibName: nil,
                   bundle: nil)
        
        self.title = presenter.title
    }
    
    required init?(coder: NSCoder) {
        self.presenter = nil
        self.signUpViewController = nil
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setupGreetingLabel()
        setupLogOutButton()
        
        setupEmailTextField()
        setupPasswordTextField()
        setupLogInButton()
        setupGoogleSignInButton()
        setupSignUpButton()
        
        setupActivityView()
        
        setupConstraints()
        
        setupDismissKeyboardGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.onAppear()
        updateUI(withUser: presenter?.currentUser)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter?.onDisappear()
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Setup
    
    private func setupGreetingLabel() {
        greetingLabel.isHidden = true
        
        view.addSubview(greetingLabel)
    }
    
    private func setupLogOutButton() {
        logoutButton.setTitle(String(localized: "logOut"),
                              for: .normal)
        logoutButton.addTarget(self,
                               action: #selector(logOutAction),
                               for: .touchUpInside)
        logoutButton.isHidden = true
        
        view.addSubview(logoutButton)
    }
    
    private func setupEmailTextField() {
        emailTextField.placeholder = String(localized: "email",
                                            comment: "The e-mail text field placeholder.")
        
        view.addSubview(emailTextField)
    }
    
    private func setupPasswordTextField() {
        passwordTextField.placeholder = String(localized: "password",
                                               comment: "The password text field placeholder.")
        passwordTextField.isSecureTextEntry = true
        
        view.addSubview(passwordTextField)
    }
    
    private func setupLogInButton() {
        logInButton.setTitle(String(localized: "logIn"),
                             for: .normal)
        logInButton.addTarget(self,
                              action: #selector(logInAction),
                              for: .touchUpInside)
        
        view.addSubview(logInButton)
    }
    
    private func setupGoogleSignInButton() {
        googleSignInButton.addTarget(self,
                                     action: #selector(signInViaGoogleAccountAction),
                                     for: .touchUpInside)
        
        view.addSubview(googleSignInButton)
    }
    
    private func setupSignUpButton() {
        signUpButton.setTitle(String(localized: "signUp"),
                              for: .normal)
        signUpButton.addTarget(self,
                               action: #selector(signUpAction),
                               for: .touchUpInside)
        
        view.addSubview(signUpButton)
    }
    
    private func setupActivityView() {
        activityView.center = view.center
        
        view.addSubview(activityView)
    }
    
    private func setupConstraints() {
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: Constants.Layout.inset).isActive = true
        greetingLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -Constants.Layout.inset).isActive = true
        greetingLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: Constants.Layout.inset).isActive = true
        greetingLabel.setContentHuggingPriority(.defaultHigh,
                                                for: .vertical)
        
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor,
                                          constant: Constants.Layout.inset).isActive = true
        logoutButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        logoutButton.setContentHuggingPriority(.defaultHigh,
                                               for: .vertical)
        logoutButton.setContentHuggingPriority(.defaultHigh,
                                               for: .horizontal)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: Constants.Layout.inset).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -Constants.Layout.inset).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: Constants.Layout.inset).isActive = true
        emailTextField.setContentHuggingPriority(.defaultHigh,
                                                 for: .vertical)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor,
                                               constant: Constants.Layout.inset).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                    constant: -Constants.Layout.inset).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: Constants.Layout.inset).isActive = true
        passwordTextField.setContentHuggingPriority(.defaultHigh,
                                                    for: .vertical)
        
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                         constant: Constants.Layout.inset).isActive = true
        logInButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        logInButton.setContentHuggingPriority(.defaultHigh,
                                              for: .vertical)
        logInButton.setContentHuggingPriority(.defaultHigh,
                                              for: .horizontal)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor,
                                          constant: Constants.Layout.inset).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        signUpButton.setContentHuggingPriority(.defaultHigh,
                                               for: .vertical)
        signUpButton.setContentHuggingPriority(.defaultHigh,
                                               for: .horizontal)
        
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        googleSignInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                constant: -Constants.Layout.inset).isActive = true
        googleSignInButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        googleSignInButton.setContentHuggingPriority(.defaultHigh,
                                                     for: .vertical)
        googleSignInButton.setContentHuggingPriority(.defaultHigh,
                                                     for: .horizontal)
    }
    
    private func setupDismissKeyboardGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(dismissKeyboardAction))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Private Functions
    
    private func updateUI(withUser user: UserProtocol?) {
        title = presenter?.title
        
        let userLogged = presenter?.userLogged ?? false
        
        updateGreetingLabel(withUser: user)
        
        for loggedInView in [greetingLabel,
                             logoutButton] {
            loggedInView.isHidden = !userLogged
        }
        
        for loggedOutView in [emailTextField,
                              passwordTextField,
                              logInButton,
                              googleSignInButton,
                              signUpButton] {
            loggedOutView.isHidden = userLogged
        }
    }
    
    private func cleanTextFields() {
        emailTextField.text = nil
        passwordTextField.text = nil
    }
    
    private func updateGreetingLabel(withUser user: UserProtocol?) {
        if let user = user {
            let userNameToDisplay = !user.name.isEmpty ? user.name : user.email
            greetingLabel.text = String(localized: "Hello \(userNameToDisplay)!")
        } else {
            greetingLabel.text = nil
        }
    }
    
    private func errorAlert(withMessage message: String) -> UIAlertController {
        let alert = UIAlertController(title: String(localized: "error"),
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        
        return alert
    }
    
    private func dismissKeyboard() {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @objc private func logInAction() {
        dismissKeyboard()
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        activityView.startAnimating()
        
        presenter?.logIn(withEmail: email,
                         password: password,
                         completionHandler: { [weak self] user, error in
            guard let self = self else {
                return
            }
            
            self.activityView.stopAnimating()
            
            if let error = error {
                self.present(self.errorAlert(withMessage: error.localizedDescription),
                             animated: true,
                             completion: nil)
                return
            }
            
            self.cleanTextFields()
            self.updateUI(withUser: user)
        })
    }
    
    @objc private func logOutAction() {
        presenter?.logOut({ [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.present(self.errorAlert(withMessage: error.localizedDescription),
                             animated: true,
                             completion: nil)
            }
            
            self.updateUI(withUser: nil)
        })
    }
    
    @objc private func signUpAction() {
        dismissKeyboard()
        
        guard let signUpViewController = signUpViewController else { return }
        
        navigationController?.present(signUpViewController,
                                      animated: true)
    }
    
    @objc private func dismissKeyboardAction() {
        dismissKeyboard()
    }
    
    @objc private func signInViaGoogleAccountAction() {
        signInViaGoogleAccount()
    }
    
    // MARK: - Sign In via Google Account
    
    private func signInViaGoogleAccount() {
        activityView.startAnimating()
        
        presenter?.signIn(withServiceProvider: .Google,
                         completionHandler: { [weak self] user, error in
            guard let self = self else { return }
            
            self.activityView.stopAnimating()
            
            if let error = error {
                self.present(self.errorAlert(withMessage: error.localizedDescription),
                             animated: true,
                             completion: nil)
            }
            
            self.cleanTextFields()
            self.updateUI(withUser: user)
        })
    }
}

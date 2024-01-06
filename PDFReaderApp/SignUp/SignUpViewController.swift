//
//  SignUpViewController.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 06/01/2024.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    // MARK: - Constants
    
    struct Constants {
        struct Layout {
            static let inset = 15.0
        }
    }
    
    // MARK: - Properties
    
    private let presenter: SignUpPresenter?
    
    private let emailTextField = UITextField(frame: .zero)
    private let passwordTextField = UITextField(frame: .zero)
    private let signUpButton = UIButton(type: .system)
    
    private let activityView = UIActivityIndicatorView(style: .large)
    
    // MARK: - Life Cycle

    init(presenter: SignUpPresenter?) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.presenter = nil
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupEmailTextField()
        setupPasswordTextField()
        setupSignUpButton()
        setupActivityView()
        setupConstraints()
    }
    
    // MARK: - Setup
    
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
    
    private func setupSignUpButton() {
        signUpButton.setTitle(String(localized: "signUp"),
                              for: .normal)
        signUpButton.titleLabel?.textAlignment = .center
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
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        signUpButton.setContentHuggingPriority(.defaultHigh,
                                               for: .vertical)
        signUpButton.setContentHuggingPriority(.defaultHigh,
                                               for: .horizontal)
    }
    
    // MARK: - Actions
    
    @objc private func signUpAction() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        activityView.startAnimating()
        
        presenter?.signUp(withEmail: email,
                          password: password,
                          completionHandler: { [weak self] error, user in
            guard let self = self else { return }
            
            self.activityView.stopAnimating()
            
            if let error = error {
                self.present(self.errorAlert(withMessage: error.localizedDescription),
                             animated: true,
                             completion: nil)
            }
            
            self.dismiss(animated: true)
        })
    }
    
    // MARK: - Private Methods
    
    private func errorAlert(withMessage message: String) -> UIAlertController {
        let alert = UIAlertController(title: String(localized: "error"),
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        
        return alert
    }
}

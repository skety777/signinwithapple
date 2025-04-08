//
//  ViewController.swift
//  AppleSignIn-Swift
//
//  Created by Sanket Vaghela on 08/04/25.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {

        private let viewModel = AuthViewModel()
        
        private lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
            let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
            button.cornerRadius = 8
            button.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
            return button
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            viewModel.delegate = self
        }
        
        private func setupUI() {
            view.backgroundColor = .systemBackground
            
            appleSignInButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(appleSignInButton)
            
            NSLayoutConstraint.activate([
                appleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                appleSignInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                appleSignInButton.widthAnchor.constraint(equalToConstant: 280),
                appleSignInButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        @objc private func handleAppleIdRequest() {
            viewModel.handleAppleIdRequest(controller: self)
        }
    }

extension ViewController: AuthViewModelDelegate {
        func didSignInWithApple(user: User) {
            // Handle successful sign-in
            print("User signed in: \(user)")
            
            let alert = UIAlertController(title: "Success",
                                        message: "Welcome \(user.firstName)!",
                                        preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
        
        func didFailWithError(error: Error) {
            print("Error: \(error.localizedDescription)")
            
            let alert = UIAlertController(title: "Error",
                                        message: error.localizedDescription,
                                        preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    extension ViewController: ASAuthorizationControllerPresentationContextProviding {
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return self.view.window!
        }
    }

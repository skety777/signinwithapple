//
//  AuthViewModel.swift
//  AppleSignIn-Swift
//
//  Created by Sanket Vaghela on 08/04/25.
//

import Foundation
import AuthenticationServices

protocol AuthViewModelDelegate: AnyObject {
    func didSignInWithApple(user: User)
    func didFailWithError(error: Error)
}
import Foundation
import AuthenticationServices

class AuthViewModel: NSObject {
    weak var delegate: AuthViewModelDelegate?
    
    func handleAppleIdRequest(controller: UIViewController) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = controller as? ASAuthorizationControllerPresentationContextProviding
        authorizationController.performRequests()
    }
    
    private func createUser(from authorization: ASAuthorization) -> User? {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return nil
        }
        
        let userId = appleIDCredential.user
        let firstName = appleIDCredential.fullName?.givenName ?? ""
        let lastName = appleIDCredential.fullName?.familyName ?? ""
        let email = appleIDCredential.email ?? ""
        
        return User(id: userId, firstName: firstName, lastName: lastName, email: email)
    }
    
    private func handleAuthorizationError(_ error: Error) {
        var errorMessage = "Authorization failed"
        
        if let authError = error as? ASAuthorizationError {
            switch authError.code {
            case .canceled:
                errorMessage = "User canceled authorization"
            case .failed:
                errorMessage = "Authorization failed"
            case .invalidResponse:
                errorMessage = "Invalid authorization response"
            case .notHandled:
                errorMessage = "Authorization not handled"
            case .unknown:
                errorMessage = "Unknown authorization error"
            @unknown default:
                errorMessage = "Unknown authorization error"
            }
        }
        
        let error = NSError(domain: "AuthError", code: (error as NSError).code,
                          userInfo: [NSLocalizedDescriptionKey: errorMessage])
        delegate?.didFailWithError(error: error)
    }
}

extension AuthViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let user = createUser(from: authorization) {
            delegate?.didSignInWithApple(user: user)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        handleAuthorizationError(error)
    }
}

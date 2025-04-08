//
//  AppDelegate.swift
//  AppleSignIn-Swift
//
//  Created by Sanket Vaghela on 08/04/25.
//

import UIKit
import AuthenticationServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        checkAppleSignInCredentialState()
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        checkAppleSignInCredentialState()
    }

    private func checkAppleSignInCredentialState() {
        guard let userID = KeychainManager.shared.getAppleUserID() else {
            showLoginScreen()
            return
        }
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userID) { credentialState, error in
            DispatchQueue.main.async {
                switch credentialState {
                case .authorized:
                    self.showMainScreen()
                case .revoked, .notFound:
                    self.showLoginScreen()
                default:
                    break
                }
            }
        }
    }

    // MARK: - Screen Navigation Methods
    
    private func showLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        window?.rootViewController = UINavigationController(rootViewController: loginVC)
        window?.makeKeyAndVisible()
    }
    
    private func showMainScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        window?.rootViewController = UINavigationController(rootViewController: mainVC)
        window?.makeKeyAndVisible()
    }
}

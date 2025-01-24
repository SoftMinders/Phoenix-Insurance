//
//  SplashScreenViewController.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 25/01/25.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // Simulate splash screen delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.moveToMainScreen()
        }
    }

    private func moveToMainScreen() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let loginViewController = LoginViewController()
            
            // Add transition animation
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = loginViewController
            }, completion: nil)
        }
    }
}


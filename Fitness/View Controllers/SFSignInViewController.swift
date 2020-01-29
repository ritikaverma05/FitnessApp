//
//  SignInViewController.swift
//  Fitness
//
//  Created by RITIKA VERMA on 26/01/20.
//  Copyright © 2020 RITIKA VERMA. All rights reserved.
//

import UIKit
import AuthenticationServices
import GoogleSignIn

class SFSignInViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate  {

    @IBOutlet weak var signInButton: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK:- Google Delegates
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            self.showError(error: "The user has not signed in before or they have since signed out.", duration: 2.0)
        } else {
            self.showError(error: error.localizedDescription, duration: 2.0)
          print("\(error.localizedDescription)")
        }
        return
      }
        
//      let userId = user.userID                  // For client-side use only!
      let idToken = user.authentication.idToken // Safe to send to the server
      let fullName = user.profile.name
      let email = user.profile.email
      
        
        let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        
        let homeVC = UIStoryboard(name: SFConstant.Storyboards.diet, bundle: nil).instantiateViewController(withIdentifier: SFConstant.ViewController.dietPlanViewController) as! SFDietPlanViewController
        UserDefaults.standard.set(idToken, forKey: "user_token")
        UserDefaults.standard.set(email, forKey: "user_email")
        UserDefaults.standard.set(fullName, forKey: "user_name")
        UIView.transition(with: keyWindow!, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            keyWindow?.rootViewController = homeVC
        }, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        self.showError(error: error.localizedDescription, duration: 2.0)
       }
}

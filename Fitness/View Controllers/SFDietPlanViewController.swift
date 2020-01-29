//
//  SFDietPlanViewController.swift
//  Fitness
//
//  Created by RITIKA VERMA on 26/01/20.
//  Copyright © 2020 RITIKA VERMA. All rights reserved.
//

import UIKit
import GoogleSignIn
import Razorpay
import MessageUI

class SFDietPlanViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RazorpayPaymentCompletionProtocol, MFMailComposeViewControllerDelegate {
    
    var aimg = [ UIImage(named: "one")!, UIImage(named: "two")!, UIImage(named: "three")!, UIImage(named: "four")!, UIImage(named: "five")!, UIImage(named: "six")!]
    var aLabel = ["500", "800", "1000", "1200", "1500", "1700"]
    var name = ["First Plan", "Second Plan", "Third Plan", "Fourth Plan" , "Fifth Plan", "Six Plan"]
    var razorpay: Razorpay!
    var selectedPlan = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: SFConstant.Nibs.planCollectionViewCell, bundle: nil)
        DietPlanBanners.register(nib, forCellWithReuseIdentifier: SFConstant.Nibs.planCollectionViewCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    

    @IBAction func didTapSignOut(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()

        let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        
        let homeVC = UIStoryboard(name: SFConstant.Storyboards.signIn, bundle: nil).instantiateViewController(withIdentifier: SFConstant.ViewController.signInViewController) as! SFSignInViewController
        
        UIView.transition(with: keyWindow!, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            let defaults = UserDefaults.standard
            defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            keyWindow?.rootViewController = homeVC
            
        }, completion: nil)
    }
    
    //MARK:- Collection view datasource and delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aLabel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SFConstant.Nibs.planCollectionViewCell, for: indexPath) as! CollectionViewCell
              cell.planImage.image = aimg[indexPath.row]
              cell.planCost.text = "₹" + aLabel[indexPath.row]
              return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 374, height: 722)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPlan = name[indexPath.row]
        let alert = UIAlertController(title: "Buy this plan", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Pay using Razporpay", style: .default, handler: { (_) in
            self.razorpay = Razorpay.initWithKey(SFConstant.razorpaykey, andDelegate: self)
                   let option = [
                    "amount" : Int(self.aLabel[indexPath.row])! * 100,
                       "name" : "Fitness Lover",
                       "description" : self.name[indexPath.row],
                       "prefill" : [
                           "email": UserDefaults.standard.string(forKey: "user_email"),
                           "name" : UserDefaults.standard.string(forKey: "user_name")
                       ],
                       "theme": [
                           "color" : "AA2526"]
                       ] as [String : Any]
            self.razorpay.open(option)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBOutlet weak var DietPlanBanners: UICollectionView!
    
    //MARK:- Razopay success and failure
    
    func onPaymentSuccess(_ payment_id: String) {
        self.showProgressHUD()
        if MFMailComposeViewController.canSendMail() {
            self.hideHUD()
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([UserDefaults.standard.string(forKey: "user_email")!])
            mail.setMessageBody("You have activated the " + selectedPlan, isHTML: true)
            present(mail, animated: true)
        } else {
            self.showError(error: "Mail services are not available", duration: 2.0)
        }
    }
    
    func onPaymentError(_ code: Int32, description str: String) {
        self.showError(error: str)
    }
    
    //MARK:- MailComposer delegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    

}

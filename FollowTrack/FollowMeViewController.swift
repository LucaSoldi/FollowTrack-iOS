//
//  FollowMeViewController.swift
//  FollowTrack
//
//  Created by Luca Soldi on 10/02/17.
//  Copyright © 2017 Luca Soldi. All rights reserved.
//

import UIKit

import SwiftQRCode
import SkyFloatingLabelTextField

class FollowMeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var QRImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var whatsappShareButton: UIButton!
    @IBOutlet weak var telegramShareButton: UIButton!
    private var tokenTrack : String!
    private var passkey : String!
    private var iv : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        RestApi.sharedInstance.getTokenTrack(completion: {success, token in
            if (success) {
                self.tokenTrack = token
                self.passkey = String.randomString(length: 16)
                self.iv = String.randomString(length: 16)
                //print("\(self.tokenTrack!) \(self.passkey!) \(self.iv!)")
                self.QRImageView.image = QRCode.generateImage("\(self.tokenTrack!)\(self.passkey!)\(self.iv!)", avatarImage: #imageLiteral(resourceName: "logo_flag"), avatarScale: 0.1)
            }
            else {
                self.present(warningAlertViewController(title: "Error", text: "There was an error in the connection with server, retry again"), animated: true, completion: nil)
            }
        })
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        backButton.setBackgroundImage(Graphics.imageOfBackimage(), for: UIControlState())
        whatsappShareButton.setBackgroundImage(Graphics.imageOfWhatsappshareicon(), for: UIControlState())
        telegramShareButton.setBackgroundImage(Graphics.imageOfTelegramshareicon(), for: UIControlState())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == emailTextField) {
            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
            if (text.length > 0) {
                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                    if (!isValidEmail(text as String)) {
                        floatingLabelTextField.errorMessage = "Invalid email"
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        }
        
        return true
    }
    

    @IBAction func inviteFriendByEmailPressed(_ sender: UIButton) {
        
        RestApi.sharedInstance.inviteFriendByMail(email: emailTextField.text!, tokenTrack: tokenTrack, completion: {success in
        
            if(success) {
                self.present(warningAlertViewController(title: "Success", text: "Your friend has been invited correctly"), animated: true, completion: nil)
            }
            else {
                self.present(warningAlertViewController(title: "Error", text: "There was an error in the connection with server, retry again"), animated: true, completion: nil)
            }
        
        })
        
    }
    
    @IBAction func whatsappShareButtonPressed(_ sender: AnyObject) {
        
        let urlString = "Hello Friends, Sharing some data here... !"
        let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url  = URL(string: "whatsapp://send?text=\(urlStringEncoded!)")
        
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, completionHandler: nil)
        }
        
    }
    @IBAction func telegramShareButtonPressed(_ sender: AnyObject) {
        
        let urlString = "Hello Friends, Sharing some data here... !"
        let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url  = URL(string: "tg://msg?text=\(urlStringEncoded!)")
        
        if UIApplication.shared.canOpenURL(url!) {
             UIApplication.shared.open(url!, completionHandler: nil)
        }
        
    }
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            //showFollowMap
        if segue.identifier == "showFollowMap" {
            let nextScene =  segue.destination as! FollowMapViewController
            nextScene.leader = true
            nextScene.trackID = tokenTrack
            nextScene.passkey = passkey
            nextScene.iv = iv
        }
     }

}

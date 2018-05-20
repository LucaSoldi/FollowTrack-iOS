//
//  ChatViewController.swift
//  FollowTrack
//
//  Created by Luca Soldi on 17/02/17.
//  Copyright © 2017 Luca Soldi. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let closeButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.done, target: self, action: #selector(ChatViewController.dismissView))
        self.navigationItem.rightBarButtonItem = closeButton
        
        self.tableView.estimatedRowHeight = 102
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var identifier: String!
        var image: UIImage!
        var text: String!
        if (indexPath.row % 2 == 0) {
            identifier = "leftChatCell"
            image = Graphics.imageOfLogo()
            text = "Test test Test test Test test Test testTest testTest testTest testv Test test Test test Test test Test test Test testTest testTest testTest testv Test test Test test Test test Test test Test testTest testTest testTest testv Test test  Test test Test test Test test Test testTest testTest testTest testv Test test"
        }
        else {
            identifier = "rightChatCell"
            image = Graphics.imageOfSettings_icon()
            text = "Test test Test test Test test Test testTest"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ChatTableViewCell
        
        cell.userImage.image = image
        cell.chatLabel.text = text
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    // MARK: - Keyboard
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

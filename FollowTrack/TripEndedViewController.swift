//
//  TripEndedViewController.swift
//  FollowTrack
//
//  Created by Luca Soldi on 13/02/17.
//  Copyright © 2017 Luca Soldi. All rights reserved.
//

import UIKit


enum TripEndedCommand {
    case Abort
    case Save
}

protocol TripEndedDelegate: class {
    func didDismissWithCommand(sender: TripEndedViewController, command: TripEndedCommand)
}

class TripEndedViewController: UIViewController {

    weak var delegate:TripEndedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveTheTripButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.didDismissWithCommand(sender: self, command: TripEndedCommand.Save)
        }
    }
    
    
    @IBAction func deleteTheTripButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Attention", message: "Are you sure to delete the trip?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
            self.delegate?.didDismissWithCommand(sender: self, command: TripEndedCommand.Abort)
            self.dismiss(animated: true)
        }
        )
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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

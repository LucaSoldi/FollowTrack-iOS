//
//  FollowerViewController.swift
//  FollowTrack
//
//  Created by Luca Soldi on 10/02/17.
//  Copyright © 2017 Luca Soldi. All rights reserved.
//

import UIKit
import SwiftQRCode
import ALLoadingView

class FollowerViewController: UIViewController {

    let scanner = QRCode()
    @IBOutlet weak var scannerView: UIView!
    @IBOutlet var successView: UIView!
    private var tokenTrack : String!
    private var passkey : String!
    private var iv : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ALLoadingView.manager.showLoadingView(ofType: .basic)
        
        scanner.prepareScan(scannerView) { (stringValue) -> () in
    
            self.tokenTrack = stringValue.substring(with: 0..<32)
            self.passkey = stringValue.substring(with: 32..<48)
            self.iv = stringValue.substring(with: 48..<64)

            self.scanner.stopScan()
            self.scanner.removeAllLayers()
            self.successView.isHidden = false
        }
        scanner.scanFrame = scannerView.bounds
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.successView.isHidden = true
        scanner.startScan()
        ALLoadingView.manager.hideLoadingView(withDelay: 0.0)

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //showFollowMap
        if segue.identifier == "showFollowMap" {
            let nextScene =  segue.destination as! FollowMapViewController
            nextScene.leader = false
            nextScene.trackID = tokenTrack
            nextScene.passkey = passkey
            nextScene.iv = iv
        }
    }

}

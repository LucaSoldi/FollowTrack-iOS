//
//  ViewController.swift
//  FollowTrack
//
//  Created by Luca Soldi on 09/02/17.
//  Copyright © 2017 Luca Soldi. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


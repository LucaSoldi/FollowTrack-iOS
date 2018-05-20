//
//  Common.swift
//  Farmer Messenger
//
//  Created by Luca Soldi on 02/02/17.
//  Copyright © 2017 Luca Soldi. All rights reserved.
//

import Foundation
import UIKit

public func warningAlertViewController(title: String, text: String) -> UIAlertController {
    
    let alertController = UIAlertController(title: title, message: text, preferredStyle: UIAlertControllerStyle.alert)
    let cancelAction = UIAlertAction(title: "OK",
                                     style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    return alertController
    
}



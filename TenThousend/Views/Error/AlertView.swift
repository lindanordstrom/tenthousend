//
//  AlertView.swift
//  TenThousend
//
//  Created by Linda on 2018-03-30.
//  Copyright © 2018 YasLin. All rights reserved.
//

import Foundation
import UIKit

class AlertHandler {
    static func showError(viewController: UIViewController?, title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }
}


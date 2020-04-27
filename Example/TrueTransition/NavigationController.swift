//
//  NavigationController.swift
//  TrueTransitionExample
//
//  Created by Артeмий Шлесберг on 28/04/2020.
//  Copyright © 2020 Shlesberg. All rights reserved.
//

import Foundation
import UIKit
import TrueTransition

class NavigationController: UINavigationController {
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let isFirstController = self.viewControllers.count == 1
        if isFirstController {
            showPopingErrorAlert()
        }
        return super.popViewController(animated: animated)
    }
    
    private func showPopingErrorAlert() {
        let alertTRansition = AlertTransition(message: "This controller is not pushed by any other controller")
        alertTRansition.perform(on: self)
    }
}

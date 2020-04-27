//
// Created by Артeмий Шлесберг on 2019-02-07.
// Copyright (c) 2019 Collider. All rights reserved.
//

import Foundation
import UIKit

public protocol Transition {
    func perform(on vc: UIViewController)
}

public class PushTransition: Transition {

    private var controllerToPush: () -> UIViewController
    private var animated: Bool
    
    public init(controllerToPush: @escaping () -> UIViewController, animated: Bool = true)  {
        self.controllerToPush = controllerToPush
        self.animated = animated
    }

    public func perform(on vc: UIViewController) {
        vc.navigationController?.pushViewController(controllerToPush(), animated: animated)
    }
}

open class PresentTransition: Transition {

    private var controllerToPresent: () -> UIViewController
    private var animated: Bool

    public init(controllerToPresent: @escaping () -> UIViewController, animated: Bool = true)  {
        self.controllerToPresent = controllerToPresent
        self.animated = animated
    }

    public func perform(on vc: UIViewController) {
        vc.present(controllerToPresent(), animated: animated)
    }
}

open class PopTransition: Transition {
    
    private var animated: Bool
    
    public init(animated: Bool = true) {
        self.animated = animated
    }
    
    public func perform(on vc: UIViewController) {
        vc.navigationController?.popViewController(animated: animated)
    }

}


open class DismissTransition: Transition {
    
    private var animated: Bool
    
    public init(animated: Bool = true) {
        self.animated = animated
    }

    public func perform(on viewController: UIViewController) {
        viewController.dismiss(animated: animated)
    }
}

open class  NewWindowRootControllerTransition: Transition {
    
    private let leadingTo: () -> (UIViewController)
    private var animated: Bool
    
    public init(leadingTo: @escaping () -> (UIViewController), animated: Bool = true) {
        self.leadingTo = leadingTo
        self.animated = animated
    }
    
    public func perform(on viewController: UIViewController) {
        let vc = leadingTo()
        viewController.present(vc, animated: animated) {
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }
}

open class AlertTransition: Transition {
    
    private var title: String
    private var message: String
    private var okActionTitle: String
    private var okHandler: ((UIAlertAction) -> ())?
    
    ///Default values are for error alert.
    public init(title: String = "Error", message: String, okActionTitle: String = "Ok", okHandler: ((UIAlertAction) -> ())? = nil) {
        self.title = title
        self.message = message
        self.okActionTitle = okActionTitle
        self.okHandler = okHandler
    }
    
    public func perform(on vc: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: okActionTitle, style: .default, handler: okHandler))
        vc.present(alertController, animated: true, completion: nil)
    }
    
}

class EmptyTransition: Transition {
    func perform(on vc: UIViewController) {}
    
    public init() {}
}

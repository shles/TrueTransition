//
// Created by Артeмий Шлесберг on 2019-02-07.
// Copyright (c) 2019 Collider. All rights reserved.
//

import Foundation
import UIKit

public protocol Transition {
    func perform(on vc: UIViewController)
}


//TODO: make options to present non animated or smth

public class PushTransition: Transition {

    private var controllerToPush: () -> UIViewController

    public init(controllerToPush: @escaping () -> UIViewController)  {
        self.controllerToPush = controllerToPush
    }

    public func perform(on vc: UIViewController) {
        vc.navigationController?.pushViewController(controllerToPush(), animated: true)
    }
}

open class PresentTransition: Transition {

    private var controllerToPresent: () -> UIViewController

    public init(controllerToPresent: @escaping () -> UIViewController)  {
        self.controllerToPresent = controllerToPresent
    }

    public func perform(on vc: UIViewController) {
        vc.present(controllerToPresent(), animated: true)
    }
}

open class PresentTransitionWithoutAnimation: Transition {

    private var controllerToPresent: () -> UIViewController

    public init(controllerToPresent: @escaping () -> UIViewController)  {
        self.controllerToPresent = controllerToPresent
    }

    public func perform(on vc: UIViewController) {
        vc.present(controllerToPresent(), animated: false)
    }
}

open class PopTransition: Transition {
    
    public func perform(on vc: UIViewController) {
        vc.navigationController?.popViewController(animated: true)
    }
    
    public init() {}
}


open class DismissTransition: Transition {
    
    public func perform(on viewController: UIViewController) {
        viewController.dismiss(animated: true)
    }
    
    public init() {}
}

open class  NewWindowRootControllerTransition: Transition {
    private let leadingTo: () -> (UIViewController)
    
    public init(leadingTo: @escaping () -> (UIViewController)) {
        self.leadingTo = leadingTo
    }
    
    public func perform(on viewController: UIViewController) {
        let vc = leadingTo()
        viewController.present(vc, animated: true) {
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

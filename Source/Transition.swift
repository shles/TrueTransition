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

open class PopTransition: Transition {
    public func perform(on vc: UIViewController) {
        vc.navigationController?.popViewController(animated: true)
    }
}


open class DismissTransition: Transition {
    public func perform(on viewController: UIViewController) {
        viewController.dismiss(animated: true)
    }
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

open class CardsTransition: NSObject, Transition {
    
    private var controllerToPresent: () -> (UIViewController & CardContentControllerProtocol)
    
    public init(controllerToPresent: @escaping () -> (UIViewController & CardContentControllerProtocol))  {
        self.controllerToPresent = controllerToPresent
    }
    
    public func perform(on vc: UIViewController) {
        
        let cardViewController = CardsViewController(nibName: "CardsViewController",
                                                     bundle: Bundle(for: self.classForCoder))
        let controller = controllerToPresent()
        controller.modalPresentationStyle = .overCurrentContext
//        UIApplication.shared.keyWindow?.makeSnapshot()
        cardViewController.backingImage = UIApplication.shared.keyWindow?.makeSnapshot()
        cardViewController.controllerToPresent = controller
        
        vc.present(cardViewController, animated: false)
    }
}

open class DefaultErrorAlertTransition: Transition {
    
    private var title: String
    private var message: String
    private var okActionTitle: String

    public init(title: String = "Error", message: String, okActionTitle: String = "Ok") {
        self.title = title
        self.message = message
        self.okActionTitle = okActionTitle
    }
    
    public func perform(on vc: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: okActionTitle, style: .default, handler: nil))
        vc.present(alertController, animated: true, completion: nil)
    }
    
}



//
// Created by Артeмий Шлесберг on 2019-02-07.
// Copyright (c) 2019 Collider. All rights reserved.
//

import Foundation
import UIKit

public protocol Transition {
    func perform(on vc: UIViewController)
}

public protocol CustomAnimation {
    func perform(on vc: UIViewController,
                 durationIn: Double,
                 velocityIn: CGFloat,
                 dampingIn: CGFloat,
                 durationOut: Double,
                 velocityOut: CGFloat,
                 dampingOut: CGFloat)
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
    
    var durationIn: Double
    var velocityIn: CGFloat
    var dampingIn: CGFloat
    var durationOut: Double
    var velocityOut: CGFloat
    var dampingOut: CGFloat
    
    
    private var controllerToPresent: () -> (UIViewController & CardContentControllerProtocol)
    
    public init(controllerToPresent: @escaping () -> (UIViewController & CardContentControllerProtocol),
                durationIn: Double = 0.3,
                velocityIn: CGFloat = 0.1,
                dampingIn: CGFloat = 0.8,
                durationOut: Double = 0.3,
                velocityOut: CGFloat = 0.1,
                dampingOut: CGFloat = 0.8)  {
        
        self.durationIn = durationIn
        self.velocityIn = velocityIn
        self.dampingIn = dampingIn
        self.durationOut = durationOut
        self.velocityOut = velocityOut
        self.dampingOut = dampingOut
        
        self.controllerToPresent = controllerToPresent
    }
    
    public func perform(on vc: UIViewController) {
        
        let cardViewController = CardsViewController(nibName: "CardsViewController",
                                                     bundle: Bundle(for: self.classForCoder))
        let controller = controllerToPresent()
        controller.modalPresentationStyle = .overCurrentContext
        cardViewController.backingImage = UIApplication.shared.keyWindow?.makeSnapshot()
        cardViewController.controllerToPresent = controller
        
        //animationParameters
        cardViewController.durationIn = durationIn
        cardViewController.velocityIn = velocityIn
        cardViewController.dampingIn = dampingIn
        
        cardViewController.durationOut = durationOut
        cardViewController.velocityOut = velocityOut
        cardViewController.dampingOut = dampingOut
        
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



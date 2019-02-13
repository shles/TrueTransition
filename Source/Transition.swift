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

open class PushTransition: Transition {

    private var controllerToPush: () -> UIViewController

    init(controllerToPush: @escaping () -> UIViewController)  {
        self.controllerToPush = controllerToPush
    }

    public func perform(on vc: UIViewController) {
        vc.navigationController?.pushViewController(controllerToPush(), animated: true)
    }
}

open class PresentTransition: Transition {

    private var controllerToPresent: () -> UIViewController

    init(controllerToPresent: @escaping () -> UIViewController)  {
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
    
    init(leadingTo: @escaping () -> (UIViewController)) {
        self.leadingTo = leadingTo
    }
    
    public func perform(on viewController: UIViewController) {
        let vc = leadingTo()
        viewController.present(vc, animated: true) {
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
        
    }
}



//
//  CardsViewController.swift
//  AppleMusicTransition
//
//  Created by Alexandr Booharin on 04/08/2019.
//  Copyright © 2019 Alexandr Booharin. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, CardsTransitionProtocol {
    
    @IBOutlet weak var backingImageBottomInset: NSLayoutConstraint!
    @IBOutlet weak var backingImageTopInset: NSLayoutConstraint!
    @IBOutlet weak var backingImageLeadingInset: NSLayoutConstraint!
    @IBOutlet weak var backingImageTrailingInset: NSLayoutConstraint!
    @IBOutlet weak var backingImageView: UIImageView!
    @IBOutlet weak var dimmerLayerView: UIView!
    
    //TODO: make configurable in transition
    var backingImage: UIImage?
    let cardCornerRadius: CGFloat = 10
    
    let primaryDuration = 0.3
    let backingImageEdgeInset: CGFloat = 15.0
    var isPresented = false
    
    var controllerToPresent: (UIViewController & CardContentControllerProtocol)
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        modalPresentationCapturesStatusBarAppearance = true //allow this VC to control the status bar appearance
        modalPresentationStyle = .overFullScreen //dont dismiss the presenting view controller when presented
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        backingImageView.image = backingImage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isPresented == false {
            animateBackingImageIn()
            isPresented = true
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

//MARK: - background image animation
extension CardsViewController {
    
    private func configureBackingImageInPosition(presenting: Bool) {
        let edgeInset: CGFloat = presenting ? backingImageEdgeInset : 0
        let dimmerAlpha: CGFloat = presenting ? 0.3 : 0
        let cornerRadius: CGFloat = presenting ? cardCornerRadius : 0
        
        backingImageLeadingInset.constant = edgeInset
        backingImageTrailingInset.constant = edgeInset
        let aspectRatio = backingImageView.frame.height / backingImageView.frame.width
        backingImageTopInset.constant = edgeInset * aspectRatio
        backingImageBottomInset.constant = edgeInset * aspectRatio
        dimmerLayerView.alpha = dimmerAlpha
        backingImageView.layer.cornerRadius = cornerRadius
    }
    
    private func animateOut(presenting: Bool, completion: @escaping ((Bool) -> ())) {
        UIView.animate(withDuration: primaryDuration, animations: {
            self.configureBackingImageInPosition(presenting: presenting)
            self.view.layoutIfNeeded()
        }, completion: { finished in
            completion(finished)
        })
    }
    
    private func animateIn(presenting: Bool) {
        UIView.animate(withDuration: primaryDuration, animations: {
            self.configureBackingImageInPosition(presenting: presenting)
            self.view.layoutIfNeeded()
            
            self.controllerToPresent.delegate = self
            self.present(self.controllerToPresent, animated: true)
        })
    }
    
    func animateBackingImageIn() {
        animateIn(presenting: true)
    }
    
    func animateBackingImageOut() {
        animateOut(presenting: false) { _ in
            self.dismiss(animated: false)
        }
    }
    
    func goBack() {
        animateBackingImageOut()
    }
}

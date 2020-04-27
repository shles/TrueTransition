//
//  ViewController.swift
//  TrueTransition
//
//  Created by Артeмий Шлесберг on 11/02/2019.
//  Copyright © 2019 Shlesberg. All rights reserved.
//

import UIKit
import TrueTransition

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var transitions: [Transition] = []
    
    private lazy var navigationControllerFactory: () -> UIViewController = {
        self.storyboard!.instantiateInitialViewController()!
    }
    private lazy var viewControllerFactory: () -> UIViewController = {
        self.storyboard!.instantiateViewController(withIdentifier: "viewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        createTransitions()
    }
    
    func createTransitions() {
        transitions = [
            PresentTransition(controllerToPresent: navigationControllerFactory),
            PushTransition(controllerToPush: viewControllerFactory),
            PopTransition(),
            DismissTransition(),
            AlertTransition(title: "Alert", message: "This is alert", okActionTitle: "Dismiss", okHandler: nil),
            EmptyTransition()
        ]
    }
    
    private func setupViews() {
        //Clear bottom of the table from the separators
        self.tableView.tableFooterView = UIView()
    }
    
}
extension ViewController: UITableViewDelegate {
    
    private func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transition", for: indexPath) as UITableViewCell
        cell.textLabel?.text = String(describing: type(of: transitions[indexPath.row]))
        return cell
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        transitions[indexPath.row].perform(on: self)
    }

}

extension ViewController {
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if self.presentingViewController != nil {
            super.dismiss(animated: flag, completion: completion)
        } else {
            showDismissingErrorAlert()
        }
    }
    
    private func showDismissingErrorAlert() {
        let alertTRansition = AlertTransition(message: "This controller is not presented by any other controller")
        alertTRansition.perform(on: self)
    }
    
}

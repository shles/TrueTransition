//
//  CardsTransitionProtocol.swift
//  AppleMusicTransition
//
//  Created by Alexandr Booharin on 04/08/2019.
//  Copyright © 2019 Alexandr Booharin. All rights reserved.
//

public protocol CardsTransitionProtocol: class {
    func goBack()
}

public protocol CardContentControllerProtocol: class {
    var delegate: CardsTransitionProtocol? {get set}
}

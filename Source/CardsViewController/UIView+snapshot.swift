//
//  UIView+snapshot.swift
//  AppleMusicTransition
//
//  Created by Alexandr Booharin on 04/08/2019.
//  Copyright © 2019 Alexandr Booharin. All rights reserved.
//

import UIKit

extension UIView  {
    
    func makeSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

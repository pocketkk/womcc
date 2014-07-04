//
//  UIViewExtensions.swift
//  womcc
//
//  Created by Jason Crump on 6/30/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func findAndResignFirstResponder() -> Bool{
        if (self.isFirstResponder()) {
            self.resignFirstResponder()
            println("resigning: \(self)")
            return true
        }
        for subview:AnyObject in self.subviews {
            let view = subview as UIView
            view.findAndResignFirstResponder()
            println("Looping through subviews: \(view)")
            return true
        }
        return false
    }
    
    func findAndResignParentFirstResponder() -> Bool{
        for subview:AnyObject in self.superview.subviews {
            let view = subview as UIView
            view.findAndResignFirstResponder()
            println("Looping through views: \(view)")
            return true
        }
        return false
    }
}

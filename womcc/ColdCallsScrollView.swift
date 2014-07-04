//
//  ColdCallsScrollView.swift
//  womcc
//
//  Created by Jason Crump on 6/30/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit

class ColdCallsScrollView: UIScrollView {

    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.endEditing(true)
        superview.touchesEnded(touches, withEvent: event)
    }
}

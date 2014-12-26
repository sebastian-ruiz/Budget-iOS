//
//  DismissSegue.swift
//  budget
//
//  Created by Sebastian Ruiz on 26/12/2014.
//  Copyright (c) 2014 Sebastian Ruiz. All rights reserved.
//

import UIKit

//The declaration at the beginning (@objc(DismissSegue)) is to make this class accessible to the Storyboard.
@objc(DismissSegue) class DismissSegue: UIStoryboardSegue {
    override func perform() {
        if let controller = sourceViewController.presentingViewController? {
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

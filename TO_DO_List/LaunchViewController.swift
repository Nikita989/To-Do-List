//
//  ViewController.swift
//  TO_DO_List
//
//  Created by Nikita H N on 18/02/17.
//  Copyright © 2017 Next. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController
{

    @IBOutlet weak var mFirstTextField: UITextField!
    @IBOutlet weak var mSecondTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mFirstTextField.transform = CGAffineTransform(translationX: -400, y: 0)
        mSecondTextField.transform = CGAffineTransform(translationX: -400, y: 0)
        
        UIView.animate(withDuration: 3, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveLinear, animations: ({
        
            self.mFirstTextField.transform = CGAffineTransform(translationX: 0, y: 0)
        
        }), completion: nil)
        
        UIView.animate(withDuration: 3, delay: 0.7, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveLinear, animations: ({
            
            self.mSecondTextField.transform = CGAffineTransform(translationX: 0, y: 0)
            
        }), completion: nil)
 
        
        // Do any additional setup after loading the view, typically from a nib.
    }


    override func viewDidAppear(_ animated: Bool) {
                let when = DispatchTime.now() + 4
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)

            }
    }
}


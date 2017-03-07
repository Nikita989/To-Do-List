//
//  ToDoDescriptionViewController.swift
//  TO_DO_List
//
//  Created by Nikita H N on 24/02/17.
//  Copyright © 2017 Next. All rights reserved.
//

import UIKit

class ToDoDescriptionViewController: UIViewController {

    @IBOutlet weak var mTitleLabel:UITextField?
    @IBOutlet weak var mToDoDescriptionTextView: UITextView?
    var mEnteredDescription:String?
    var mNewToDoModel:TODoModel?
    var mNewLocalToDoModel:TODoModel?
    var mToDoTitle:String?
    var mreloadProtocol:ToDoViewControllerReloadProtocol?
    var connectedToNet:Bool?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mTitleLabel?.text = mToDoTitle
        mToDoDescriptionTextView?.text = mEnteredDescription
        mToDoDescriptionTextView?.layer.borderWidth = 1
        mToDoDescriptionTextView?.layer.borderColor = UIColor.black.cgColor
        mToDoDescriptionTextView?.layer.masksToBounds = false
        mToDoDescriptionTextView?.layer.shadowRadius = 3.0
        mToDoDescriptionTextView?.layer.shadowColor = UIColor.black.cgColor
        mToDoDescriptionTextView?.layer.shadowOffset = CGSize(width: 3, height: 3)
//        mToDoDescriptionTextView?.layer.shadowOpacity = 1.0
        mTitleLabel?.layer.borderWidth = 1
        mTitleLabel?.layer.borderColor = UIColor.black.cgColor
        mTitleLabel?.layer.masksToBounds = false
        mTitleLabel?.layer.shadowRadius = 3.0
        mTitleLabel?.layer.shadowColor = UIColor.black.cgColor
        mTitleLabel?.layer.shadowOffset = CGSize(width: 3, height: 3)
//        mTitleLabel?.layer.shadowOpacity = 1.0

    }
    
    func createConstructor(object:ToDoViewControllerReloadProtocol,internetCheckValue:Bool)
    {
        connectedToNet = internetCheckValue
        self.mreloadProtocol = object
        
    }
    
    @IBAction func descriptionDoneButtonPressed(_ sender: Any) {
       
       if connectedToNet!
       {
         mNewToDoModel?.listData = mToDoDescriptionTextView?.text
         mreloadProtocol?.reloadAfterEnteringDescription()

       }
        
        else
       {
        mNewLocalToDoModel?.listTitle = mTitleLabel?.text
        mNewLocalToDoModel?.listData = mToDoDescriptionTextView?.text
        print(mNewLocalToDoModel)
        mreloadProtocol?.reloadAfterEnteringDescriptionWhenNoNet()
        
        }
       self.navigationController?.popViewController(animated: true)
        
    }

}

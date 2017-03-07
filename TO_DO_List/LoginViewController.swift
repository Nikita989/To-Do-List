//
//  LoginViewController.swift
//  TO_DO_List
//
//  Created by Nikita H N on 20/02/17.
//  Copyright © 2017 Next. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate{

    @IBOutlet weak var mLoginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mSignInButton: UIButton!
    var fullName:String?
    var email:String?
    let mUserDefaults = UserDefaults.standard

    override func viewDidLoad()
    {
        super.viewDidLoad()

        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if (error == nil)
        {
            performSegue(withIdentifier: "toDoControllerSegue", sender: nil)
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            email = user.profile.email
            mUserDefaults.set(email, forKey: "mailId")
            mUserDefaults.set(fullName, forKey: "userName")
            print(fullName)
            print(userId)
            // ...
        }
        else
        {
            print("\(error.localizedDescription)")
        }
    }
    
   
   

}

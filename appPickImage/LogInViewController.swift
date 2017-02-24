//
//  ViewController.swift
//  appECONVEE
//
//  Created by Dung Duong on 12/18/16.
//  Copyright © 2016 Tai Duong. All rights reserved.
//

import UIKit

class LogInVC: UIViewController, UITextFieldDelegate {

    // var constraints
    var bottomConstraintsForVContent = NSLayoutConstraint()

    
    lazy var txtUserName: UITextField =
    {
        let temp = UITextField.initWith(placeHolder: "Username", cornerRadius: 10, backGroundColor: .white , txtColor: .black, font: .systemFont(ofSize: 20), borderWidth: 1, borderColor: .black, leftPaddingWidth: 5)
        temp.clearButtonMode = .whileEditing
        temp.delegate = self
        return temp
    }()
    
    lazy var txtPassword: UITextField =
    {
        let temp = UITextField.initWith(placeHolder: "Password", cornerRadius: 10, backGroundColor: .white , txtColor: .black, font: .systemFont(ofSize: 20), borderWidth: 1, borderColor: .black, leftPaddingWidth: 5)
        temp.clearButtonMode = .whileEditing
        temp.isSecureTextEntry = true
        temp.delegate = self
        
        return temp
    }()
    
    let butLogIn: UIButton =
    {
        let temp = UIButton.initWithGhostButton(title: "Log In", titleColor: .white, borderWidth: 1.5, cornerRadius: 10, titleFont: .systemFont(ofSize: 20))
        
        return temp
    }()
    let butSignUp: UIButton =
        {
            let temp = UIButton.initWithGhostButton(title: "Sign Up", titleColor: .white, borderWidth: 1.5, cornerRadius: 10, titleFont: .systemFont(ofSize: 20))
            return temp
    }()
    
    let butForgottedPassword: UIButton = {
        let temp = UIButton.initWithGhostButton(title: "Forgotted password ?", titleColor: .white, borderWidth: 1.5, cornerRadius: 10, titleFont: .systemFont(ofSize: 14))
        temp.addTarget(self, action: #selector(handleForgottedPassword), for: .touchUpInside)
        return temp
    }()

    
    
    let vContent: UIView =
    {
        let temp = UIView()
        temp.backgroundColor = .black
        temp.alpha = 1
        temp.layer.cornerRadius = 10
        return temp
    }()
    
    func setUpVContent()
    {
        vContent.addSubview(txtUserName)
        vContent.addSubview(txtPassword)
        vContent.addSubview(butLogIn)
        vContent.addSubview(butSignUp)
        vContent.addSubview(butForgottedPassword)
        aConsForTxtUserNameAndTxtPassword()
        aConsForButLogInAndSignUp()
        view.addSubview(vContent)
        view.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: vContent)
        view.addConstraint(NSLayoutConstraint.init(item: vContent, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        //vContent.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        
    }

    
    func aConsForTxtUserNameAndTxtPassword()
    {

        vContent.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: txtUserName)
        vContent.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: txtPassword)
        vContent.addConstraintsWithFormat(format: "V:[v0(40)]", views: txtUserName)
        vContent.addConstraintsWithFormat(format: "V:[v0(40)]", views: txtPassword)
        vContent.addConstraint(NSLayoutConstraint.init(item: txtUserName, attribute: .centerY, relatedBy: .lessThanOrEqual, toItem: vContent, attribute: .centerY, multiplier: 0.9, constant: 0))
        vContent.addConstraint(NSLayoutConstraint.init(item: txtPassword, attribute: .centerY, relatedBy: .greaterThanOrEqual, toItem: vContent, attribute: .centerY, multiplier: 1.1, constant: 0))
        txtPassword.topAnchor.constraint(greaterThanOrEqualTo: txtUserName.bottomAnchor, constant: 15).isActive = true
        
    }
    
    func aConsForButLogInAndSignUp()
    {

        vContent.addConstraintsWithFormat(format: "H:|-40-[v0(v1)]-20-[v1]-40-|", views: butLogIn, butSignUp)
        vContent.addConstraintsWithFormat(format: "V:[v0(40)]", views: butLogIn)
        vContent.addConstraintsWithFormat(format: "V:[v0(40)]-20-[v1(40)]-20-|", views: butSignUp, butForgottedPassword)
        butLogIn.topAnchor.constraint(equalTo: butSignUp.topAnchor).isActive = true
        butSignUp.topAnchor.constraint(equalTo: txtPassword.bottomAnchor, constant: 15).isActive = true
        
        vContent.addConstraintsWithFormat(format: "H:|-5-[v0]-5-|", views: butForgottedPassword)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        //navigationController?.navigationBar.isHidden = true
        // call addconstraints functions
        setUpVContent()
        
        // call other functions
        addTargets()
        
        // detect keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardDidHide, object: nil)
//        
//        signInFirebase(email: "taiazaz6@gmail.com", password: "123456789", completion: { user in
//            let _ = getUserInfor()
//        
//        })

        
    }
    func addTargets()
    {
        butLogIn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        butSignUp.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    }
    
    
    
    
    
    
    
    
    
    
// TEXT FIELD DELEGATE
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
// DETECT KEYBOARD WILL SHOW
    
    func keyboardWillShow(notification: Notification)
    {
        if let userInfo = notification.userInfo
        {
            let keyboardFrame: NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            let keyboardRectangle = keyboardFrame.cgRectValue
            let yOfKeyboard = keyboardRectangle.origin.y
            let bottomOfVContent = vContent.frame.origin.y + vContent.frame.size.height
            _ = bottomOfVContent - yOfKeyboard + 20
            print("check keyboard will show + \(yOfKeyboard)")
        }

        
        
        UIView.animate(withDuration: 0.5, animations: {self.vContent.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -100, 0)})
        
    }
    
    func handleLogin()
    {
        
        if let email = txtUserName.text, let password = txtPassword.text
        {
            signInFirebase(email: email, password: password, completion: { user in
                let _ = getCurrentUserInforFirebase()
                verifyCurrentUserFirebase()
            })
        }
    }
//    func handleCheckUsernameAndPassword(username: String, password: String) -> Bool
//    {
//        if username == "hello" && password == "123456789"
//        {
//            return true
//        }
//        return false
//    }
    
    func handleSignUp()
    {
        self.navigationController?.show(SignUpViewController(), sender: nil)
    }
    
    func handleForgottedPassword()
    {
        print("forgotted password !")
        if let email = txtUserName.text
        {
            resetPasswordFirebase(email: email, completion: nil)
        }
    }
    
// DETECT KEYBOARD WILL HIDE
    func keyboardWillHide(notification: Notification)
    {
        print("check keyboard will hide")
        UIView.animate(withDuration: 0.5, animations: {self.vContent.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, 0)})
        
    }
}


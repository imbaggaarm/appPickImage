//
//  ViewController.swift
//  appPickImage
//
//  Created by Dung Duong on 1/11/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import UIKit

//fdskfjdksljfkldjslkfjkldsjfkljdslkfjldksjflkjsdlkfjklsdjflksdjklfjdslkjfkldsjlfk
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imgV: UIImageView = {
    
        let temp = UIImageView()
        temp.backgroundColor = .blue
        return temp
    }()
    
    lazy var nameField: UITextField = {
        let temp = UITextField()
        temp.delegate = self
        temp.backgroundColor = .blue
        return temp
    }()
    
    lazy var linkField: UITextField = {
        let temp = UITextField()
        temp.delegate = self
        temp.backgroundColor = .blue
        return temp
    }()

    lazy var emailField: UITextField = {
        let temp = UITextField()
        temp.delegate = self
        temp.backgroundColor = .blue
        return temp
    }()

    
    let but: UIButton = {
        let temp = UIButton()
        temp.backgroundColor = .yellow
        temp.addTarget(self, action: #selector(getImage), for: .touchUpInside)
        return temp
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(but)
        //view.addSubview(imgV)
        view.addSubview(nameField)
        view.addSubview(linkField)
        view.addSubview(emailField)
        
        view.addConstraintsWithFormat(format: "V:|-30-[v0(v1)]-30-[v1(v2)]-30-[v2]-50-|", views: nameField, linkField, emailField)
        view.addConstraintsWithFormat(format: "V:[v0(40)]|", views: but)
        view.addConstraintsWithFormat(format: "H:|-50-[v0]-50-|", views: nameField)
        view.addConstraintsWithFormat(format: "H:|-50-[v0]-50-|", views: linkField)
        view.addConstraintsWithFormat(format: "H:|-50-[v0]-50-|", views: emailField)
        view.addConstraintsWithFormat(format: "H:|-100-[v0]-100-|", views: but)

        loadDataFirebase(link: "User", completion: {result in
            print(result ?? "")
        })
        
        signInFirebase(email: "user1@gmail.com", password: "123456789", completion: nil)
    }
    
    func getImage() // post data
    {
        //let imgPicker = UIImagePickerController()
        //imgPicker.delegate = self
        //imgPicker.sourceType = .savedPhotosAlbum
        //present(imgPicker, animated: true, completion: nil)
        print("ok")
        
        let dic: Dictionary<String, Any> = ["email": emailField.text ?? "hello", "link": linkField.text ?? "hi", "name": nameField.text ?? "bye"]
        
        referrence.child("User/user2").setValue(dic)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgV.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        dismiss(animated: true, completion: nil)
    }


}

extension ViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

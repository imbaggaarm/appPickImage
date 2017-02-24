//
//  SignUpViewController.swift
//  appECONVEE
//
//  Created by Dung Duong on 12/18/16.
//  Copyright © 2016 Tai Duong. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    let dateFormatter =  DateFormatter()
    var arrCountry: Array<String> = []
    
    lazy var txtEmail: UITextField = {
        let temp = UITextField.initWith(placeHolder: "Email", cornerRadius: 10, backGroundColor: .white , txtColor: .black, font: .systemFont(ofSize: 20), borderWidth: 1, borderColor: .black, leftPaddingWidth: 5)
        temp.clearButtonMode = .whileEditing
        temp.delegate = self
        return temp
    }()
    
    lazy var txtDisplayName: UITextField = {
        let temp = UITextField.initWith(placeHolder: "Display name", cornerRadius: 10, backGroundColor: .white , txtColor: .black, font: .systemFont(ofSize: 20), borderWidth: 1, borderColor: .black, leftPaddingWidth: 5)
        temp.clearButtonMode = .whileEditing
        temp.delegate = self
        return temp
    }()

    
    lazy var txtPassword: UITextField = {
        let temp = UITextField.initWith(placeHolder: "Password", cornerRadius: 10, backGroundColor: .white , txtColor: .black, font: .systemFont(ofSize: 20), borderWidth: 1, borderColor: .black, leftPaddingWidth: 5)
        temp.clearButtonMode = .whileEditing
        temp.isSecureTextEntry = true
        temp.delegate = self
        return temp
    }()

    lazy var txtLastName: UITextField = {
        let temp = UITextField.initWith(placeHolder: "Last name", cornerRadius: 10, backGroundColor: .white , txtColor: .black, font: .systemFont(ofSize: 20), borderWidth: 1, borderColor: .black, leftPaddingWidth: 5)
        temp.clearButtonMode = .whileEditing
        temp.delegate = self
        return temp
    }()

    lazy var txtFirstname: UITextField = {
        let temp = UITextField.initWith(placeHolder: "First name", cornerRadius: 10, backGroundColor: .white , txtColor: .black, font: .systemFont(ofSize: 20), borderWidth: 1, borderColor: .black, leftPaddingWidth: 5)
        temp.clearButtonMode = .whileEditing
        temp.delegate = self
        return temp
    }()
    
    let segmentGentle: UISegmentedControl = {
        let temp = UISegmentedControl.init(items: ["Female", "Other", "Male"])
        temp.backgroundColor = .clear
        temp.tintColor = .white
        temp.selectedSegmentIndex = 0
        return temp
    }()
    
    let datePicker: UIDatePicker = {
        let temp = UIDatePicker.init()
        temp.datePickerMode = .date
        temp.backgroundColor = .clear
        return temp
    }()
    
    lazy var countryPicker: UIPickerView = {
        let temp = UIPickerView()
        temp.delegate = self
        temp.dataSource = self
        return temp
    }()
    
    
    let butSignUp: UIButton = {
        let temp = UIButton.initWithGhostButton(title: "Sign Up", titleColor: .white, borderWidth: 1.5, cornerRadius: 10, titleFont: .systemFont(ofSize: 20))
        temp.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return temp
    }()

    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 116, green: 192, blue: 241)
        self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        datePicker.maximumDate = dateFormatter.date(from: "1-1-2005")
        datePicker.minimumDate = dateFormatter.date(from: "1-1-1890")
        addSubviews()
        
        DispatchQueue.global().async {
            self.loadCountry(completion: {result in
                if let resultArr = result as? Array<String>
                {
                    self.arrCountry = resultArr
                    DispatchQueue.main.async {
                        self.countryPicker.reloadAllComponents()
                    }
                }
            })
        }
    }
    
    func addSubviews()
    {
        view.addSubviews(subviews: txtEmail, txtDisplayName, txtPassword, txtLastName, txtFirstname, datePicker, butSignUp, countryPicker, segmentGentle)
        view.addSameConstraintsWith(format: "H:|-20-[v0]-20-|", for: txtEmail, txtDisplayName, txtPassword, datePicker, butSignUp, countryPicker, segmentGentle)
        view.addConstraintsWithFormat(format: "H:|-20-[v0(v1)]-10-[v1]-20-|", views: txtLastName, txtFirstname)
        txtFirstname.heightAnchor.constraint(equalTo: txtLastName.heightAnchor, multiplier: 1).isActive = true
        txtFirstname.topAnchor.constraint(equalTo: txtLastName.topAnchor).isActive = true
        
        view.addConstraintsWithFormat(format: "V:|-84-[v0(v3)]-[v1(v3)]-[v2(v3)]-[v3(40)]-[v4(40)]-[v5(100)][v6(100)]-20-[v7(40)]", views: txtEmail, txtPassword, txtDisplayName, txtLastName, segmentGentle, datePicker, countryPicker, butSignUp)
    }
    
    func handleSignUp()
    {
        print("check pressed button sign up")
        
        if let email = txtEmail.text, let password = txtPassword.text
        {
            signUpFirebase(email: email, password: password, completion: { result, uid in
                
            
            
            })
        
        }
        
        if let email = txtEmail.text
        {
            
        }
        else
        {
            txtEmail.layer.borderColor = UIColor.red.cgColor
            txtEmail.placeholder = "Invalid email !"
            txtEmail.attributedPlaceholder = NSAttributedString.init(string: "Invalid email !", attributes: [NSForegroundColorAttributeName: UIColor.red])
        }
        
        
    }
    func loadCountry(completion: @escaping (Any) -> ())
    {
        let path = Bundle.main.path(forResource: "countries", ofType: "txt")
        if FileManager.default.fileExists(atPath: path!)
        {
            do
            {
                let string = try String.init(contentsOfFile: path!, encoding: .utf8)
                let result = string.components(separatedBy: "\n")
                completion(result)
            }
            catch
            {
                print(error.localizedDescription)
            }
            
        }
    }
}

extension SignUpViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrCountry.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrCountry[row]
    }
    
}


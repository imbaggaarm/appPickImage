//
//  FunctionalProgrammingSwift.swift
//  appLayoutMP3ZING
//
//  Created by Dung Duong on 12/9/16.
//  Copyright © 2016 Tai Duong. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


let widthOfScreen = UIScreen.main.bounds.size.width
let heightOfScreen = UIScreen.main.bounds.size.height

extension UIImageView
{
    public func loadImageFromURL(urlString: String)
    {
        let url: URL = URL(string: urlString)!
        do
        {
            let data: Data = try Data(contentsOf: url)
            self.image = UIImage(data: data)
        }
        catch
        {
            print("LOAD IMAGE ERROR!");
        }        
        
    }
    public func loadImageFromURLWithMultiThreading(urlString: String)
    {
        
        let indicator: UIActivityIndicatorView = {
            let temp = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
            temp.color = UIColor.init(white: 0.9, alpha: 1)
            temp.translatesAutoresizingMaskIntoConstraints = false
            return temp
        }()
        self.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        indicator.startAnimating()
        
        let queue = DispatchQueue(label: "queue")
        queue.async {
            if let url: URL = URL(string: urlString)
            {
                do
                {
                    let data: Data = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                        indicator.stopAnimating()
                        indicator.hidesWhenStopped = true
                    }
                }
                catch
                {
                    
                }
            }

        }
    }
}
//extension UIView
//{
//    func addConstraintsWithFormat(format: String, views: UIView...)
//    {
//        var dic = Dictionary<String, UIView>()
//        for view in views
//        {
//            let key = "v\(views.index(of: view))"
//            view.translatesAutoresizingMaskIntoConstraints = false
//            dic[key] = view
//        }
//        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: dic))
//    }
//}
extension UIView
{
    func addConstraintsWithFormat(format: String, views: UIView...)
    {
        var dic = Dictionary<String, UIView>()
        for (index, view) in views.enumerated()
        {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            dic[key] = view
        }
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: dic))
    }
    
    func addBlurEffect(with effect: UIBlurEffectStyle)
    {
        let blurEffect = UIBlurEffect.init(style: effect)
        let effectV = UIVisualEffectView.init(effect: blurEffect)
        self.addSubview(effectV)
        effectV.frame = self.bounds
        effectV.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func addSubviews(subviews: UIView...)
    {
        let _ = subviews.map{self.addSubview($0)}
    }
    
    func addSameConstraintsWith(format: String, for views: UIView...)
    {
        for view in views
        {
            addConstraintsWithFormat(format: format, views: view)
        }
    }
    
}
extension UILabel
{
    class func setLbl(backgroundColor: UIColor, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, isClips: Bool, title: String, font: UIFont, textAlignment: NSTextAlignment, textColor: UIColor) -> UILabel
    {
        let temp = UILabel()
        temp.backgroundColor = backgroundColor
        temp.layer.cornerRadius = cornerRadius
        temp.clipsToBounds = isClips
        temp.layer.borderColor = borderColor.cgColor
        temp.layer.borderWidth = borderWidth
        temp.text = title
        temp.font = font
        temp.textColor = textColor
        temp.textAlignment = textAlignment
        return temp
    }
}
extension UIColor
{
    class func rgb(red:CGFloat, green: CGFloat, blue: CGFloat) -> UIColor
    {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1);
    }
    class func rgba(red:CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor
    {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: alpha);
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    class func colorFromHexstring (hex:String, alpha: CGFloat = 1) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UITextField
{
    func setLeftPadding(width: CGFloat)
    {
        let leftView = UIView()
        self.addSubview(leftView)
        self.leftView = leftView
        self.leftViewMode = .always
        leftView.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
    }
    class func initWith(placeHolder: String = "", cornerRadius: CGFloat = 5, backGroundColor: UIColor = UIColor.white, txtColor: UIColor = UIColor.black, font: UIFont = UIFont.systemFont(ofSize: 20), borderWidth: CGFloat = 0, borderColor: UIColor = .white, leftPaddingWidth: CGFloat = 4, keyboardType: UIKeyboardType = UIKeyboardType.alphabet) -> UITextField
    {
        let temp = UITextField()
        temp.backgroundColor = backGroundColor
        temp.placeholder = placeHolder
        temp.setLeftPadding(width: leftPaddingWidth)
        temp.textColor = txtColor
        temp.layer.cornerRadius = cornerRadius
        temp.font = font
        temp.layer.borderColor = borderColor.cgColor
        temp.layer.borderWidth = borderWidth
        temp.keyboardType = keyboardType
        temp.clipsToBounds = true
        
        return temp
    }
}

extension UIViewController
{
    func loadDataWebService(linkAPI: API, method: String = "GET", keyAndValue: Dictionary<String, Any> = [:], completion: @escaping (Data?) -> Void)
    {
        var tempURLString = linkAPI.fullLink
        let param = keyAndValue.convertDicToParamType()
        if method == "GET"
        {
            if param != ""
            {
                tempURLString += "?\(param)"
            }
        }
        let url = URL(string: tempURLString)
        print(url!)
        var urlRequest = URLRequest(url: url!)
        
        if method == "POST"
        {
            urlRequest.httpBody = param.data(using: .utf8)!
            urlRequest.httpMethod = method
        }
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            if error == nil
            {
                completion(data)
            }
            else
            {
                completion(nil)
            }
        }).resume()
    }
    
    func loadDataWebService(urlString: String, method: HTTPMethod = .GET, keyAndValue: Dictionary<String, Any> = [:], completion: @escaping (Data?) -> Void)
    {
        var tempURLString = urlString
        let param = keyAndValue.convertDicToParamType()
        if method.rawValue == "GET"
        {
            if param != ""
            {
                tempURLString += "?\(param)"
            }
        }
        let url = URL(string: tempURLString)
        print(url!)
        var urlRequest = URLRequest(url: url!)
        
        if method.rawValue == "POST"
        {
            urlRequest.httpBody = param.data(using: .utf8)!
            urlRequest.httpMethod = method.rawValue
        }
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            if error == nil
            {
                completion(data)
            }
            else
            {
                completion(nil)
            }
        }).resume()
    }

    
    
    
    func loadJSON(linkAPI: API, method: HTTPMethod = .GET, keyAndValue: Dictionary<String, Any> = [:], completion: @escaping  (Any?) -> (Void))
    {
        var tempURLString = linkAPI.fullLink
        let param = keyAndValue.convertDicToParamType()
        
        if method == .GET
        {
            if param != ""
            {
                tempURLString += "?\(param)"
            }
        }
        let url = URL(string: tempURLString)
        print(url!)
        var urlRequest = URLRequest(url: url!)
        
        if method == .POST
        {
            urlRequest.httpBody = param.data(using: .utf8)!
            urlRequest.httpMethod = method.toString
        }
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest, completionHandler: {(data, response, err) in
            if err == nil
            {
                do{
                    let temp = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    print("check if")
                    completion(temp)
                }
                catch
                {
                    print("check if")
                    completion(nil)
                }
            }
            else
            {
                completion(nil)
            }        
        }).resume()
    }
    
    func loadJSON(urlString: String, method: HTTPMethod = .GET, keyAndValue: Dictionary<String, Any> = [:], completion: @escaping  (Any?) -> (Void))
    {
        var tempURLString = urlString
        let param = keyAndValue.convertDicToParamType()
        
        if method == .GET
        {
            if param != ""
            {
                tempURLString += "?\(param)"
            }
        }
        let url = URL(string: tempURLString)
        print(url!)
        var urlRequest = URLRequest(url: url!)
        
        if method == .POST
        {
            urlRequest.httpBody = param.data(using: .utf8)!
            urlRequest.httpMethod = method.toString
        }
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest, completionHandler: {(data, response, err) in
            if err == nil
            {
                do{
                    let temp = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    print("check if")
                    completion(temp)
                }
                catch
                {
                    print("check if")
                    completion(nil)
                }
            }
            else
            {
                completion(nil)
            }
        }).resume()
    }

    
    
    
    func postAndLoadDifferentData(urlString:API, keyAndValue:Dictionary<String,Any> = [:], method:HTTPMethod, completionHandler:@escaping (Any?)->()){
        var urlStringGet:String = urlString.fullLink
        var index:Int = 0
        switch method {
        case .POST:
            index = 1
        default:
            do
            {
                let param = keyAndValue.convertDicToParamType()
                if param != ""
                {
                    urlStringGet += "?\(param)"
                }
            }
        }
        //print("////////\(index)")
        let url:URL = URL(string: urlStringGet)!
        var request:URLRequest = URLRequest(url: url)
        if index == 1{
            let boundary = generateBoundaryString()
            let body = NSMutableData()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            for pr in keyAndValue{
                if let image:UIImage = pr.value as? UIImage
                {
                    let data = UIImageJPEGRepresentation(image, 0.5)
                    let fname:String = "\(getTime()).jpeg"
                    let mimetype = "image/png"
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Disposition:form-data; name=\"\(pr.key)\"; FileName=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                    body.append(data!)
                    body.append("\r\n".data(using: String.Encoding.utf8)!)
                }else{
                    //----------upload them param
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Disposition: form-data; name=\"\(pr.key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                    body.append("\(pr.value)\r\n".data(using: String.Encoding.utf8)!)
                }
                //    body.append("&ten=datnguyen".data(using: String.Encoding.utf8)!)
                request.httpMethod = "POST"
                request.httpBody = body as Data
            }
        }
        let session:URLSession = URLSession.shared
        session.dataTask(with: request, completionHandler: {
            (data,res,err) in
            //print(data ?? <#default value#>)
            if err == nil {
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    print(result)
                    DispatchQueue.main.async {
                        completionHandler(result)
                    }
                }catch{
                    completionHandler(false)
                }
            }else{
                DispatchQueue.main.async {
                    print("///khong lay duoc du lieu!")
                    completionHandler(false)
                }
            }
        }).resume()
    }
    
    
    
    //DICTIONARY: vua load vua post data, neu post image: su dung ["key": img, "sa": "sa"]
    
    func postAndLoadDifferentData(urlString: String, param:Dictionary<String,Any> = [:], method: HTTPMethod = .GET,completionHandler:@escaping (Any?)->()){
        var urlStringGet:String = urlString
        print(urlStringGet)
        var index:Int = 0
        switch method {
        case .POST:
            index = 1
        default:
            //if let param = param{
            urlStringGet += "?\(param.convertDicToParamType())"
            //}
        }
        //print("////////\(index)")
        let url:URL = URL(string: urlStringGet)!
        var request:URLRequest = URLRequest(url: url)
        if index == 1{
            let boundary = generateBoundaryString()
            let body = NSMutableData()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            for pr in param{
                if let image:UIImage = pr.value as? UIImage
                {
                    print("check image")
                    let data = UIImageJPEGRepresentation(image, 0.5)
                    let fname:String = "\(getTime()).jpeg"
                    let mimetype = "image/png"
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Disposition:form-data; name=\"\(pr.key)\"; FileName=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                    body.append(data!)
                    body.append("\r\n".data(using: String.Encoding.utf8)!)
                }else{
                    //----------upload them param
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Disposition: form-data; name=\"\(pr.key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                    body.append("\(pr.value)\r\n".data(using: String.Encoding.utf8)!)
                }
                //    body.append("&ten=datnguyen".data(using: String.Encoding.utf8)!)
                request.httpMethod = "POST"
                request.httpBody = body as Data
            }
        }
        let session:URLSession = URLSession.shared
        session.dataTask(with: request, completionHandler: {
            (data,res,err) in
            //print(data ?? <#default value#>)
            if err == nil {
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(result)
                    DispatchQueue.main.async {
                        completionHandler(result)
                    }
                }catch{
                    completionHandler(false)
                }
            }else{
                DispatchQueue.main.async {
                    print("///khong lay duoc du lieu!")
                    completionHandler(false)
                }
            }
        }).resume()
    }
    
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
    func getTime() -> String{
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        let nano = calendar.component(.nanosecond, from: date)
        return "\(hour)-\(minutes)-\(second)-\(nano)"
    }
    func getDate()->String{
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "\(day)/\(month)/\(year) \(hour):\(minutes)"
    }

}

    


extension Dictionary
{
    func convertDicToParamType() -> String
    {
        var resultString = ""
        for (index, i) in self.enumerated()
        {
            if index == 0
            {
                resultString += "\(i.key)=\(i.value)"
            }
            else
            {
                resultString += "&\(i.key)=\(i.value)"
            }
        }
        return resultString
    }
}


extension UIButton
{
    class func initWithGhostButton(title: String, titleColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat = 0, titleFont: UIFont = .systemFont(ofSize: 20)) -> UIButton
    {
        let temp = UIButton(type: .system)
        temp.setTitle(title, for: .normal)
        temp.setTitleColor(titleColor, for: .normal)
        temp.layer.borderColor = titleColor.cgColor
        temp.layer.cornerRadius = cornerRadius
        temp.layer.borderWidth = borderWidth
        temp.titleLabel?.font = titleFont
        temp.clipsToBounds = true
        temp.backgroundColor = .clear
        return temp
    }
}

extension UIViewController
{
    
}

extension Array
{
    static func mapBoxFormatArrayCLLocation(arrDouble: Array<Array<Double>>) -> [CLLocationCoordinate2D]
    {
        var resultArray = [CLLocationCoordinate2D]()
        for i in arrDouble
        {
            let coor = CLLocationCoordinate2D(latitude: i[1], longitude: i[0])
            resultArray.append(coor)
        }
        return resultArray
    }
    
    static func formatFromArrDoubleToCLLocationCoordinate2D(arrDouble: Array<Array<Double>>) -> [CLLocationCoordinate2D]
    {
        var resultArray = [CLLocationCoordinate2D]()
        for i in arrDouble
        {
            let coor = CLLocationCoordinate2D(latitude: i[0], longitude: i[1])
            resultArray.append(coor)
        }
        return resultArray
    }
    
    static func formatFromCLLocationCoordinate2DToDouble(arrCoor: Array<CLLocationCoordinate2D>) -> [[Double]]
    {
        var result: Array<Array<Double>> = []
        for i in arrCoor
        {
            let smallArray = [i.latitude, i.longitude]
            result.append(smallArray)
        }
        return result
    }
    
}

/// http
/*
 <key>NSAppTransportSecurity</key>
 <dict>
 <key>NSAllowsArbitraryLoads</key><true/>
 </dict>
 */

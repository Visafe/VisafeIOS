//
//  VipController.swift
//  visafe_ios
//
//  Created by NCSC P5 on 6/8/21.
//

import UIKit

class VipController:UIViewController
{

    @IBOutlet weak var license_key: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        postRequestAuthenticateVip(key: textField.text!, deviceId: StoreData.getMyPlist(key: "userid") as! String)
        return true
    }
    
    
    func postRequestAuthenticateVip(key:String,deviceId:String){
        struct RequestData: Codable {
            var key:String
            var deviceId:String
        }

        let url = URL(string: DOMAIN_SEND_VIP_AUTHENTICATION)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("applicsation/json", forHTTPHeaderField: "Content-Type")
        let request_json = RequestData(key: key, deviceId: deviceId)
        let jsonData = try? JSONEncoder().encode(request_json)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {return}
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
                DispatchQueue.main.async {
                    print(json)
                    if (json["status_code"] as! Int == 1)
                    {
                        print(json["key_info"] as![String:Any])
                        let json1 = json["key_info"] as![String:Any]
                       StoreData.saveMyPlist(key: "domain_vip", value: json1["DOHurl"] as! String)
                       StoreData.saveMyPlist(key: "time_expire", value: Int(json1["Expired"] as! String)!)
                       let alert = UIAlertController(title: "Th??ng b??o", message: "Phi??n b???n VIP ???? ???????c k??ch ho???t!" , preferredStyle: UIAlertController.Style.alert)
                       let okAction = UIAlertAction(title: "X??c nh???n", style:
                       UIAlertAction.Style.default) {
                          UIAlertAction in
                           self.navigationController?.popViewController(animated: true)
                           }
                          // add an action (button)
                          alert.addAction(okAction)
                          // show the alert
                       self.present(alert, animated: true, completion: nil)
                        StoreData.saveMyPlist(key: "switch_vip", value: true)
                    }
                    else if (json["status_code"] as! Int == 404 || json["status_code"] as! Int == 406)
                    {
                        StoreData.saveMyPlist(key: "switch_vip", value: true)
                        let alert = UIAlertController(title: "Th??ng b??o", message: "M?? x??c th???c kh??ng h???p l??? ho???c ???? h???t h???n s??? d???ng" , preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "X??c nh???n", style:
                        UIAlertAction.Style.default) {
                           UIAlertAction in
                            }
                           // add an action (button)
                           alert.addAction(okAction)
                           // show the alert
                        self.present(alert, animated: true, completion: nil)
                        StoreData.saveMyPlist(key: "switch_vip", value: false)
                    }
                    else
                    {
                        StoreData.saveMyPlist(key: "switch_vip", value: true)
                        let alert = UIAlertController(title: "Th??ng b??o", message: "L???i k???t n???i t???i m??y ch???" , preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "X??c nh???n", style:
                        UIAlertAction.Style.default) {
                           UIAlertAction in
                           
                            }
                           // add an action (button)
                           alert.addAction(okAction)
                           // show the alert
                        self.present(alert, animated: true, completion: nil)
                        StoreData.saveMyPlist(key: "switch_vip", value: false)
                    }
                }
            }catch let jsonErr{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Th??ng b??o", message: "M???t k???t n???i v???i m??y ch???" , preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "X??c nh???n", style:
                    UIAlertAction.Style.default) {
                       UIAlertAction in
                        self.navigationController?.popViewController(animated: true)
                        }
                       // add an action (button)
                       alert.addAction(okAction)
                       // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
           }
        }
        task.resume()
    }
}
private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}

//
//  ViewController.swift
//  PapagoAPI
//
//  Created by Dongwan Ryoo on 12/17/23.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet var beforeTranslateTextView: UITextView!
    @IBOutlet var afterTranslateTextView: UITextView!
    @IBOutlet var langSelectTextField: UITextField!
    @IBOutlet var translateButton: UIButton!
    let pickerView = UIPickerView()
    var targetLnag: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        addTarget()
        langSelectTextFieldSet(langSelectTextField)

    }
}

//MARK: - translateButton 관련 코드
extension ViewController {
    
    func addTarget() {
        //button 클릭 시 네트워크 호출 method
        translateButton.addTarget(self, action: #selector(translateButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func translateButtonTapped() {
        callRequestTranslateLangs(targetLnag)
    }
}

//MARK: - langSelectTextField 관련 코드
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func langSelectTextFieldSet(_ textField: UITextField) {
        textField.placeholder = "언어를 선택해주세요."
        textField.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return LangType.langDic.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let keyArray = Array(LangType.langDic.keys)
        langSelectTextField.text = keyArray[row]
        
        let valueArray = Array(LangType.langDic.values)
        targetLnag = valueArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let keyArray = Array(LangType.langDic.keys)
        let langText = keyArray[row]
        return langText
    }
    
}

//MARK: - Network 관련 코드
extension ViewController {
    
    func callRequestTranslateLangs(_ targetLnag: String) {
        
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        
        //Alamofire에서 정의한 parameter 타입
        let prameter: Parameters = [
            //서버에서 인식 못한 듯
            "source" : "ko",
            "target" : targetLnag,
            "text" : beforeTranslateTextView.text ?? ""
        ]
        
        AF.request(url, 
                   method: .post,
                   parameters: prameter,
                   headers: APIKey.NAVERKey).validate().responseJSON { response in
            
            //상태코드
            let statusCode = response.response?.statusCode
            print("statusCode", statusCode)
            
            switch response.result {
            case .success(let value):
                print(value)
                let json = JSON(value)
                let output = json["message"]["result"]["translatedText"].stringValue
                //클로저 내부에서는 객체 자체 참고할 떄 self
                self.afterTranslateTextView.text = output
                
            case .failure(let error):
                
                print(error)
            }
        }   
    }
}

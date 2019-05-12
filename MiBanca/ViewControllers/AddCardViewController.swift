//
//  AddCardViewController.swift
//  MiBanca
//
//  Created by Yoshi Revelo on 5/10/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//

import UIKit

protocol AddCardDelegate: class {
    func addCardDidCreate(user: User, cardInfo: CardsInfo)
}

class AddCardViewController: UIViewController {
    
    weak var delegate: AddCardDelegate?

    private var currentTextField: UITextField?
    
    //MARK:  - Outlets
    @IBOutlet weak var cardNameTextField: UITextField!
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    
    @IBOutlet weak var monthCardExpirationDate: UITextField!
    
    @IBOutlet weak var yearCardExpirationDate: UITextField!
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Agregar Tarjeta"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notificarion:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentTextField?.resignFirstResponder()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - User interaction
    
    @IBAction func saveCardButtonPressed(_ sender: Any) {
        let date = Date()
        let year = DateFormatter()
        year.dateFormat = "yy"
        let formattedYear = year.string(from: date)
        
        
        if cardNameTextField.text != "" && cardNumberTextField.text != "" && monthCardExpirationDate.text != "" && yearCardExpirationDate.text != ""{
            
            let checkMonth = Int(monthCardExpirationDate.text!)!
            
            if cardNumberTextField.text!.count < 16 {
                message(title: "Tarjeta Inválida", message: "Ingresa los 16 números de tu tarjeta")
            }else if checkMonth > 12 || checkMonth < 1 || yearCardExpirationDate.text! < formattedYear{
                message(title: "Error", message: "Verifica el que el mes o el año estén correctos.")
            }else{
                //guardar los datos
                
                let key = (UserDefaults.standard.value(forKey: "password") as! String)
                let iv = (UserDefaults.standard.value(forKey: "iv") as! String)
                let us = (UserDefaults.standard.value(forKey: "user") as! String)
                
                let userData = CoreDataManager.sharedInstance.readData(class: User.self)
                var userExists = false
                
                if userData.count > 0{
                    
                    for user in userData{
                        if user.user == us.aesEncrypt(key: key, iv: iv){
                            userExists = true
                        }
                    }
                    
                    for user in userData{
                        if user.user == us.aesEncrypt(key: key, iv: iv) && userExists{
                            let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
                            let cardInfo = CardsInfo(context: context)
                            
                            cardInfo.name = cardNameTextField.text!.aesEncrypt(key: key, iv: iv)
                            cardInfo.cardnumber = cardNumberTextField.text!.aesEncrypt(key: key, iv: iv)
                            cardInfo.cardExpirationDate = "\(monthCardExpirationDate.text!)/\(yearCardExpirationDate.text!)".aesEncrypt(key: key, iv: iv)
                            
                            cardInfo.user = user
                            delegate?.addCardDidCreate(user: user, cardInfo: cardInfo)
                            
                        }else if !userExists{
                            let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
                            let user = User(context: context)
                            let cardInfo = CardsInfo(context: context)
                            
                            user.user = us.aesEncrypt(key: key, iv: iv)
                            
                            
                            
                            
                            cardInfo.name = cardNameTextField.text!.aesEncrypt(key: key, iv: iv)
                            cardInfo.cardnumber = cardNumberTextField.text!.aesEncrypt(key: key, iv: iv)
                            cardInfo.cardExpirationDate = "\(monthCardExpirationDate.text!)/\(yearCardExpirationDate.text!)".aesEncrypt(key: key, iv: iv)
                            
                            cardInfo.user = user
                            
                            delegate?.addCardDidCreate(user: user, cardInfo: cardInfo)
                        }
                    }
                }else{
                    let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
                    let user = User(context: context)
                    let cardInfo = CardsInfo(context: context)
                    
                    user.user = us.aesEncrypt(key: key, iv: iv)
                    
                    
                    
                    cardInfo.name = cardNameTextField.text!.aesEncrypt(key: key, iv: iv)
                    cardInfo.cardnumber = cardNumberTextField.text!.aesEncrypt(key: key, iv: iv)
                    cardInfo.cardExpirationDate = "\(monthCardExpirationDate.text!)/\(yearCardExpirationDate.text!)".aesEncrypt(key: key, iv: iv)
                    
                    cardInfo.user = user
                    delegate?.addCardDidCreate(user: user, cardInfo: cardInfo)
                }
                
                CoreDataManager.sharedInstance.saveContext()
            }
            
        }else{
            message(title: "Datos Vacíos", message: "Ingresa todos los datos")
        }
    }
    
    //MARK: - Private Methods
    
    private func message(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func keyBoardWillShow(notification: Notification){
    }
    
    @objc private func keyBoardWillHide(notificarion: Notification){
    }
}

extension AddCardViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case cardNameTextField:
            cardNumberTextField.becomeFirstResponder()
        case cardNumberTextField:
            monthCardExpirationDate.becomeFirstResponder()
        case monthCardExpirationDate:
            yearCardExpirationDate.becomeFirstResponder()
        case yearCardExpirationDate:
            currentTextField?.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentTextField = nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = false
        let currentString: NSString = textField.text! as NSString
        switch textField {
        case cardNameTextField:
            result = true
        case cardNumberTextField:
            let maxLength = 16
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            result = newString.length <= maxLength
        case monthCardExpirationDate:
            let maxLength = 2
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            result = newString.length <= maxLength
        case yearCardExpirationDate:
            let maxLength = 2
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            result = newString.length <= maxLength
        default:
            break
        }
        
        return result
    }
}


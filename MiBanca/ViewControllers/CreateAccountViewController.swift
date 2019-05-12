//
//  CreateAccountViewController.swift
//  MiBanca
//
//  Created by Yoshi Revelo on 5/10/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//

import UIKit
import Locksmith

class CreateAccountViewController: UIViewController {

    private var currentTextField: UITextField?
    
    //MARK: - Outlets
    
    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var password1TextField: UITextField!
    
    @IBOutlet weak var password2TextField: UITextField!
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        signUp()
    }
    
    //MARK: - Private Methods
    private func signUp(){
        if userTextField.text != "" && password1TextField.text != "" && password2TextField.text != "" {
            if userTextField.text!.count < 6 || password1TextField.text!.count < 6{
                message(title: "Error", message: "El usuario y contraseña deben tener 6 caracteres")
            }else if password1TextField.text != password2TextField.text{
                message(title: "Error", message: "Las contraseñas no coinciden")
            }else if userTextField.text! == password1TextField.text!{
                message(title: "Error", message: "El usuario y la contraseña deben ser diferentes.")
            }else{
                print("Aquí vamos")
                
                let key = "\(randomString(length: 10))"
                let iv = randomString(length: 16)
                
                let user = userTextField.text!.encrypt()
                let pass = password1TextField.text!.encrypt()
                
                
                var dictionary : [String : Any] = [:]
                do{
                    dictionary["key"] = key
                    dictionary["iv"] = iv
                    dictionary["user"] = userTextField.text!
                    print(dictionary)
                    
                    try Locksmith.saveData(data: dictionary, forUserAccount: user, inService: pass)
                    //try Locksmith.updateData(data: dictionary, forUserAccount: user, inService: pass)
                    
                    let newUser = UIAlertController(title: "Nuevo Usuario", message: "Usuario Creado", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                        //ChangeViewController if the pass is right
                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        
                        let board = UIStoryboard(name: "Main", bundle: nil)
                        let loginViewController = board.instantiateViewController(withIdentifier: "LoginViewController")
                        delegate.window?.rootViewController = loginViewController
                    }
                    
                    newUser.addAction(okAction)
                    
                    present(newUser, animated: true, completion: nil)
                    
                    
                    
                    
                    
                }catch let error{
                    print(error.localizedDescription)
                    message(title: "Ha ocurrido un error", message: "Intentalo más tarde. Gracias!")
                }
            }
        }else{
            message(title: "Datos Vacíos", message: "Todos los campos son requeridos")
        }
    }
    
    
    private func message(title: String, message: String){
        let message = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        message.addAction(okAction)
        
        present(message, animated: true, completion: nil)
    }
    
    private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

extension CreateAccountViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userTextField:
            password1TextField.becomeFirstResponder()
        case password1TextField:
            password2TextField.becomeFirstResponder()
        case password2TextField:
            currentTextField?.resignFirstResponder()
            signUp()
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
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

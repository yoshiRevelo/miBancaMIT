//
//  LoginViewController.swift
//  MiBanca
//
//  Created by Yoshi Revelo on 5/10/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//

import UIKit
import Locksmith

class LoginViewController: UIViewController {
    
    private var currentTextField: UITextField?
    
    //MARK: - Outlets

    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentTextField?.resignFirstResponder()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*let barViewControllers = segue.destination as! UITabBarController
        let nav = barViewControllers.viewControllers![0] as! UINavigationController
        let destinationViewController = nav.viewControllers[0] as! YourViewController
        destinationViewController.varTest = _varValue
        */
        
        if segue.identifier == "CardsViewController"{
            let tabBarController  = segue.destination as! UITabBarController
            let navigationController = tabBarController.viewControllers![0] as! UINavigationController
            let _ = navigationController.viewControllers[0] as! CardsViewController
            
            //cardsViewController.infoUser = Info
            
        }
    }
 
    
    //MARK: - User Interaction
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        login()
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        
    }
    
    //MARK: - Private Methods
    private func login(){
        if userTextField.text != "" && passwordTextField.text != ""{
            
            let user = userTextField.text!.encrypt()
            let pass = passwordTextField.text!.encrypt()
            
            if let dictionary = Locksmith.loadDataForUserAccount(userAccount: user, inService: pass){
                
            
                UserDefaults.standard.set("\(passwordTextField.text!)\(dictionary["key"] as! String)", forKey: "password")
                UserDefaults.standard.set(dictionary["iv"] as! String, forKey: "iv")
                UserDefaults.standard.set(dictionary["user"] as! String, forKey: "user")
                performSegue(withIdentifier: "CardsViewController", sender: nil)
                
            }else{
                let alert = UIAlertController(title: "Error", message: "No se encontró el usuario", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                alert.addAction(okAction)
                
                present(alert, animated: true)
                return
            }
            
            
        }else{
            let alert = UIAlertController(title: "Datos incompletos", message: "Escribe el usuario o contraseña", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            currentTextField?.resignFirstResponder()
            login()
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


//
//  PayViewController.swift
//  MiBanca
//
//  Created by Yoshi Revelo on 5/11/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//

import UIKit
import MapKit

class PayViewController: UIViewController {
    
    
    private var selectedCard: CardsInfo?
    private var iv = (UserDefaults.standard.value(forKey: "iv") as! String)
    private var key = (UserDefaults.standard.value(forKey: "password") as! String)
    private var us = (UserDefaults.standard.value(forKey: "user") as! String)
    private var currentTextField: UITextField?
    
    private var locationManager = CLLocationManager()
    private var userLatitude: Double!
    private var userLongitude: Double!
    
    //MARK: - Outlets
   
    @IBOutlet weak var selectedCardButton: UIButton!
    
    @IBOutlet weak var destinationCardTextField: UITextField!
    
    @IBOutlet weak var destinationNameTextField: UITextField!
    
    @IBOutlet weak var paysDescriptionTextfield: UITextField!
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Pagar"
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = checkPermissions()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentTextField?.resignFirstResponder()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CardsViewController"{
            let cardsViewController = segue.destination as! CardsViewController
            cardsViewController.delegate = self
        }
    }
 
    //MARK: - User interaction
    
    @IBAction func payButtonPressed(_ sender: Any) {
        locationManager.requestLocation()
        
        
        guard  let latitude = userLatitude else {
            message(title: "Error", message: "No podemos obtener tu ubicación")
            return
            
        }
        guard let longitude = userLongitude else {
            message(title: "Error", message: "Selecciona una tarjeta")
            return
        }
        
        //let userCenter = CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude)
        
        guard let cardData = selectedCard else {
            message(title: "Error", message: "Selecciona una tarjeta")
            return
        }
        
        guard let destinationCard = destinationCardTextField.text else{
            message(title: "Error", message: "Introduce el número de tarjeta de destino")
            return
        }
        
        if destinationCard.count < 16{
            message(title: "Error", message: "Introduce los 16 números de tu tarjeta")
        }else if destinationNameTextField.text == "" || paysDescriptionTextfield.text == ""{
            message(title: "Datos Vacíos", message: "Introduce los datos faltantes")
        }else{
            //print("Todo bien")
            let key = (UserDefaults.standard.value(forKey: "password") as! String)
            let iv = (UserDefaults.standard.value(forKey: "iv") as! String)
            let us = (UserDefaults.standard.value(forKey: "user") as! String)
            
            let date = Date()
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            
            //print(dateFormatter.string(from: date))
            
            
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
                        let transactions = Transactions(context: context)
                        
                        print(us)
                        
                        transactions.userCardNumber = cardData.cardnumber
                        transactions.payLatitude = String(latitude).aesEncrypt(key: key, iv: iv)
                        transactions.payLongitude = String(longitude).aesEncrypt(key: key, iv: iv)
                        transactions.payDescription = paysDescriptionTextfield.text?.aesEncrypt(key: key, iv: iv)
                        transactions.payDate = dateFormatter.string(from: date).aesEncrypt(key: key, iv: iv)
                        transactions.destinationName = destinationNameTextField.text?.aesEncrypt(key: key, iv: iv)
                        transactions.destinationCard = destinationCard.aesEncrypt(key: key, iv: iv)
                        transactions.cardExpirationDate = cardData.cardExpirationDate
                        transactions.username = cardData.name
                        
                        transactions.user = user
                        
                        //print(transactions.user)
                    }
                }
                
                print(CoreDataManager.sharedInstance.readData(class: User.self))
                
                let alert = UIAlertController(title: "Relizar Pago", message: "¿Seguro que desea continuar?", preferredStyle: .actionSheet)
                
                let okAction = UIAlertAction(title: "Conitnuar", style: .default) { (action) in
                    CoreDataManager.sharedInstance.saveContext()
                    self.tabBarController?.selectedIndex = 2
                    
                    self.destinationNameTextField.text = ""
                    self.destinationCardTextField.text = ""
                    self.paysDescriptionTextfield.text = ""
                    self.selectedCard = nil
                    
                    self.selectedCardButton.setTitle("Seleccionar Tarjeta", for: .normal)
                    
                }
                
                alert.addAction(okAction)
                
                let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
                
                alert.addAction(cancelAction)
                
                present(alert, animated: true)
            }
        }
        
    }
    
    
    //MARK: - Private Methods
    private func message(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    
    private func checkPermissions() -> Bool{
        if CLLocationManager.locationServicesEnabled(){
            let status = CLLocationManager.authorizationStatus()
            if status == .authorizedWhenInUse{
                locationManager.requestLocation()
                print("podemos usar el GPS")
                return true
            }else if status == .notDetermined{
                locationManager.requestWhenInUseAuthorization()
                return true
            }else if status == .restricted || status == .denied{
                //TODO: Pedir al usuario que active su GPS
                print("no hay permiso :(")
                locationServicesAlert()
                return false
            }
            else{
                locationServicesAlert()
                return false
            }
        }
        else {
            return false
        }
    }
    
    private func locationServicesAlert(){
        let alertController = UIAlertController(title: "Oups!", message: "Para poder usar esta aplicación, necesitamos saber tu ubicación.", preferredStyle: .alert)
        
        let configAction = UIAlertAction(title: "Ir a configuración", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(configAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive) { (_) in
            self.tabBarController?.selectedIndex = 0
        }
        
        //let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}


//MARK: - UITextFieldDelegate
extension PayViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case destinationCardTextField:
            destinationNameTextField.becomeFirstResponder()
        case destinationNameTextField:
            paysDescriptionTextfield.becomeFirstResponder()
        case paysDescriptionTextfield:
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
        case destinationCardTextField:
            let maxLength = 16
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            result = newString.length <= maxLength
        case destinationNameTextField:
            result = true
        case paysDescriptionTextfield:
            let maxLength = 30
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            result = newString.length <= maxLength
        default:
            break
        }
        return result
    }
}

//MARK: - SelectCardDelegate
extension PayViewController: SelectCardDelegate{
    func selectCardDidSelect(card: CardsInfo) {
        selectedCard = card
        
        if let cardTitle = selectedCard?.cardnumber?.aesDecrypt(key: key, iv: iv){
            selectedCardButton.setTitle("\(cardTitle)", for: .normal)
        }else{
            selectedCardButton.setTitle("Seleccionar Tarjeta", for: .normal)
        }
        //print(selectedCard?.cardnumber?.aesDecrypt(key: key, iv: iv))
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - CLLocationManagerDelegate
extension PayViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("localización encontrada")
        if let location = locations.first{
            print("USER GPS Latitude: \(location.coordinate.latitude)")
            print("USER GPS Longitude: \(location.coordinate.longitude)")
            userLatitude = location.coordinate.latitude
            userLongitude = location.coordinate.longitude
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error location: \(error.localizedDescription)")
    }
}

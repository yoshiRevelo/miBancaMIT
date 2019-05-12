//
//  TransactionDetailViewController.swift
//  MiBanca
//
//  Created by Yoshi Revelo on 5/11/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//

import UIKit
import MapKit

class TransactionDetailViewController: UIViewController {

    
    private var key = (UserDefaults.standard.value(forKey: "password") as! String)
    private var iv = (UserDefaults.standard.value(forKey: "iv") as! String)
    private var locationManager = CLLocationManager()
    private var userLatitude: Double!
    private var userLongitude: Double!
    var transactionDetail: Transactions!
    
    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var transactionUserNameLabel: UILabel!
    
    @IBOutlet weak var transactionCardNumberLabel: UILabel!
    
    @IBOutlet weak var transactionCardExpirationDateLabel: UILabel!
    
    @IBOutlet weak var transactionPayDateLabel: UILabel!
    
    @IBOutlet weak var transactionDestinationNameLabel: UILabel!
    
    @IBOutlet weak var transactionDestinationCardNumberLabel: UILabel!
    
    @IBOutlet weak var transactionPayDescriptionLabel: UILabel!
    
    
    //MARK: - LifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Detalle"
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        configureMap()
        getInfo()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Private Methods
    private func configureMap(){
        
        guard let payLatitude = transactionDetail.payLatitude?.aesDecrypt(key: key, iv: iv) else {return}
        
        guard let payLongitude = transactionDetail.payLongitude?.aesDecrypt(key: key, iv: iv) else {return}
        
        userLatitude = Double(payLatitude)
        userLongitude = Double(payLongitude)
        
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude)
        annotation.coordinate = coordinate
        annotation.title = "Movimiento Realizado"
        
        let span = MKCoordinateSpan(latitudeDelta: 0.050, longitudeDelta: 0.050)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        mapView.addAnnotation(annotation)
    }
    
    private func getInfo(){
        transactionUserNameLabel.text = transactionDetail.username?.aesDecrypt(key: key, iv: iv)
        transactionCardNumberLabel.text = transactionDetail.userCardNumber?.aesDecrypt(key: key, iv: iv)
        transactionCardExpirationDateLabel.text = transactionDetail.cardExpirationDate?.aesDecrypt(key: key, iv: iv)
        transactionPayDateLabel.text = transactionDetail.payDate?.aesDecrypt(key: key, iv: iv)
        transactionDestinationNameLabel.text = transactionDetail.destinationName?.aesDecrypt(key: key, iv: iv)
        transactionDestinationCardNumberLabel.text = transactionDetail.destinationCard?.aesDecrypt(key: key, iv: iv)
        transactionPayDescriptionLabel.text = transactionDetail.payDescription?.aesDecrypt(key: key, iv: iv)
        
    }

}

extension TransactionDetailViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
}

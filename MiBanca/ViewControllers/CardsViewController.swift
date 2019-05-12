//
//  CardsViewController.swift
//  MiBanca
//
//  Created by Yoshi Revelo on 5/10/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//

import UIKit

protocol SelectCardDelegate: class {
    func selectCardDidSelect(card: CardsInfo)
}

class CardsViewController: UIViewController {
    
    weak var delegate: SelectCardDelegate?

    private var userData: [User] = []
    private var dataSource: [CardsInfo] = []
    private var us = (UserDefaults.standard.value(forKey: "user") as! String)
    private var key = (UserDefaults.standard.value(forKey: "password") as! String)
    private var iv = (UserDefaults.standard.value(forKey: "iv") as! String)
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Mis tarjetas"
        loadCards()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCards()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddCardViewController"{
            let addCardViewController = segue.destination as! AddCardViewController
            addCardViewController.delegate = self
        }
    }
 
    //MARK: - User interaction
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Cerrar Sesión", message: "¿Está seguro que desea cerrar sesión?", preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            UserDefaults.standard.removeObject(forKey: "password")
            UserDefaults.standard.removeObject(forKey: "user")
            UserDefaults.standard.removeObject(forKey: "iv")
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let board = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = board.instantiateViewController(withIdentifier: "LoginViewController")
            delegate.window?.rootViewController = loginViewController
        }
        
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    //MARK: - Private Methods
    private func loadCards(){
        userData = CoreDataManager.sharedInstance.readData(class: User.self)
        
        //print(userData.count)
        for user in userData {
            //print("Name: \(user.user!)")
            
            if user.user == us.aesEncrypt(key: key, iv: iv){
                dataSource = user.cardsInfo?.allObjects as! [CardsInfo]
                //print(dataSource.count)
            }
        }
    }
    
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension CardsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCardsTableViewCell") as! SavedCardsTableViewCell
        
        cell.card = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCard = dataSource[indexPath.row]
        delegate?.selectCardDidSelect(card: selectedCard)
    }
}

//MARK: - protocol
extension CardsViewController: AddCardDelegate{
    func addCardDidCreate(user: User, cardInfo: CardsInfo) {

        dataSource.append(cardInfo)
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}

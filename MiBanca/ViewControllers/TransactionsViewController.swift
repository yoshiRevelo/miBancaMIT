//
//  TransactionsViewController.swift
//  MiBanca
//
//  Created by Yoshi Revelo on 5/11/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController {

    private var userData: [User] = []
    private var dataSource: [Transactions] = []
    private var us = (UserDefaults.standard.value(forKey: "user") as! String)
    private var key = (UserDefaults.standard.value(forKey: "password") as! String)
    private var iv = (UserDefaults.standard.value(forKey: "iv") as! String)
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Movimientos"
        
        /*userData = CoreDataManager.sharedInstance.readData(class: User.self)
        
        for user in userData {
            if user.user == us.aesEncrypt(key: key, iv: iv){
                dataSource = user.transaction?.allObjects as! [Transactions]
            }
        }*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        userData = CoreDataManager.sharedInstance.readData(class: User.self)
        
        for user in userData {
            if user.user == us.aesEncrypt(key: key, iv: iv){
                dataSource = user.transaction?.allObjects as! [Transactions]
            }
        }
        tableView.reloadData()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TransactionDetailViewController"{
            let transactionDetailViewController = segue.destination as! TransactionDetailViewController
            transactionDetailViewController.transactionDetail = (sender as! Transactions)
        }
    }
    

}

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsTableViewCell") as! TransactionsTableViewCell
        cell.transaction = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let moves = dataSource[indexPath.row]
        performSegue(withIdentifier: "TransactionDetailViewController", sender: moves)
    }
    
}

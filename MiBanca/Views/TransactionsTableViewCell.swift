//
//  TransactionsTableViewCell.swift
//  MiBanca
//
//  Created by Yoshi Revelo on 5/11/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {
    
    private var key = (UserDefaults.standard.value(forKey: "password") as! String)
    private var iv = (UserDefaults.standard.value(forKey: "iv") as! String)
    
    //MARK: Outlets
    @IBOutlet weak var transactionCardLabel: UILabel!
    
    @IBOutlet weak var transactionCardDescription: UILabel!
    
    @IBOutlet weak var transactionCardDate: UILabel!
    
    
    var transaction: Transactions!{
        didSet{
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    //MARK: - Private methods
    private func configureCell(){
        transactionCardLabel.text = transaction.userCardNumber?.aesDecrypt(key: key, iv: iv)
        transactionCardDescription.text = "Descripcion \n \(transaction.payDescription!.aesDecrypt(key: key, iv: iv))"
        transactionCardDate.text = transaction.payDate?.aesDecrypt(key: key, iv: iv)
    }
}

//
//  SavedCardsTableViewCell.swift
//  MiBanca
//
//  Created by Yoshi Revelo on 5/11/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//

import UIKit

class SavedCardsTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardExpirationDateLabel: UILabel!
    
    
    private var key = (UserDefaults.standard.value(forKey: "password") as! String)
    private var iv = (UserDefaults.standard.value(forKey: "iv") as! String)
    
    var card: CardsInfo!{
        didSet{
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Private methods
    private func configureCell(){
        cardNameLabel.text = card.name?.aesDecrypt(key: key, iv: iv)
        cardNumberLabel.text = card.cardnumber?.aesDecrypt(key: key, iv: iv)
        cardExpirationDateLabel.text = card.cardExpirationDate?.aesDecrypt(key: key, iv: iv)
    }

}

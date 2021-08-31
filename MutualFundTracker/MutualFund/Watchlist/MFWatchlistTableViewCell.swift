//
//  MFWatchlistTableViewCell.swift
//  MutualFundTracker
//
//  Created by Rajesh RAMSHETTY SIDDARAJU on 16/03/21.
//

import UIKit

class MFWatchlistTableViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var change: UILabel!
    
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var valueStackView: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupWithModel(model: MFWatchlistTableViewCellModel) {
        name.text = model.name
        details.text = model.details
        value.text = String(describing: model.value)
        change.text = model.change
        change.textColor = model.changeColor
    }

}

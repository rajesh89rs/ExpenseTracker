//
//  MFSearchTableViewCell.swift
//  MutualFundTracker
//
//  Created by Rajesh RAMSHETTY SIDDARAJU on 22/03/21.
//

import UIKit

class MFSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var code: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupWithModel(model: MFSearchTableViewCellModel) {
        name.text = model.name
        code.text = model.code
    }

}

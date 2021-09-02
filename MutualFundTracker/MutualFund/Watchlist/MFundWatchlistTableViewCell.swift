//
//  MFundWatchlistTableViewCell.swift
//  MutualFundTracker
//
//  Created by Rajesh RAMSHETTY SIDDARAJU on 02/09/21.
//

import UIKit

class MFundWatchlistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mfTitleLabel: UILabel!
    @IBOutlet weak var cagrLabel: UILabel!
    @IBOutlet weak var cagrValueLabel: UILabel!
    @IBOutlet weak var navLabel: UILabel!
    @IBOutlet weak var navValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cagrLabel.textColor = .gray50
        navLabel.textColor = .gray50
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupWithModel(model: MFWatchlistTableViewCellModel) {
        mfTitleLabel.text = model.name
        cagrValueLabel.text = model.cagr
        cagrValueLabel.textColor = model.cagrColor
        navValueLabel.text = String(format: "%@ (%@)", model.nav ?? "", model.change ?? "")
        navValueLabel.textColor = model.changeColor
    }
    
}

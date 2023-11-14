//
//  BookCell.swift
//  ios101-lab5-flix1
//
//  Created by Saintlonglive on 11/13/23.
//

import UIKit

class BookCell: UITableViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authors: UILabel!
    @IBOutlet weak var publishYear: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

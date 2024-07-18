//
//  ListTableCell.swift
//  HomePage Demo
//
//  Created by DREAMWORLD on 18/07/24.
//

import UIKit

class ListTableCell: UITableViewCell {

    @IBOutlet weak var img_item: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

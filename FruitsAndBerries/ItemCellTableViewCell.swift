//
//  ItemCellTableViewCell.swift
//  iOS-Test
//
//  Created by Vlad on 1/4/24.
//

import UIKit

class ItemCellTableViewCell: UITableViewCell {

    //back of cell
    @IBOutlet weak var ItemVievBackground: UIView!
    //left text of cell
    @IBOutlet weak var ItemName: UILabel!
    //right image of cell
    @IBOutlet weak var ItemImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

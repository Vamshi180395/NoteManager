//
//  NotebookCellController.swift
//  InClass06App
//
//  Created by Dhulipala, Rama Vamshi Krishna on 10/20/17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit

class NotebookCellController: UITableViewCell {

    @IBOutlet weak var lbl_notebookdatetime: UILabel!
    @IBOutlet weak var lbl_notebookname: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

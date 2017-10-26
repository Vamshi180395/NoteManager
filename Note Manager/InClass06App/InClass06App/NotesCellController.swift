//
//  NotesCellController.swift
//  InClass06App
//
//  Created by Dhulipala, Rama Vamshi Krishna on 10/20/17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit
protocol OptionButtonsDelegate{
    func deleteSelectedNote(at index:IndexPath)
}

class NotesCellController: UITableViewCell {
    
    @IBOutlet weak var btndelete: UIButton!
    @IBOutlet weak var lbl_notedatetime: UILabel!
    @IBOutlet weak var lbl_notedesc: UILabel!
    var delegate:OptionButtonsDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var indexPath:IndexPath!
    @IBAction func deleteSelected(_ sender: Any) {
        self.delegate?.deleteSelectedNote(at: indexPath)
    }
    
}

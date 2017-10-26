//
//  Note.swift
//  InClass06App
//
//  Created by Dhulipala, Rama Vamshi Krishna on 10/20/17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit

class Note: NSObject {
    let note_id:String;
    let note_desc:String;
    let note_created_datetime:String;
    init(note_id:String, note_text:String, note_created_datetime:String) {
        self.note_id = note_id;
        self.note_desc = note_text;
        self.note_created_datetime = note_created_datetime;
    }
}

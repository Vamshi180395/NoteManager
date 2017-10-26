//
//  Notebook.swift
//  InClass06App
//
//  Created by Dhulipala, Rama Vamshi Krishna on 10/20/17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit

class Notebook: NSObject {
    let notebook_id:String;
    let notebook_name:String;
    let notebook_created_datetime:String;
    init(notebook_name:String, notebook_created_datetime:String, notebook_id:String) {
        self.notebook_name = notebook_name;
        self.notebook_created_datetime = notebook_created_datetime;
        self.notebook_id = notebook_id;
    }
}

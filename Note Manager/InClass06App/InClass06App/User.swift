//
//  User.swift
//  InClass06App
//
//  Created by Dhulipala, Rama Vamshi Krishna on 10/20/17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit

class User: NSObject {
    let user_name:String;
    let user_email:String;
    let user_password:String;
    var listof_notebooks:[Notebook]
    init(name:String, email:String, password:String,listof_notebooks:[Notebook]) {
        self.user_name = name;
        self.user_email = email;
        self.user_password = password;
        self.listof_notebooks = listof_notebooks;
    }
}

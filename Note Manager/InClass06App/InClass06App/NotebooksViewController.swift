//
//  NotebooksViewController.swift
//  InClass06App
//
//  Created by Dhulipala, Rama Vamshi Krishna on 10/20/17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit
import Firebase


class NotebooksViewController: UITableViewController {
    let root_ref = Database.database().reference();
    var list_notebooks:[Notebook] = [];
    var current_user_id:String!;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.current_user_id = UserDefaults.standard.string(forKey: "Current_User_ID")
        getListOfNotebooksForCurrentUser(user_uid: self.current_user_id);
    }
    
    func createNewNoteBook(forUser:String, notebook_name:String) {
        let newNoteBookRef = self.root_ref.child("NoteManager").child(forUser).child("notebooks").childByAutoId()
        let newNoteBookId = newNoteBookRef.key
        let newNoteBook = [
            "notebook_id": newNoteBookId,
            "datetime": DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short) as! NSString,
            "name": notebook_name as! NSString,
            ] as [String : Any]
        newNoteBookRef.setValue(newNoteBook);
    }

    func getListOfNotebooksForCurrentUser(user_uid:String) {
        let notebook_ref_for_currentuser = self.root_ref.child("NoteManager").child(self.current_user_id).child("notebooks");
        notebook_ref_for_currentuser.observe(.value, with: { snapshot in
            if let allnotebooks = snapshot.value as? [String:AnyObject] {
                self.list_notebooks.removeAll();
                for (_,notebook) in allnotebooks {
                    let notebook_name = notebook["name"]! as! String
                    let notebook_datetime = notebook["datetime"]! as! String
                    let notebook_id = notebook["notebook_id"]! as! String
                    self.list_notebooks.append(Notebook(notebook_name: notebook_name,notebook_created_datetime: notebook_datetime,notebook_id: notebook_id));
                }
                self.tableView.reloadData();
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    
    @IBAction func showAlertForAddingNewNotebook(_ sender: Any) {
        let alert = UIAlertController(title: "New Notebook", message: "Enter Notebook Name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Notebook Name"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if(!(textField?.text?.isEmpty)!){
                self.createNewNoteBook(forUser:self.current_user_id,notebook_name: (textField?.text)!);
            }
            else{
                self.showAlert(displayMessage: "Plese enter a valid name to add..");
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style:.cancel, handler: nil));
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(displayMessage:String){
        let alertController = UIAlertController(title: "Message", message: displayMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if(self.list_notebooks.count > 0){
            return 1;
        };
        return 0;
    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list_notebooks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotebookCell", for: indexPath) as! NotebookCellController
        cell.lbl_notebookname.text = self.list_notebooks[indexPath.row].notebook_name;
        cell.lbl_notebookdatetime.text = self.list_notebooks[indexPath.row].notebook_created_datetime;


        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_to_notes"{
            if let notesVC = segue.destination as? NotesViewController{
                notesVC.current_notebook_id = self.list_notebooks[(self.tableView.indexPathForSelectedRow?.row)!].notebook_id;
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95;
    }

}

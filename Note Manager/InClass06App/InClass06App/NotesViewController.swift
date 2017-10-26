//
//  NotesViewController.swift
//  InClass06App
//
//  Created by Dhulipala, Rama Vamshi Krishna on 10/20/17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit
import Firebase

class NotesViewController: UITableViewController, OptionButtonsDelegate {
 
    let root_ref = Database.database().reference();
    var list_notes:[Note] = [];
    var current_user_id:String!;
    var current_notebook_id:String!;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.current_user_id = UserDefaults.standard.string(forKey: "Current_User_ID");
        getListOfNotesForCurrentNotebook(user_uid: current_user_id, current_notebook_id: current_notebook_id);
    }

    func createNewNoteInFireBase(forUser:String, current_notebook_id: String, note_desc:String) {
        super.didReceiveMemoryWarning()
        let newNoteRef = self.root_ref.child("NoteManager").child(forUser).child("Notes").child(current_notebook_id).childByAutoId()
        let newNoteId = newNoteRef.key
        let newNote = [
            "note_id": newNoteId,
            "note_datetime": DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short) as! NSString,
            "note_desc": note_desc as! NSString,
            ] as [String : Any]
        newNoteRef.setValue(newNote);
    }
    
    func getListOfNotesForCurrentNotebook(user_uid:String, current_notebook_id: String) {
        super.didReceiveMemoryWarning()
        let notebook_ref_for_currentuser = self.root_ref.child("NoteManager").child(self.current_user_id).child("Notes").child(current_notebook_id);
        notebook_ref_for_currentuser.observe(.value, with: { snapshot in
            if let allnotes = snapshot.value as? [String:AnyObject] {
                self.list_notes.removeAll();
                for (_,note) in allnotes {
                    let note_desc = note["note_desc"]! as! String
                    let note_datetime = note["note_datetime"]! as! String
                    let note_id = note["note_id"]! as! String
                    self.list_notes.append(Note(note_id: note_id,note_text: note_desc,note_created_datetime: note_datetime));
                }
                self.tableView.reloadData();
            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if(self.list_notes.count > 0){
            return 1;
        };
        return 0;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return self.list_notes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NotesCellController
        cell.delegate = self
        cell.indexPath = indexPath
        cell.lbl_notedesc.text = self.list_notes[indexPath.row].note_desc;
        cell.lbl_notedatetime.text = self.list_notes[indexPath.row].note_created_datetime;
        return cell
    }
    
    @IBAction func createANewNote(_ sender: Any) {
        let alert = UIAlertController(title: "New Note", message: "Enter new post text", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Note Text"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if(!(textField?.text?.isEmpty)!){
                self.createNewNoteInFireBase(forUser: self.current_user_id, current_notebook_id: self.current_notebook_id, note_desc: (textField?.text)!);
            }
            else{
                self.showAlert(displayMessage: "Plese enter valid text to add..");
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
    
    func deleteSelectedNote(at index: IndexPath) {
        let current_node_id_to_delete = self.list_notes[index.row].note_id;
        let note_ref_for_deletion = self.root_ref.child("NoteManager").child(self.current_user_id).child("Notes").child(current_notebook_id).child(current_node_id_to_delete);
        note_ref_for_deletion.removeValue(completionBlock: { (error, reference) in
            if error != nil {
                self.tableView.reloadData();
            }
        })
        self.list_notes.remove(at: index.row);
        self.tableView.reloadData();
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
  //  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //  return 100;
   // }

}

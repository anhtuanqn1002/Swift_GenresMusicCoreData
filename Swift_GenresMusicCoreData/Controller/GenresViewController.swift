//
//  GenresViewController.swift
//  Swift_GenresMusicCoreData
//
//  Created by Anh Tuan on 5/15/16.
//  Copyright © 2016 Anh Tuan. All rights reserved.
//

import UIKit

protocol GenresViewControllerDelegate: class {
    func insertItem (item: Track)
}

class GenresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, GenresAndSongTableViewCellDelegate, SongsViewControllerDelegate {
    weak var delegate: GenresViewControllerDelegate?
    var listGenres = [Track]()
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        listGenres = DatabaseManager.shareInstance.getListTrack("Track", type: 0) 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Delegate
    func moveTo(cell: TrackTableViewCell) {
        let index = self.tableView.indexPathForCell(cell)
        let item = self.listGenres[index!.row]
        self.listGenres.removeAtIndex(index!.row)
        self.tableView.deleteRowsAtIndexPaths([index!], withRowAnimation: .Automatic)
        item.type = 1
        if (DatabaseManager.shareInstance.updateDataOfRow()) {
            print("success")
        } else {
            print("fail")
        }
        
        self.delegate?.insertItem(item)
    }
    func insertItem(item: Track) -> Void {
        self.listGenres.append(item)
        self.tableView .beginUpdates()
        let indexPath = NSIndexPath(forRow: self.listGenres.count - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.tableView.endUpdates()
    }
    
    // MARK: - Table view datasource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TrackTableViewCell")
        if (cell == nil) {
            cell = TrackTableViewCell.newCellWithIdentifier("TrackTableViewCell")
        }
        (cell as! TrackTableViewCell).displayCellWithModel(listGenres[indexPath.row])
        (cell as! TrackTableViewCell).delegate = self
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listGenres.count
    }
    
    // MARK: - Events of AlertController
    @IBAction func addNewSong(sender: UIBarButtonItem) {
        let alertController = UIAlertController.init(title: "New a song", message: "Add a new song", preferredStyle: .Alert)
        let okAction = UIAlertAction.init(title: "OK", style: .Default) { (UIAlertAction) in
            // Insert a new song to data (core data)
            DatabaseManager.shareInstance.insertRowToTable("Track", title: "\(((alertController.textFields?.first)! as UITextField).text!)", type: 0)
            self.listGenres = DatabaseManager.shareInstance.getListTrack("Track", type: 0) 
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addTextFieldWithConfigurationHandler { (text) -> Void in
            text.placeholder = "Enter name a song!"
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alertController = UIAlertController.init(title: "Edit a song", message: "Edit a song", preferredStyle: .Alert)
        let okAction = UIAlertAction.init(title: "OK", style: .Default) { (UIAlertAction) in
            // Update a song to data (core data)
            self.listGenres[indexPath.row].title = ((alertController.textFields?.first)! as UITextField).text!
            DatabaseManager.shareInstance.updateDataOfRow()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addTextFieldWithConfigurationHandler { (text) -> Void in
            text.placeholder = "Enter name a song!"
            text.text = self.listGenres[indexPath.row].title
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            if (DatabaseManager.shareInstance.deleteRowWithModel(self.listGenres[indexPath.row])) {
                self.listGenres.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

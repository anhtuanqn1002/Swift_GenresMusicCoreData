//
//  SongsViewController.swift
//  Swift_GenresMusicCoreData
//
//  Created by Anh Tuan on 5/15/16.
//  Copyright © 2016 Anh Tuan. All rights reserved.
//

import UIKit

protocol SongsViewControllerDelegate: class {
    func insertItem (item: Track)
}

class SongsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GenresAndSongTableViewCellDelegate, GenresViewControllerDelegate {
    
    weak var delegate: SongsViewControllerDelegate?
    var listSongs = [Track]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        listSongs = DatabaseManager.shareInstance.getListTrack("Track", type: 1) 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Delegate
    func moveTo(cell: TrackTableViewCell) {
        let index = self.tableView.indexPathForCell(cell)
        let item = self.listSongs[index!.row]
        self.listSongs.removeAtIndex(index!.row)
        self.tableView.deleteRowsAtIndexPaths([index!], withRowAnimation: .Automatic)
        item.type = 0
        if (DatabaseManager.shareInstance.updateDataOfRow()) {
            print("success")
        } else {
            print("fail")
        }
        
        self.delegate?.insertItem(item)
    }
    func insertItem(item: Track) -> Void {
        self.listSongs.append(item)
        self.tableView .beginUpdates()
        let indexPath = NSIndexPath(forRow: self.listSongs.count - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.tableView.endUpdates()
//        [self.tableView beginUpdates];
//        NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:[self.songListItems count]-1 inSection:0];
//        [self.tableView insertRowsAtIndexPaths:@[indexPathNew] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView endUpdates];
        
    }
    
    // MARK: - Tableview datasource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TrackTableViewCell")
        if (cell == nil) {
            cell = TrackTableViewCell.newCellWithIdentifier("TrackTableViewCell")
        }
        (cell as! TrackTableViewCell).displayCellWithModel(listSongs[indexPath.row])
        (cell as! TrackTableViewCell).delegate = self
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSongs.count;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alertController = UIAlertController.init(title: "Edit a song", message: "Edit a song", preferredStyle: .Alert)
        let okAction = UIAlertAction.init(title: "OK", style: .Default) { (UIAlertAction) in
            // Update a song to data (core data)
            self.listSongs[indexPath.row].title = ((alertController.textFields?.first)! as UITextField).text!
            DatabaseManager.shareInstance.updateDataOfRow()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addTextFieldWithConfigurationHandler { (text) -> Void in
            text.placeholder = "Enter name a song!"
            text.text = self.listSongs[indexPath.row].title
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

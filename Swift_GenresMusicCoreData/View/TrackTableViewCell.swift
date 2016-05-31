//
//  TrackTableViewCell.swift
//  Swift_GenresMusicCoreData
//
//  Created by Anh Tuan on 5/15/16.
//  Copyright © 2016 Anh Tuan. All rights reserved.
//

import UIKit

protocol GenresAndSongTableViewCellDelegate: class {
    func moveTo(cell: TrackTableViewCell) -> Void
}
class TrackTableViewCell: UITableViewCell {
    
    weak var delegate: GenresAndSongTableViewCellDelegate?
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var titleTrack: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK:- Create a new cell with identifier
    class func newCellWithIdentifier(reuseIdentifier: String) -> TrackTableViewCell {
        let cell:TrackTableViewCell = NSBundle.mainBundle().loadNibNamed(String(TrackTableViewCell), owner: nil, options: nil)[0] as! TrackTableViewCell
        cell.setValue(reuseIdentifier, forKey: "reuseIdentifier")
        return cell
    }
    
    func displayCellWithModel(model: Track) -> Void {
        titleTrack.text = model.title
    }
    @IBAction func moveAction(sender: AnyObject) {
        self.delegate!.moveTo(self)
    }
}

//
//  DatabaseManager.swift
//  Swift_GenresMusicCoreData
//
//  Created by Anh Tuan on 5/25/16.
//  Copyright © 2016 Anh Tuan. All rights reserved.
//

import UIKit
import CoreData

class DatabaseManager {
    static let shareInstance = DatabaseManager()
    private let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    private var context = NSManagedObjectContext()
    
    private init() {
        
    }
    
    /**
     Insert a new song to table in CoreData
     
     - parameter table: Entity name (Track)
     - parameter title: Name of song
     - parameter type:  0 insert to genres, 1 insert to songs
     
     - returns: insert is successful or fail 
     */
    func insertRowToTable(table: String, title: String, type: Int) -> Bool {
        let newSong = NSEntityDescription.insertNewObjectForEntityForName(table, inManagedObjectContext: context)
        newSong.setValue(title, forKey: "title")
        newSong.setValue(type, forKey: "type")
        
        do {
            try self.context.save()
            return true
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            return false
        }
    }
    
    /**
     Get list songs
     
     - parameter table: Entity name
     - parameter type:  0 is genres, 1 is songs
     
     - returns: Array track objects
     */
    func getListTrack(table: String, type: Int) -> [Track] {
        print(NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)[0])
        self.context = self.appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Track")
        let predicate = NSPredicate(format: "type == %d", type)
        request.predicate = predicate
        do {
            let results = try self.context.executeFetchRequest(request)
            return results as! [Track]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return []
        }
    }
    
    /**
     Update a song
     
     - returns: true is success, false is fail
     */
    func updateDataOfRow() -> Bool {
        do {
            try self.context.save()
            return true
        } catch let error as NSError {
            print("Could not update \(error), \(error.userInfo)")
            return false
        }
    }
    
    /**
     Delete a song
     
     - parameter model: Track object
     
     - returns: true is success, false is fail
     */
    func deleteRowWithModel(model: Track) -> Bool {
        do {
            self.context.deleteObject(model)
            try self.context.save()
            return true
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
            return false
        }
    }
}

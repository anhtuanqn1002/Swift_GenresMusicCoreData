//
//  Track+CoreDataProperties.swift
//  Swift_GenresMusicCoreData
//
//  Created by Anh Tuan on 5/26/16.
//  Copyright © 2016 Anh Tuan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Track {

    @NSManaged var title: String?
    @NSManaged var type: NSNumber?

}

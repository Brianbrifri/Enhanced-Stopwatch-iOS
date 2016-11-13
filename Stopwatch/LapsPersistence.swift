//
//  LapsPersistence.swift
//  Stopwatch
//
//  Created by vm mac on 11/13/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import Foundation
import CoreData

class LapsPersistence {
    private let context: NSManagedObjectContext
    
    init() {
        let coreDataManager = CoreDataManager.sharedManager()
        self.context = coreDataManager.managedObjectContext
    }
    
    func fetchLapData() -> [TimeInterval] {
        let entity = NSEntityDescription.entity(forEntityName: "LapEntity", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        
        do {
            var laps = [TimeInterval]()
            let results = try context.fetch(fetchRequest)
            for lap in results {
                laps.append((lap as! LapEntity).time)
            }
            return laps
        } catch {
            return []
        }
    }
    
    func insertLapData(from lapTime: TimeInterval) {
        let lapEntity = NSEntityDescription.insertNewObject(forEntityName: "LapEntity", into: context) as! LapEntity
        lapEntity.time = lapTime
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func deleteLaps() {
        let entity = NSEntityDescription.entity(forEntityName: "LapEntity", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

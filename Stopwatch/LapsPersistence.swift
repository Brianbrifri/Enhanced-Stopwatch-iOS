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
        //Create the datamanager and get context
        let coreDataManager = CoreDataManager.sharedManager()
        self.context = coreDataManager.managedObjectContext
    }
    
    //Mark: - persistence functions
    
    //Returns an array of TimeIntervals for the laps
    func fetchLapData() -> [TimeInterval] {
        let entity = NSEntityDescription.entity(forEntityName: "LapEntity", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        
        //Try to fetch all the LapEntities in Core Data
        //and append them to the array of laps
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
    
    //Creates a new object to insert into LapEntity of type TimeInterval
    func insertLapData(from lapTime: TimeInterval) {
        let lapEntity = NSEntityDescription.insertNewObject(forEntityName: "LapEntity", into: context) as! LapEntity
        lapEntity.time = lapTime
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //Does a batch delete on all the lap data
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
    
    //Updates the SaveStateEntity with the master time, lap time, and save state
    func updateSaveState(with time: TimeInterval, lapTime: TimeInterval, runState: Int16) {
        let entity = NSEntityDescription.entity(forEntityName: "SaveStateEntity", in: context)
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>()
        fetchrequest.entity = entity
        
        do {
            //Do a fetch on the entity to see if there is any existing data
            let results = try context.fetch(fetchrequest)
            
            //If no, create a new object to insert into SaveStateEntity with the 
            //provided data
            if results.count == 0 {
                print("Found count of results to be 0")
                let saveEntity = NSEntityDescription.insertNewObject(forEntityName: "SaveStateEntity", into: context) as! SaveStateEntity
                saveEntity.time = time
                saveEntity.lapTime = lapTime
                saveEntity.runState = runState
            }
            //If there is data, update the existing data with the provided data
            else {
                print("Found count of results to be more than 0")
                for result in results {
                    (result as! SaveStateEntity).setValue(time, forKey: "time")
                    (result as! SaveStateEntity).setValue(lapTime, forKey: "lapTime")
                    (result as! SaveStateEntity).setValue(runState, forKey: "runState")
                }
            }
            
            //Save the context, will work for either of the options above
            do {
                try context.save()
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //Returns the save state's master time, lap time, and run state
    func retreiveSaveState() -> (time: TimeInterval, lapTime: TimeInterval, runState: Int16) {
        let entity = NSEntityDescription.entity(forEntityName: "SaveStateEntity", in: context)
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>()
        fetchrequest.entity = entity
        
        do {
            //Make these optional as there may be no data in Core Data
            var time: TimeInterval!
            var lapTime: TimeInterval!
            var runState: Int16!
            let results = try context.fetch(fetchrequest)
            
            for result in results {
                time = (result as! SaveStateEntity).time
                lapTime = (result as! SaveStateEntity).lapTime
                runState = (result as! SaveStateEntity).runState
            }
            return (time ?? 0, lapTime ?? 0, runState ?? -1)
        } catch {
            return (0, 0, 0)
        }
    }
}

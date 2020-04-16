//
//  DataController.swift
//  LOG
//
//  Created by zeyadel3ssal on 6/10/19.
//  Copyright © 2019 zeyadel3ssal. All rights reserved.
//

import Foundation
import CoreData

class DataController{
    

    let persistentContainer : NSPersistentContainer
    
    //Create an object context to deal with attributes
    var viewContext : NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    //Intialize a persistent container with our data model name
    init(modelName:String){
            persistentContainer = NSPersistentContainer(name:modelName)
    }
    
    //Load data from persistent store
    func load(completion:(()->Void)?=nil){
        persistentContainer.loadPersistentStores(){(storeDescription,error) in
            guard error == nil else{
                print("There is error with loading data:\(String(describing: error?.localizedDescription))")
                return
            }
            completion?()
        }
    }
}

extension DataController{
    
    func autoSaveViewContext(interval : TimeInterval = 30){
        
        if viewContext.hasChanges{
            try? viewContext.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval){
            self.autoSaveViewContext(interval: interval)
        }
        
    }
}

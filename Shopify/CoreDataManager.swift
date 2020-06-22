//
//  CoreDataManager.swift
//  Shopify
//
//  Created by nikhil on 20/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//


import CoreData
import UIKit


protocol Fetchable
{
    associatedtype FetchableType: NSManagedObject = Self
    associatedtype AttributeName: RawRepresentable
    
    static var entityName : String { get }
    static var entityDescription : NSEntityDescription { get }
    static var managedObjectContext : NSManagedObjectContext { get }
    
    static func objects() throws -> [FetchableType]
    static func objects(for predicate: NSPredicate?, sortedBy: AttributeName?, ascending: Bool, fetchLimit: Int) throws -> [FetchableType]
    static func objects(sortedBy sortDescriptors: [NSSortDescriptor], predicate: NSPredicate?, fetchLimit: Int) throws -> [FetchableType]
    static func objects(sortedBy sortCriteria: (AttributeName, Bool)..., predicate: NSPredicate?, fetchLimit: Int) throws -> [FetchableType]
    
    static func object() throws -> FetchableType?
    static func object(for predicate: NSPredicate?, sortedBy: AttributeName?, ascending: Bool) throws -> FetchableType?
    static func object(sortedBy sortDescriptors: [NSSortDescriptor], predicate: NSPredicate?) throws -> FetchableType?
    static func object(sortedBy sortCriteria: (AttributeName, Bool)..., predicate: NSPredicate?) throws -> FetchableType?
    
    static func objectCount(for predicate: NSPredicate?) throws -> Int
    static func insertNewObject() -> FetchableType
    static func deleteAll() throws
}

extension Fetchable where Self : NSManagedObject, AttributeName.RawValue == String
{
    static var entityName : String {
        return String(describing:self)
    }
    
    static var entityDescription : NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)!
    }
    
    
    static var managedObjectContext : NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    static func objects() throws -> [FetchableType] {
        let request = fetchRequest(predicate: nil, sortedBy: nil, ascending:true, fetchLimit: 0)
        return try managedObjectContext.fetch(request)
    }
    
    static func objects(for predicate: NSPredicate? = nil,
                        sortedBy: AttributeName? = nil,
                        ascending: Bool = true,
                        fetchLimit: Int = 0) throws -> [FetchableType]
    {
        let request = fetchRequest(predicate: predicate, sortedBy: sortedBy, ascending: ascending, fetchLimit: fetchLimit)
        return try managedObjectContext.fetch(request)
    }
    
    static func objects(sortedBy sortDescriptors: [NSSortDescriptor],
                        predicate: NSPredicate? = nil,
                        fetchLimit: Int = 0) throws -> [FetchableType]
    {
        let request = fetchRequest(predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit)
        return try managedObjectContext.fetch(request)
    }
    
    
    static func objects(sortedBy sortCriteria: (AttributeName, Bool)...,
                        predicate: NSPredicate? = nil,
                        fetchLimit: Int = 0) throws -> [FetchableType]
    {
        let sortDescriptors = sortCriteria.map{ NSSortDescriptor(key: $0.0.rawValue, ascending: $0.1)  }
        let request = fetchRequest(predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit)
        return try managedObjectContext.fetch(request)
    }
    
    
    static func object() throws -> FetchableType? {
        let request = fetchRequest(predicate: nil, sortedBy: nil, ascending:true, fetchLimit: 1)
        return try managedObjectContext.fetch(request).first
    }
    
    
    static func object(for predicate: NSPredicate? = nil,
                       sortedBy: AttributeName? = nil,
                       ascending: Bool = true) throws -> FetchableType?
    {
        return try objects(for: predicate, sortedBy: sortedBy, ascending: ascending).first
    }
    
    
    static func object(sortedBy sortDescriptors: [NSSortDescriptor],
                       predicate: NSPredicate? = nil) throws -> FetchableType?
    {
        return try objects(sortedBy: sortDescriptors, predicate: predicate, fetchLimit: 1).first
    }
    
    
   static func object(sortedBy sortCriteria: (AttributeName, Bool)...,
                        predicate: NSPredicate? = nil) throws -> FetchableType?
    {
        let sortDescriptors = sortCriteria.map{ NSSortDescriptor(key: $0.0.rawValue, ascending: $0.1)  }
        return try objects(sortedBy: sortDescriptors, predicate: predicate, fetchLimit: 1).first
    }
    
    
    static func objectCount(for predicate: NSPredicate? = nil) throws -> Int
    {
        let request = fetchRequest(predicate: predicate)
        return try managedObjectContext.count(for: request)
    }
    
    
    private static func fetchRequest(predicate: NSPredicate? = nil,
                             sortedBy: AttributeName? = nil,
                             ascending: Bool = true,
                             fetchLimit: Int = 0) -> NSFetchRequest<FetchableType>
    {
        let sortDescriptors : [NSSortDescriptor]? = sortedBy != nil ? [NSSortDescriptor(key: sortedBy!.rawValue, ascending: ascending)] : nil
        return fetchRequest(predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit)
    }
    
    
    private static func fetchRequest(predicate: NSPredicate? = nil,
                             sortDescriptors: [NSSortDescriptor]?,
                             fetchLimit: Int = 0) -> NSFetchRequest<FetchableType>
    {
        let request = NSFetchRequest<FetchableType>(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        request.fetchLimit = fetchLimit
        return request
    }
    
    
    static func insertNewObject() -> FetchableType
    {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! FetchableType
    }
    
    
    static func deleteAll() throws
    {
        let request = NSFetchRequest<FetchableType>(entityName: entityName)
        if #available(iOS 9, macOS 10.11, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
            let persistentStoreCoordinator = managedObjectContext.persistentStoreCoordinator!
            try persistentStoreCoordinator.execute(deleteRequest, with: managedObjectContext)
        } else {
            let fetchResults = try managedObjectContext.fetch(request)
            for anItem in fetchResults {
                managedObjectContext.delete(anItem)
            }
        }
    }
}

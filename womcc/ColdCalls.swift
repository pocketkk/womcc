import CoreData
import UIkit
@objc(ColdCalls)
class ColdCalls: NSManagedObject {

    @NSManaged var business_name:   String
    @NSManaged var address:         String
    @NSManaged var city:            String
    @NSManaged var contact:         String
    @NSManaged var note:            String
    @NSManaged var setup_meeting:   String
    @NSManaged var sold:            String
    @NSManaged var date:            NSDate
    
    class func newEntity() -> NSEntityDescription {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.cdh.managedObjectContext
        return NSEntityDescription.entityForName("ColdCalls", inManagedObjectContext: context)
    }
    
    func fullAddress()-> String {
        return "\(address), \(city)"
    }
    
//    class func fetch(appDel: AppDelegate, context: NSManagedObject, object: ColdCalls) -> ColdCalls {
//        return context.existingObjectWithID(object.objectID, error: nil)
//    }
    
    class func allFromDate(appDel: AppDelegate, context: NSManagedObjectContext, date: NSDate) -> ColdCalls[] {
        var request = NSFetchRequest(entityName: "ColdCalls")
        request.returnsObjectsAsFaults = false
        var searchTerm: NSDate = date
        let bod=Date.beginningOfDay(searchTerm)
        let eod=Date.endOfDay(searchTerm)
        request.predicate = NSPredicate(format: "date > %@ && date < %@", bod, eod)
        var results:NSArray = context.executeFetchRequest(request, error: nil)
        println("Results in tableview: \(results.count)")
        return results as ColdCalls[]
    }
    
    class func allFromDateToDate(appDel: AppDelegate, context: NSManagedObjectContext, fromDate: NSDate, toDate: NSDate) -> ColdCalls[] {
        var request = NSFetchRequest(entityName: "ColdCalls")
        request.returnsObjectsAsFaults = false
        let bod=Date.beginningOfDay(fromDate)
        let eod=Date.endOfDay(toDate)
        request.predicate = NSPredicate(format: "date > %@ && date < %@", bod, eod)
        var results:NSArray = context.executeFetchRequest(request, error: nil)
        println("Results in tableview: \(results.count)")
        return results as ColdCalls[]
    }
    
    class func allFromToday(appDel: AppDelegate, context: NSManagedObjectContext) -> ColdCalls[] {
        return self.allFromDate(appDel, context:context, date: NSDate())
    }
    
    
    class func todayCallsCount(appDel: AppDelegate, context: NSManagedObjectContext) -> Integer {
        return self.allFromToday(appDel, context: context).count
    }
    
    class func todayMeetingsCount(appDel: AppDelegate, context: NSManagedObjectContext) -> Integer {
        let coldCalls: ColdCalls[] = self.allFromToday(appDel, context: context)
        var total = 0
        for coldCall in coldCalls {
            if coldCall.setup_meeting == "yes" {
                total = total + 1
            }
        }
        return total
    }
    
    class func todaySoldCount(appDel: AppDelegate, context: NSManagedObjectContext) -> Integer {
        let coldCalls: ColdCalls[] = self.allFromToday(appDel, context: context)
        var total = 0
        for coldCall in coldCalls {
            if coldCall.sold == "yes" {
                total = total + 1
            }
        }
        return total
    }
}

//
//  ColdCallsDetailViewController.swift
//  womcc
//
//  Created by Jason Crump on 6/29/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit
import CoreData

class ColdCallsDetailViewController: UIViewController {
    
    var coldCall: ColdCalls?
    
    @IBOutlet var lblBusinessName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblContact: UILabel!
    @IBOutlet var lblNotes: UITextView!
    @IBOutlet var lblMeeting: UILabel!
    @IBOutlet var lblSold: UILabel!

    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    func refreshManagedObject(){
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context: NSManagedObjectContext = appDel.cdh.managedObjectContext
        let ent = NSEntityDescription.entityForName("ColdCalls", inManagedObjectContext: context)
//        coldCall = context.existingObjectWithID(_ objectID: NSManagedObjectID!,
//            error error: NSErrorPointer) -> NSManagedObject!
        let id = coldCall!.objectID
        //coldCall = context.existingObjectWithID(self.coldCall!.objectID, error: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblBusinessName.text = self.coldCall!.business_name
        lblAddress.text = self.coldCall!.address
        lblCity.text = self.coldCall!.city
        lblContact.text = self.coldCall!.contact
        lblNotes.text = self.coldCall!.note
        lblMeeting.text = self.coldCall!.setup_meeting
        lblSold.text = self.coldCall!.sold
        // Do any additional setup after loading the view.
        println("viewDidLoad: \(self.navigationController)")
        refreshManagedObject()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var detailsEditController: ColdCallsEditViewController = segue.destinationViewController as ColdCallsEditViewController
        detailsEditController.coldCall = coldCall
    }

}

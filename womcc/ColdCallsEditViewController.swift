//
//  ColdCallsEditViewController.swift
//  womcc
//
//  Created by Jason Crump on 6/29/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit
import CoreData

class ColdCallsEditViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate, UITextFieldDelegate{
    
    var coldCall: ColdCalls?
    var meetingBool = "no"
    var soldBool = "no"
    
    @IBOutlet var txtBusinessName: UITextField!
    @IBOutlet var txtStreetAddress: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtContact: UITextField!
    @IBOutlet var txtNote: UITextView!
    @IBOutlet var lblMeeting: UILabel!
    @IBOutlet var lblSold: UILabel!
    @IBOutlet var scroller: UIScrollView!
    
    @IBAction func updateMeetingStatus() {
        if meetingBool == "no" {
            self.meetingBool = "yes"
            self.lblMeeting.text = "yes"
        } else {
            self.meetingBool = "no"
            self.lblMeeting.text = "no"
        }
    }
    
    @IBAction func updateSoldStatus() {
        if soldBool == "no" {
            self.soldBool = "yes"
            self.lblSold.text = "yes"
        } else {
            self.soldBool = "no"
            self.lblSold.text = "no"
        }
    }
    

    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scroller.contentSize = CGSizeMake(320, 685)
        let scrollPoint: CGPoint = CGPoint( x: 0.0, y: 70)
        scroller.setContentOffset(scrollPoint, animated: true)
        scroller.scrollEnabled = true
        
        txtBusinessName.text = coldCall!.business_name
        txtStreetAddress.text = coldCall!.address
        txtCity.text = coldCall!.city
        txtContact.text = coldCall!.contact
        txtNote.text = coldCall!.note
        lblMeeting.text = coldCall!.setup_meeting
        lblSold.text = coldCall!.sold

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSave() {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context: NSManagedObjectContext = appDel.cdh.managedObjectContext
        let ent = NSEntityDescription.entityForName("ColdCalls", inManagedObjectContext: context)

        var error: NSError?
        coldCall!.business_name   = txtBusinessName.text
        coldCall!.address         = txtStreetAddress.text
        coldCall!.city            = txtCity.text
        coldCall!.contact         = txtContact.text
        coldCall!.note            = txtNote.text
        coldCall!.date            = NSDate()
        coldCall!.setup_meeting   = meetingBool
        coldCall!.sold            = soldBool
        context.save(&error)
        println(coldCall)
        println("Coldcall saved!")
        
//        var alert = UIAlertController(title: "Cold Call", message: "Changes Saved.", preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
        //self.performSegueWithIdentifier("return_to_view", sender: self)
        self.navigationController.popToRootViewControllerAnimated(true)

    }
    

    
    func textViewDidBeginEditing(textView: UITextView!) {
        println("DidbeginEditing")
        let layer = textView.layer
        layer.borderWidth = 1
        let lightGray:UIColor = UIColor(red:0.25, green: 0.25, blue: 0.25, alpha: 0.15)
        layer.borderColor = lightGray.CGColor
        layer.cornerRadius = 4
        let scrollPoint: CGPoint = CGPoint( x: 0.0, y: 100)
        scroller.setContentOffset(scrollPoint, animated: true)
    }
    func textViewDidEndEditing(textView: UITextView!) {
        println("DidendEditing")
        let layer = textView.layer
        layer.borderWidth = 0
        let scrollPoint: CGPoint = CGPoint( x: 0.0, y: 30)
        scroller.setContentOffset(scrollPoint, animated: true)
        self.view.findAndResignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var detailsViewController: ColdCallsDetailViewController = segue.destinationViewController as ColdCallsDetailViewController
        detailsViewController.coldCall = coldCall
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

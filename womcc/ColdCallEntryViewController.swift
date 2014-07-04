//
//  ColdCallEntryViewController.swift
//  womcc
//
//  Created by Jason Crump on 6/20/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import QuartzCore

class ColdCallEntryViewController: UIViewController, CLLocationManagerDelegate, UITextViewDelegate, UIScrollViewDelegate, UITextFieldDelegate{
    
    var coldCalls:ColdCalls[] = []
    var locationManager: CLLocationManager = CLLocationManager()
    var locationReceived: Bool?
    var tempLocation: CLLocation?
    var geocoder = CLGeocoder()
    var meetingBool = "no"
    var soldBool = "no"
    
    let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
        var placemark: CLPlacemark
    }

    @IBOutlet var txtBusinessName: UITextField!
    @IBOutlet var txtStreetAddress: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtContact: UITextField!
    @IBOutlet var txtNote: UITextView!
    @IBOutlet var lblMeeting: UILabel!
    @IBOutlet var lblSold: UILabel!
    @IBOutlet var lblNumberOfCalls: UILabel!
    @IBOutlet var lblNumberOfMeetings: UILabel!
    @IBOutlet var lblNumberOfSold: UILabel!
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
    
    @IBAction func updateLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:AnyObject[]) {
        var currentLocation: CLLocation = locations[0] as CLLocation
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {
            (placemarks, error) in
                println(placemarks)
                if let pm = placemarks?[0] as? CLPlacemark {
                    self.txtBusinessName.text = pm.name
                    self.txtStreetAddress.text = "\(pm.subThoroughfare) \(pm.thoroughfare)"
                    self.txtCity.text = "\(pm.locality)"
                    println(pm.name)
                    println(pm.thoroughfare)
                    println(pm.subThoroughfare)
                    println(pm.locality)
                }
        })
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationReceived = false
        println(error)
        println("Error retrieving Location")
    }
    
    @IBAction func btnSave() {

        var newColdCall = ColdCalls(entity: ColdCalls.newEntity(), insertIntoManagedObjectContext: appDel.cdh.managedObjectContext)
        newColdCall.business_name   = txtBusinessName.text
        newColdCall.address         = txtStreetAddress.text
        newColdCall.city            = txtCity.text
        newColdCall.contact         = txtContact.text
        newColdCall.note            = txtNote.text
        newColdCall.date            = NSDate()
        newColdCall.setup_meeting   = meetingBool
        newColdCall.sold            = soldBool
        appDel.cdh.saveContext()

        clearTextFields()
        updateTotalsLabels()
    }
    
    func textViewDidBeginEditing(textView: UITextView!) {
        let layer = textView.layer
        layer.borderWidth = 1
        let lightGray:UIColor = UIColor(red:0.25, green: 0.25, blue: 0.25, alpha: 0.15)
        layer.borderColor = lightGray.CGColor
        layer.cornerRadius = 4
        let scrollPoint: CGPoint = CGPoint( x: 0.0, y: 100)
        scroller.setContentOffset(scrollPoint, animated: true)
    }
    func textViewDidEndEditing(textView: UITextView!) {
        let layer = textView.layer
        layer.borderWidth = 0
        let scrollPoint: CGPoint = CGPoint( x: 0.0, y: 30)
        scroller.setContentOffset(scrollPoint, animated: true)
        self.view.findAndResignFirstResponder()
    }

    func clearTextFields(){
        for field : UITextField! in [txtBusinessName,txtCity,txtStreetAddress, txtContact] {
            field.text = ""
        }
        txtNote.text = ""
        meetingBool = "no"
        soldBool = "no"
        lblMeeting.text = meetingBool
        lblSold.text = soldBool
    }
    
    func updateTotalsLabels(){
        lblNumberOfCalls.text = "\(ColdCalls.todayCallsCount(appDel, context: appDel.cdh.managedObjectContext))"
        lblNumberOfMeetings.text = "\(ColdCalls.todayMeetingsCount(appDel, context: appDel.cdh.managedObjectContext))"
        lblNumberOfSold.text = "\(ColdCalls.todaySoldCount(appDel, context: appDel.cdh.managedObjectContext))"
    }
    
    func setScrollPosition() {
        let scrollPoint: CGPoint = CGPoint( x: 0.0, y: 30)
        scroller.setContentOffset(scrollPoint, animated: true)
    }
    
    override func viewDidLoad() {
        scroller.contentSize = CGSizeMake(320, 685)
        let scrollPoint: CGPoint = CGPoint( x: 0.0, y: 70)
        scroller.setContentOffset(scrollPoint, animated: true)
        scroller.scrollEnabled = false
        
        CLLocationManager.locationServicesEnabled()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        txtNote.text = ""
        println("Started Location Services")
        println(locationManager)
        updateTotalsLabels()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        updateTotalsLabels()
        updateLocation()
        setScrollPosition()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {

    }
    
    func textFieldShouldBeginEditing(textField: UITextField!) -> Bool{
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        return true
    }
    



}

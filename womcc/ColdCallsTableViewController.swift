//
//  ColdCallsTableViewController.swift
//  womcc
//
//  Created by Jason Crump on 6/22/14.
//  Copyright (c) 2014 Jason Crump. All rights reserved.
//

import UIKit
import CoreData

class ColdCallsCell: UITableViewCell {
    @IBOutlet var cellLblBusiness: UILabel!
    @IBOutlet var cellLblAddress: UILabel!
    @IBOutlet var cellLblCount: UILabel!
    

    
    init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
}


class ColdCallsTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, RMDateSelectionViewControllerDelegate {
    
    var coldCalls:ColdCalls[] = []
    var selectedDay:NSDate = NSDate()
    @IBOutlet var dateButtonText: UIButton!
    
    @IBAction func previousDay() {
        selectedDay = selectedDay.addTimeInterval(-(60*60*24)) as NSDate
        coldCalls = loadColdCalls()
        //tableView.reloadData()
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Right)

    }
    
    @IBAction func nextDay() {
        selectedDay = selectedDay.addTimeInterval(60*60*24) as NSDate
        coldCalls = loadColdCalls()
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Left)
    }

    func dateSelectionViewController(vc: RMDateSelectionViewController!, didSelectDate aDate: NSDate!)  {
            selectedDay = aDate
            coldCalls = loadColdCalls()
            tableView.reloadData()
    }
    
    func dateSelectionViewControllerDidCancel(vc: RMDateSelectionViewController!) {
        
    }
    
    @IBAction func openDateSelectionController() {
        let dateSelectionVC = RMDateSelectionViewController()
        dateSelectionVC.delegate = self
        dateSelectionVC.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        coldCalls = loadColdCalls()
        println(coldCalls)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadColdCalls() -> ColdCalls[] {
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.cdh.managedObjectContext
        dateButtonText.setTitle(Date.toString(selectedDay), forState: UIControlState.Normal)
        return ColdCalls.allFromDate(appDel, context: context, date: selectedDay)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return coldCalls.count
    }

    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let cell : ColdCallsCell? = self.tableView.dequeueReusableCellWithIdentifier("coldCallCell", forIndexPath: indexPath) as? ColdCallsCell
        let coldCall:ColdCalls = self.coldCalls[indexPath!.row] as ColdCalls
        cell!.cellLblBusiness.text = coldCall.business_name
        cell!.cellLblAddress.text = coldCall.fullAddress()
        cell!.cellLblCount.text = "\(indexPath!.row + 1)"
        return cell as? ColdCallsCell
    }
    
    
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
    }
    
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            var context:NSManagedObjectContext = appDel.cdh.managedObjectContext
            context.deleteObject(coldCalls[indexPath.row])
            context.save(nil)
            self.coldCalls = self.loadColdCalls()
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView!, willDisplayHeaderView view: UIView!, forSection section: Int) {
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView?, moveRowAtIndexPath fromIndexPath: NSIndexPath?, toIndexPath: NSIndexPath?) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView?, canMoveRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var detailsViewController: ColdCallsDetailViewController = segue.destinationViewController as ColdCallsDetailViewController
        var coldCallIndex = tableView.indexPathForSelectedRow().row
        var selectedColdCall = self.coldCalls[coldCallIndex]
        detailsViewController.coldCall = selectedColdCall
    }

}

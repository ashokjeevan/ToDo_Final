//
//  ViewController.swift
//  CoreDataTestDecEnd
//
//  Created by Ashok Jeevan on 12/28/14.
//  Copyright (c) 2014 home. All rights reserved.
//

import UIKit
import CoreData
import EventKit


class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    //Insert below the tableView IBOutlet
    //var names = [String]()
    var people = [NSManagedObject]()
    var count = 0
    
    @IBAction func addName(sender: AnyObject) {
        
//        var alert = UIAlertController(title: "New name",
//            message: "Add a new name",
//            preferredStyle: .Alert)
//        
//        let saveAction = UIAlertAction(title: "Save",
//            style: .Default) { (action: UIAlertAction!) -> Void in
//                
//                let textField = alert.textFields![0] as UITextField
//                self.saveName(textField.text)
//                self.tableView.reloadData()
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel",
//            style: .Default) { (action: UIAlertAction!) -> Void in
//        }
//        
//        alert.addTextFieldWithConfigurationHandler {
//            (textField: UITextField!) -> Void in
//        }
//        
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        
//        presentViewController(alert,
//            animated: true,
//            completion: nil)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        title = "\"The List\""
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return people.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("cell")
                as customTableCell
            
            let person = people[indexPath.row]
            
            cell.nameLabel.text = person.valueForKey("name") as String?
            cell.numberLabel.text = person.valueForKey("number") as String?
            cell.countryLabel.text = person.valueForKey("country") as String?
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let selectedItem = people[indexPath.row]
    }
    
    func saveName(name: String) {

        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let entity =  NSEntityDescription.entityForName("Person",
            inManagedObjectContext:
            managedContext)
        
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        person.setValue(name, forKey: "name")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }  

        people.append(person)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: Selector("reload"), userInfo: nil, repeats: false)
        timer.fire()
        }

    func reloadDataForTableView() {
        getDataFromDatabase()
        
        self.tableView.reloadData()
        var frameSize = self.tableView.frame
        frameSize.size.height = self.view.frame.height
        self.tableView.frame = frameSize
    
    }
    
    //get the values from the database
    func getDataFromDatabase()
    {
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"Person")
        
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            println("read success")
            println("Count  \(results.count)")
            people = results
            
            if(results.count != 0) {
                for index in 0...(results.count)-1 {
                    var tempName = people[index].valueForKey("name") as String!
                    var tempNumber = people[index].valueForKey("number") as String!
                    var tempCountry = people[index].valueForKey("country") as String!
                    var tempID = people[index].valueForKey("reminderText") as String!

                    println(tempName + " " + tempNumber + " " + tempCountry)
                    println(tempID)
                }
            }
            
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        if(editingStyle == .Delete ) {
            // Find the LogItem object the user is trying to delete
            let logItemToDelete = people[indexPath.row]
            
            var tempName = people[indexPath.row].valueForKey("name") as String!
            var tempID = people[indexPath.row].valueForKey("reminderText") as String!

            
            println(" name \(tempName)")
            println(" tempCountry \(tempID))")
            var eventStore : EKEventStore = EKEventStore()
            
            var eventToRemove: EKEvent
        
            var reminderIdentifier = logItemToDelete.valueForKey("reminderText") as String!

            eventToRemove =  eventStore.eventWithIdentifier(reminderIdentifier)
            
            eventStore.removeEvent(eventToRemove, span: EKSpanThisEvent , commit:true, error: nil)
            // Delete it from the managedObjectContext
            managedContext.deleteObject(logItemToDelete)
            
            reloadDataForTableView()
            
            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
            
            // Tell the table view to animate out that row
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
 
 

    func reload()
    {
        println("reload")
        reloadDataForTableView()
        
        }
}


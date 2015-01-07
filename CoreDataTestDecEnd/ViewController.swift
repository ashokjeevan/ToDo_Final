//
//  ViewController.swift
//  CoreDataTestDecEnd
//
//  Created by Ashok Jeevan on 12/28/14.
//  Copyright (c) 2014 home. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    //Insert below the tableView IBOutlet
    //var names = [String]()
    var people = [NSManagedObject]()
    
    
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
//            cell.textLabel.text = person.valueForKey("name") as String?
            
            cell.nameLabel.text = person.valueForKey("name") as String?
            cell.numberLabel.text = person.valueForKey("number") as String?
            cell.countryLabel.text = person.valueForKey("country") as String?
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func saveName(name: String) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("Person",
            inManagedObjectContext:
            managedContext)
        
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        //3
        person.setValue(name, forKey: "name")
        
        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }  
        //5
        people.append(person)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self .getDataFromDatabase()
        
        getDataFromDatabase()
        self.tableView.reloadData()
        var frameSize = self.tableView.frame
        frameSize.size.height = self.view.frame.height
        self.tableView.frame = frameSize
    }
    
    func getDataFromDatabase()
    {
        //start copy - from ViewController
        
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Person")
        
        //3
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
                
                    println(tempName + " " + tempNumber + " " + tempCountry)
                }
            }
            //let iiiii = peopl
            
            //let person = people[indexPath.row]
            //cell.textLabel.text = person.valueForKey("name") as String?
            
            
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        //stop
        
        
        

    }
}


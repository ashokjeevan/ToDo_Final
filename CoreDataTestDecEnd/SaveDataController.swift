//
//  SaveDataController.swift
//  CoreDataTestDecEnd
//
//  Created by Ashok Jeevan on 12/28/14.
//  Copyright (c) 2014 home. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import EventKit



class SaveDataController: UIViewController {
    
    var people = [NSManagedObject]()
    
    var selectedDate = NSDate()
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtNumber: UITextField!
    @IBOutlet var txtCountry: UITextField!
    
    @IBOutlet var datePicker: UIDatePicker!
   
    @IBAction func datePickerValueChange(sender: UIDatePicker) {
        selectedDate = datePicker.date
    }
    
    
    @IBAction func printData(sender: UIButton) {
        
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
            
            for index in 0...(results.count)-1 {
                var tempName = people[index].valueForKey("name") as String!
                var tempNumber = people[index].valueForKey("number") as String!
                var tempCountry = people[index].valueForKey("country") as String!
                
                println(tempName + " " + tempNumber + " " + tempCountry)
            }

            //let iiiii = peopl
            
            //let person = people[indexPath.row]
            //cell.textLabel.text = person.valueForKey("name") as String?
            
            
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        //stop
        
        
        
        
        
    }
    @IBAction func saveData(sender: UIButton) {
        
        
        //println("clicked")
        var nameValue = txtName.text
        var numberValue = txtNumber.text
        var countryValue = txtCountry.text
        
        println(nameValue + " " + numberValue + " " + countryValue)
        
        //start copy - from ViewController
        
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
        person.setValue(nameValue, forKey: "name")
        person.setValue(numberValue, forKey: "number")
        person.setValue(countryValue, forKey: "country")
        
        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }

        
        //calendar start
        
        var eventStore : EKEventStore = EKEventStore()
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        eventStore.requestAccessToEntityType(EKEntityTypeReminder, completion: {
            granted, error in
            if (granted) && (error == nil) {
                println("granted \(granted)")
                println("error  \(error)")
                
                
                
                var alarmEvent:EKAlarm = EKAlarm(absoluteDate: self.selectedDate)
                
                var alarmArray = NSMutableArray()
                alarmArray.addObject(alarmEvent)
                
                var event:EKEvent = EKEvent(eventStore: eventStore)
//                event.title = "Test Title"
////                event.startDate = NSDate()
////                event.endDate = NSDate()
//                event.notes = "This is a note"
//                event.calendar = eventStore.defaultCalendarForNewEvents
//                event.alarms = alarmArray
//                eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
//                println("Saved Event")
                
                //reminder
                let dateForReminder = self.datePicker.date
                let alarmForReminder = EKAlarm(absoluteDate: dateForReminder)
                
                var reminder: EKReminder = EKReminder(eventStore: eventStore)
                reminder.title = nameValue
                reminder.notes = numberValue
                reminder.calendar = eventStore.defaultCalendarForNewReminders()
                reminder.addAlarm(alarmForReminder)
                var error: NSError?
                eventStore.saveReminder(reminder, commit: true, error: &error)
                println("reminder saved")
                if error != nil {
                    println("Reminder failed with error \(error?.localizedDescription)")
                }
                
                
            }
        })
        
        
        //calendar stop
        
        self.navigationController?.popViewControllerAnimated(true)
        //stop copy
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        datePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
       
        
    }
    
    
    func datePickerChanged(datePicker:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strDate = dateFormatter.stringFromDate(datePicker.date)

        println(strDate)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        txtCountry.endEditing(true)
    }
    
    
}
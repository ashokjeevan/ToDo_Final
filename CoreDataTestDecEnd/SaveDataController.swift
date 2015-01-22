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
    
    var eventID : NSString!
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtNumber: UITextField!
    @IBOutlet var txtCountry: UITextField!
    
    @IBOutlet var datePicker: UIDatePicker!
   
    @IBAction func datePickerValueChange(sender: UIDatePicker) {
        selectedDate = datePicker.date
    }
    
    
    @IBAction func printData(sender: UIButton) {
        
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
                var reminderTime = people[index].valueForKey("reminderTime") as String!
                var reminderIdentifier = people[index].valueForKey("reminderText") as String!
                
                println(tempName + " " + tempNumber + " " + tempCountry)
                println(reminderTime + " " + reminderIdentifier)
            }
            
            
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        //stop
        
    }
    @IBAction func saveData(sender: UIButton) {
        
        //converting from date picker data to string
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var dateToString = dateFormatter.stringFromDate(datePicker.date)
        
        var nameValue = txtName.text
        var numberValue = txtNumber.text
        var countryValue = txtCountry.text

        //creating the reminder
        
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
                //reminder
                let dateForReminder = self.selectedDate
                let alarmForReminder = EKAlarm(absoluteDate: dateForReminder)
                
                event.title = nameValue
                event.notes = numberValue
                event.calendar = eventStore.defaultCalendarForNewEvents
                event.addAlarm(alarmForReminder)
                event.startDate = self.selectedDate
                event.endDate = self.selectedDate
                var error: NSError?
                eventStore.saveEvent(event, span:EKSpanThisEvent, commit:true, error:&error)
                println("reminder saved")
                if error != nil {
                    println("Reminder failed with error \(error?.localizedDescription)")
                }
                println("identifier \(event.eventIdentifier)")
                self.eventID = event.eventIdentifier
                println("after assigning \(self.eventID)")
            }
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
            
            println("before saving \(self.eventID)")
            
            //3
            person.setValue(nameValue, forKey: "name")
            person.setValue(numberValue, forKey: "number")
            person.setValue(countryValue, forKey: "country")
            person.setValue(dateToString, forKey: "reminderTime")
            person.setValue(self.eventID,forKey: "reminderText")
            
            //4
            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
            println(nameValue + " " + numberValue + " " + countryValue)
            
            
            })
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: Selector("popView"), userInfo: nil, repeats: false)
        timer.fire()
        
        
        //calendar stop

        //stop copy
        
        
    }
    
    func popView()
    {
        println("pop")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        txtCountry.endEditing(true)
    }
    
}
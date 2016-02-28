//
//  ViewController.swift
//  week4echt
//
//  Created by bob on 24/02/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputTodo.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view, typically from a nib.
        /*if let directory: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            
            let path: String = directory + "test.txt"
            

            
            // Reading.
            do {
                let loadedArray = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            } catch {
                // Error handling here.
            }
        } else {
            // Error handling here.
        } */
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        /* Writing.
        do {
            try todoArray.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
        }
        catch {
            // Error handling here.
        } */
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var inputTodo: UITextField!
    
    var todoArray = ["test", "test2", "test3"]
    @IBAction func enterTodo(sender: AnyObject) {
        if (inputTodo.text == "") {
            // Create the alert controller.
            var alert = UIAlertController(title: "You didn't enter anything!", message: "Insert your todo here or press OK to insert an empty row", preferredStyle: .Alert)
            
            // Add the text field. You can configure it however you need.
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.text = ""
            })

            // Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                let textField = alert.textFields![0] as UITextField
                print("Text field: \(textField.text)")
                self.todoArray.append(textField.text!)
                self.tableView.reloadData()
            }))
            var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
                self.inputTodo.resignFirstResponder()
            }            // Present the alert.
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
        else {
            // alert: you have entered an empty todo. do you want to insert a white line?
            // if yes --> continue, if no --> abort
            todoArray.append(inputTodo.text!)
            print(todoArray)
            inputTodo.text = ""
            tableView.reloadData()
        }
    }
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TodoCell
        cell.todoTextfield.text = todoArray[indexPath.row]
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }

    func textFieldShouldReturn(inputTodo: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            todoArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
}


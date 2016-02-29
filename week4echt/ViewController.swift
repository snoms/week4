//
//  ViewController.swift
//  week4echt
//
//  Created by bob on 24/02/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var todoArray = [String]()
    
    func writeData() {
        if let directory: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            
            let path: String = directory + "/todoliststorage.txt"
            let text = todoArray.joinWithSeparator("^")
            do {
                try text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch {
                // Error handling here.
                print("error while writing list to storage")
                print(path)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.inputTodo.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view, typically from a nib.
        if let directory: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            
            let path: String = directory + "/todoliststorage.txt"
            print(path)

            // Reading todo list from test.txt
            do {
                let loadedFile = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                todoArray = loadedFile.characters.split{$0 == "^" || $0 == "\r\n"}.map(String.init)

            } catch {
                // Error handling here.
                print("error while reading stored list")
            }
        } else {
            // Error handling here.
            print("error while reading stored list")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var inputTodo: UITextField!
    
    @IBAction func enterTodo(sender: AnyObject) {
        if (inputTodo.text == "") {
            // Create the alert controller.
            let alert = UIAlertController(title: "You didn't enter anything!", message: "Insert your todo here or press OK to insert an empty row", preferredStyle: .Alert)
            
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
                self.writeData()
            }))
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
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
            self.inputTodo.resignFirstResponder()

        }
        writeData()
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
            writeData()
        }
    }

}


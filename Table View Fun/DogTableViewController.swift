//
//  ViewController.swift
//  Table View Fun
//
//  Created by Gina Sprint on 10/16/18.
//  Copyright © 2018 Gina Sprint. All rights reserved.
//

import UIKit

class DogTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    var dogs = [Dog]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initializeDogs()
    }

    func initializeDogs() {
        dogs.append(Dog(name: "Lassie", breed: "Collie"))
        dogs.append(Dog(name: "AirBud", breed: "Retriever"))
        dogs.append(Dog(name: "Clifford", breed: "BigRedDog"))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dogs.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // table view is asking its data source
        // "what cell goes in this row??"
        
        // get a reusable cell
        // its more efficient to resuse cells so there is a cell for each row on screen
        // than have a cell for each item in the data source
        // if the array has 10000 dogs, we don't need 10000 cells because the there won't be 10000 rows displayed at one time in our table view
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogCell", for: indexPath) as! DogTableViewCell
        // dequeReusableCell() returns a generic UITableViewCell
        // we want to downcast it to our UITableViewCell subclass so we can get that specific behavior we wrote in DogTableViewCell

        

        // update the cell's views to show information for the dog at indexPath.row in dogs array
        // IndexPath has two properites section and row
        // since we only have one section, we only need to use its row
        let dog = dogs[indexPath.row]
        cell.update(with: dog)
        // MARK: LAB #19
        // note: this isn't actually required if you provide an implementation for tableView(_:moveRowAt:to:)
        cell.showsReorderControl = true
        
        // return the cell
        return cell
    }
    
    // MARK: LAB #19.a.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let dog = dogs.remove(at: sourceIndexPath.row)
        dogs.insert(dog, at: destinationIndexPath.row)
        // MARK: LAB #19.b.
        tableView.reloadData()
    }
    
    // MARK: LAB #20
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dogs.remove(at: indexPath.row)
            // MARK: LAB #20.a.
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "DetailSegue" {
                // need a reference to the DogDetailViewController that is about to be shown
                if let dogDetailVC = segue.destination as? DogDetailViewController {
                    
                    // get the dog that was selected
                    if let indexPath = tableView.indexPathForSelectedRow {
                        let dog = dogs[indexPath.row]
                        dogDetailVC.dog = dog
                    }
                }
            }
            else if identifier == "AddSegue" {
                print("Adding a new dog")
            }
        }
    }
    
    // an unwind method
    @IBAction func unwindToDogTableVC(segue: UIStoryboardSegue) {
        print("unwinding")
        // get the dog if there is one from dogDetailViewController
        if let identifier = segue.identifier {
            if identifier == "SaveUnwindSegue" {
                if let dogDetailVC = segue.source as? DogDetailViewController {
                    if let dog = dogDetailVC.dog {
                        // is this a dog we were editing or a new dog??
                        if let indexPath = tableView.indexPathForSelectedRow {
                            let origDog = dogs[indexPath.row]
                            origDog.name = dog.name
                            origDog.breed = dog.breed
                            tableView.reloadData()
                        }
                        else {
                            // unwinding from an AddSegue because there is not a selected row
                            // get the dog, add it to the array
                            // update the table view
                            dogs.append(dog)
                            tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        let newEditing = !tableView.isEditing
        tableView.setEditing(newEditing, animated: true)
        
    }
    
}


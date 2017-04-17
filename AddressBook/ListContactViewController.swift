//
//  ListContactViewController.swift
//  AddressBook
//
//  Created by Selase Kwawu on 16/04/2017.
//  Copyright © 2017 Selase Kwawu. All rights reserved.
//

import UIKit

class ListContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    var person : [Contacts] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    func getData() {
        let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            person = try context.fetch(Contacts.fetchRequest())
            print(person)
        }
        catch {
            print("Failed to fetch")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            let personData = person[indexPath.row]
            context.delete(personData)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                person = try context.fetch(Contacts.fetchRequest())
            }
            catch {
                print("Failed to fetch")
            }
            
        }
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return person.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let personData = person[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name:"HelveticaNeue-Thin", size:17)
       
        cell.textLabel?.text = personData.firstName! + " " + personData.lastName! + "\n\(personData.phone ?? "#")"
        
        
        cell.imageView?.image = UIImage(data: personData.photo! as Data)
        
//        let cellIdentifier = "cell"
//        
//        cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
//        let photoData = person[indexPath.row].photo
//        let image : UIImage = UIImage(named: photoData)
//        cell.imageView?.image = image
        
        
        
        return cell
    }

   
}

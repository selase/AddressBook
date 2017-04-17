//
//  ListContactViewController.swift
//  AddressBook
//
//  Created by Selase Kwawu on 16/04/2017.
//  Copyright © 2017 Selase Kwawu. All rights reserved.
//

import UIKit

class ListContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var person : [Contacts] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.layer.cornerRadius = 10
        searchTextField.layer.cornerRadius = 15.0
        searchTextField.layer.borderWidth = 0.3
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
        
        
        
        super.viewWillAppear(animated)
        // Hide the navigation bar on this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func getData() {
        let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            person = try context.fetch(Contacts.fetchRequest())
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
        cell.textLabel?.font = UIFont(name:"HelveticaNeue-Thin", size:14)
       
        cell.textLabel?.text = personData.firstName! + " " + personData.lastName! + "\n\(personData.phone ?? "#")"
        
        
        //cell.imageView?.image = UIImage(data: personData.photo! as Data)
        cell.imageView?.image = imageWithImage(image: UIImage(data: personData.photo! as Data)!, scaledToSize: CGSize(width: 30, height: 30))
        
        let cellImage = cell.imageView
        cellImage?.layer.layoutIfNeeded()
        cellImage?.layer.cornerRadius = (cellImage?.frame.height)! / 2.0
        cellImage?.layer.masksToBounds = true
 
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let personData = person[indexPath.row]
        performSegue(withIdentifier: "contactSegue", sender: personData)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! AddContactViewController
        nextVC.personData = sender as? Contacts
        
        
    }
    // Returns a resized image to the dimensions of choice
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysOriginal)
    }

    

   
}

//
//  AddContactViewController.swift
//  AddressBook
//
//  Created by Selase Kwawu on 16/04/2017.
//  Copyright © 2017 Selase Kwawu. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var isEmergency: UISwitch!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var photo: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }


    @IBAction func photosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func saveContact(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let person = Contacts(context: context)
        person.firstName = firstName.text
        person.lastName = lastName.text
        person.email = email.text
        person.phone = phone.text
        person.isEmergencyContact = isEmergency.isOn
        person.notes = notes.text
        
        if let image = photo.image {
            if let data = UIImagePNGRepresentation(image) as NSData? {
                person.photo = data
            }
        }
        
        //Save Data to Coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photo.image = image
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    
}

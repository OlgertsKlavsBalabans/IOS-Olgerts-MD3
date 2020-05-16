//
//  AddPinViewController.swift
//  map-start
//
//  Created by students on 15/05/2020.
//  Copyright © 2020 berzinsk. All rights reserved.
//

import UIKit
import Firebase

class AddPinViewController: UIViewController {
    
var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var TextLattitude: UITextField!
    
    @IBOutlet weak var TextLongitude: UITextField!
    
    @IBAction func SaveButton(_ sender: UIButton) {
        var id = 0
        ref.child("Annotations").observeSingleEvent(of: .value){
            snapshot in let myDataDict = snapshot.value as? [String: AnyObject] ?? [:]
            id = myDataDict.count
            //print(myDataDict.count)
            if let latitude = Double(self.TextLattitude.text!), let longitude = Double(self.TextLongitude.text!) {
                self.ref.child("Annotations").child("\(id)").setValue(["Latitude": latitude ,"Longitude": longitude])
            }
            
        }
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

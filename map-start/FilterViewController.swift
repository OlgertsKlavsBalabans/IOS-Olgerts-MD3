//
//  FilterViewController.swift
//  map-start
//
//  Created by students on 27/04/2020.
//  Copyright © 2020 berzinsk. All rights reserved.
//

import UIKit

protocol filterDelegate {
    func update10kmFromLoc(disable10kmFromLoc: Bool)
    func updateDesc(disableNoDescription: Bool)
}

class FilterViewController: UIViewController {
    var delegate: filterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var tittle: UILabel!
    @IBOutlet weak var noDescriptionLabel: UILabel!
    @IBOutlet weak var tenKmFromLocLabel: UILabel!
    var switch1:Bool = false
    var switch2:Bool = false
    @IBAction func switch10KmFromLoc(_ sender: UIButton) {
        switch2 = !switch2
        if (switch2) {
            delegate?.update10kmFromLoc(disable10kmFromLoc: switch2)
            tenKmFromLocLabel.text = "Option enabled!"
        }
        else {
            delegate?.update10kmFromLoc(disable10kmFromLoc: switch2)
                tenKmFromLocLabel.text = "Option disabled!"
            
        }
        
        
    }
    
    
    
    @IBAction func switchNoDescription(_ sender: UIButton) {
        switch1 = !switch1
        if (switch1) {
            delegate?.updateDesc(disableNoDescription: switch1)
            noDescriptionLabel.text = "Option enabled!"
        }
        else {
            delegate?.updateDesc(disableNoDescription: switch1)
                noDescriptionLabel.text = "Option disabled!"
            
        }
        
    }
    
    @IBAction func disableNoDescription(_ sender: UISwitch) {
        delegate?.updateDesc(disableNoDescription: sender.isOn)
        
//        print(sender.isOn)
    }
    
    
    @IBAction func disable10kmFromLoc(_ sender: UISwitch) {
        delegate?.update10kmFromLoc(disable10kmFromLoc: sender.isOn)
        
//        print(sender.isOn)
        
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

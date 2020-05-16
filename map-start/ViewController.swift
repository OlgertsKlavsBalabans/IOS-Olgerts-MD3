//
//  ViewController.swift
//  map-start
//
//  Created by karlis.berzins on 25/03/2020.
//  Copyright © 2020 berzinsk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SecondViewControllerDelegate {

  @IBOutlet var myLabel: UILabel!


  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  func updated(text: String) {
    print(text)
    myLabel.text = text
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? SecondViewController {
      vc.delegate = self
    }
  }
}


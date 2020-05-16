//
//  SecondViewController.swift
//  map-start
//
//  Created by karlis.berzins on 25/03/2020.
//  Copyright © 2020 berzinsk. All rights reserved.
//

import UIKit

protocol SecondViewControllerDelegate {
  func updated(text: String)
}

class SecondViewController: UIViewController {

  @IBOutlet var textField: UITextField!

  var delegate: SecondViewControllerDelegate?

  override func viewDidLoad() {
        super.viewDidLoad()


    }

  @IBAction func buttonAction(_ sender: UIButton) {
    if let text = textField.text {
      delegate?.updated(text: text)
    }
  }

}

//
//  ViewController.swift
//  P4-Instagrid
//
//  Created by Adrien PEREA on 15/04/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var myButton: [UIButton]!
    @IBOutlet weak var upLeft: UIButton!
    @IBOutlet weak var upRight: UIButton!
    @IBOutlet weak var downLeft: UIButton!
    @IBOutlet weak var downRight: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonPressed(myButton[1])
    }

    func setupButton(sender: UIButton) {
        removeImage()
        sender.setImage(#imageLiteral(resourceName: "Select"), for: .normal)
        sender.contentVerticalAlignment = .fill
        sender.contentHorizontalAlignment = .fill
    }

    func removeImage() {
        for button in myButton {
            button.setImage(nil, for: .normal)
        }
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            setupButton(sender: sender)
            upLeft.isHidden = true
            upRight.isHidden = false
            downLeft.isHidden = false
            downRight.isHidden = false
        case 2:
            setupButton(sender: sender)
            upLeft.isHidden = false
            upRight.isHidden = false
            downLeft.isHidden = true
            downRight.isHidden = false
        case 3:
            setupButton(sender: sender)
            upLeft.isHidden = false
            upRight.isHidden = false
            downLeft.isHidden = false
            downRight.isHidden = false
        default:
            return
        }
    }
}

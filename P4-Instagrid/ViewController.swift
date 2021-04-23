//
//  ViewController.swift
//  P4-Instagrid
//
//  Created by Adrien PEREA on 15/04/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var myButton: [UIButton]!
    @IBOutlet weak var upLeft: UIButton!
    @IBOutlet weak var upRight: UIButton!
    @IBOutlet weak var downLeft: UIButton!
    @IBOutlet weak var downRight: UIButton!
    @IBOutlet weak var gridView: UIView!
    var picker: UIImagePickerController = UIImagePickerController()
    var selectedImageButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        buttonPressed(myButton[1])
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeByUser(_:)))
        leftSwipeGesture.direction = .left
        let upSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(upSwipeByUser(_:)))
        upSwipeGesture.direction = .up
        self.view.addGestureRecognizer(leftSwipeGesture)
        self.view.addGestureRecognizer(upSwipeGesture)
        print(UIDevice.current.orientation.rawValue)
    }

    override func viewDidAppear(_ animated: Bool) {
        print(UIDevice.current.orientation.rawValue)
    }

    func sharePicture(view: UIView) -> UIImage {
        let picture = UIGraphicsImageRenderer(bounds: view.bounds)
        return picture.image { UIGraphicsImageRendererContext in
            view.layer.render(in: UIGraphicsImageRendererContext.cgContext)
        }
    }

    @objc func leftSwipeByUser(_ sender: UISwipeGestureRecognizer) {
        if UIDevice.current.orientation.isLandscape {
            UIView.animate(withDuration: 0.3) {
                self.gridView.transform = CGAffineTransform(translationX: -self.view.frame.width * 2, y: 0)
            }
            let image = sharePicture(view: gridView)
            let items = [image]
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(activityVC, animated: true)
            activityVC.completionWithItemsHandler = { (_, _, _, _) in
                UIView.animate(withDuration: 0.3) {
                    self.gridView.transform = .identity
                }
            }
        }
    }

    @objc func upSwipeByUser(_ sender: UISwipeGestureRecognizer) {
        if UIDevice.current.orientation.isPortrait || UIDevice.current.orientation == .unknown {
            UIView.animate(withDuration: 0.3) {
                self.gridView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height * 2)
            }
            let image = sharePicture(view: gridView)
            let items = [image]
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(activityVC, animated: true)
            activityVC.completionWithItemsHandler = { (_, _, _, _) in
                UIView.animate(withDuration: 0.3) {
                    self.gridView.transform = .identity
                }
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
// swiftlint:disable:next line_length
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let photo = info[.editedImage] as? UIImage {
            selectedImageButton?.setImage(photo, for: .normal)
            selectedImageButton?.imageView?.contentMode = .scaleAspectFill
        }
        picker.dismiss(animated: true, completion: nil)
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

    @IBAction func selectImage(_ sender: UIButton) {
            selectedImageButton = sender
            present(picker, animated: true, completion: nil)
    }

}

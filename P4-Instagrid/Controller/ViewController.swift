//
//  ViewController.swift
//  P4-Instagrid
//
//  Created by Adrien PEREA on 15/04/2021.
// swiftlint:disable line_length

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var myButton: [UIButton]!
    @IBOutlet var myGridButton: [UIButton]!
    @IBOutlet weak var gridView: UIView!
    var picker: UIImagePickerController = UIImagePickerController()
    var selectedImageButton: UIButton?
    private let duration: Double = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        initPicker()
        initGesture()
        buttonPressed(myButton[1])
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        setupPressed(sender: sender)
        switch sender.tag {
        case 1: myGridButton[0].isHidden = true
        case 2: myGridButton[2].isHidden = true
        default:
            return
        }
    }

    @IBAction func selectImage(_ sender: UIButton) {
            selectedImageButton = sender
            present(picker, animated: true, completion: nil)
    }

    @objc private func swipeByUser(_ sender: UISwipeGestureRecognizer) {
        if UIDevice.current.orientation.isLandscape && sender.direction == .left {
            UIView.animate(withDuration: duration) {
                self.gridView.transform = CGAffineTransform(translationX: -self.view.frame.width * 2, y: 0)
            }
            shareImage()
        } else if (UIDevice.current.orientation.isPortrait || UIDevice.current.orientation == .unknown) && sender.direction == .up {
            UIView.animate(withDuration: duration) {
                self.gridView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height * 2)
            }
            shareImage()
        }
    }

    private func initPicker() {
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
    }

    private func initGesture() {
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeByUser(_:)))
        leftSwipeGesture.direction = .left
        let upSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeByUser(_:)))
        upSwipeGesture.direction = .up
        self.view.addGestureRecognizer(leftSwipeGesture)
        self.view.addGestureRecognizer(upSwipeGesture)
    }

    private func shareImage() {
        let image = convertPicture(view: gridView)
        let items = [image]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityVC, animated: true)
        activityVC.completionWithItemsHandler = { (_, _, _, _) in
            UIView.animate(withDuration: self.duration) {
                self.gridView.transform = .identity
            }
        }
    }

    private func setupButton(sender: UIButton) {
        deselectButton()
        selectedButton(button: sender)
    }

    private func selectedButton(button: UIButton) {
        button.isSelected = true
        button.setImage(#imageLiteral(resourceName: "Selected"), for: .selected)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
    }

    private func deselectButton() {
        for button in myButton {
            button.isSelected = false
        }
    }

    private func showAllGrid() {
        for buttons in myGridButton {
            buttons.isHidden = false
        }
    }

    private func setupPressed(sender: UIButton) {
        setupButton(sender: sender)
        showAllGrid()
    }

    private func convertPicture(view: UIView) -> UIImage {
        let picture = UIGraphicsImageRenderer(bounds: view.bounds)
        return picture.image { UIGraphicsImageRendererContext in
            view.layer.render(in: UIGraphicsImageRendererContext.cgContext)
        }
    }

    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let photo = info[.editedImage] as? UIImage {
            selectedImageButton?.setImage(photo, for: .normal)
            selectedImageButton?.imageView?.contentMode = .scaleAspectFill
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

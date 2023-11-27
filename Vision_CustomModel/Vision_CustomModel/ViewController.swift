//
//  ViewController.swift
//  Vision_CustomModel
//
//  Created by Manish on 22/11/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultText: UITextView!
    @IBOutlet weak var inputImage: UIImageView!
    
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onSelectImageTap(_ sender: Any) {
        self.imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
}

// MARK: - Image Picker
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
            let pickedImage = info[.originalImage] as? UIImage
            inputImage.image = pickedImage
            
            MyAnimalRecognizer().recognizeAnimal(in: pickedImage!) { res in
                DispatchQueue.main.async {
                    self.resultText.text = res
                }
            }
            
            picker.dismiss(animated: true)
    }
    
}

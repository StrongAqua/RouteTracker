//
//  MainViewController.swift
//  RouteTracker
//
//  Created by aprirez on 6/2/21.
//

import UIKit

final class MainViewController: UIViewController {
    
    var onTakePicture: ((UIImage) -> Void)?
    
    @IBOutlet weak var router: MainRouter!
    @IBOutlet weak var takePicture: UIButton!
    
    @IBAction func showMap(_ sender: Any) {
        router.toMap(useless: "пример")
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        router.toLaunch()
    }
    @IBAction func takePicture(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }    
}

extension MainViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        debugPrint("HI!")
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else {return}
            guard let image = info[.editedImage] as? UIImage else {
                return
            }
            if let data = image.pngData() {
                let filename = self.getDocumentsDirectory().appendingPathComponent("marker.png")
                try? data.write(to: filename)
            }
        }
    }
    
}

final class MainRouter: BaseRouter {
    func toMap(useless: String) {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(MapViewController.self)
        
        controller.uselessExampleVariable = useless
        
        show(controller)
    }
    
    func toLaunch() {
        let controller = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(LoginViewController.self)
        
        setAsRoot(UINavigationController(rootViewController: controller))
    }
}

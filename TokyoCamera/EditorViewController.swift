//
//  EditorViewController.swift
//  TokyoCamera
//
//  Created by 藤井陽介 on 2017/06/03.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView! {
        
        didSet {
            
            // TODO: デフォルトの画像を設定する
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeText)))
        }
    }
    @IBOutlet weak var fontCollectionView: UICollectionView! {
        
        didSet {
            
            fontCollectionView.delegate = self
            fontCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var textLabel: UILabel! {
        
        didSet {
            
            textLabel.text = "TOKYO"
            textLabel.isUserInteractionEnabled = true
            textLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeText)))
        }
    }
    
    var currentText: String = "TOKYO" {
        
        didSet {
            
            textLabel.text = currentText
        }
    }
    var fontNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIFont.familyNames.forEach { familyName in
            
            guard let fontName = UIFont.fontNames(forFamilyName: familyName).first else {
                
                return
            }
            
            fontNames.append(fontName)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        switch (segue.destination, segue.identifier) {
        default:
            break
        }
    }
    
    // MARK: - TapGesture
    
    func changeText() {
        
        let alert = UIAlertController(title: "input text", message: nil, preferredStyle: .alert)
        alert.addTextField { [unowned self] textField in
            
            textField.text = self.currentText
            textField.placeholder = "TOKYO"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            
            alert.textFields?.forEach { [unowned self] textField in
                
                self.currentText = textField.text ?? "TOKYO"
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Action
    
    @IBAction func cameraButton() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func photoLibraryButton() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareButton() {
        
        // MARK: ScreenShot
        let rect = imageView.frame
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let capture = UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext()!)
        let image = UIImage(data: capture!)
        UIGraphicsEndImageContext()
        
        let activityItems: [Any] = [image, "#TokyoCamera"]
        let appActivity = [ShareInAppActivity()]
        let activitySheet = UIActivityViewController(activityItems: activityItems, applicationActivities: appActivity)
        let excludeActivity: [UIActivityType] = [
            UIActivityType.print,
            UIActivityType.addToReadingList,
            UIActivityType.postToWeibo,
            UIActivityType.postToTencentWeibo
        ]
        activitySheet.excludedActivityTypes = excludeActivity
        present(activitySheet, animated: true, completion: nil)
    }
}

// MARK: - CollectionViewDataSource

extension EditorViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return fontNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FontCollectionViewCell
        
        let fontName = fontNames[indexPath.row]
        cell.previewTextLabel.text = textLabel.text
        cell.previewTextLabel.font = UIFont(name: fontName, size: cell.previewTextLabel.font.pointSize)
        cell.fontNameTextLabel.text = fontName
        cell.fontNameTextLabel.font = UIFont(name: fontName, size: cell.fontNameTextLabel.font.pointSize)
        
        return cell
    }
}

// MARK: - CollectionViewDelegate

extension EditorViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        textLabel.font = UIFont(name: fontNames[indexPath.row], size: textLabel.font.pointSize)
    }
}

// MARK: - ImagePickerControllerDelegate

extension EditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
}

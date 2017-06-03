//
//  EditorViewController.swift
//  TokyoCamera
//
//  Created by 藤井陽介 on 2017/06/03.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fontCollectionView: UICollectionView! {
        
        didSet {
            
            fontCollectionView.delegate = self
            fontCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var textLabel: UILabel! {
        
        didSet {
            
            textLabel.text = "TOKYO"
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

}

// MARK: - DataSource

extension EditorViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return fontNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath.row) as! FontCollectionViewCell
        
        let fontName = fontNames[indexPath.row]
        cell.previewTextLabel.text = textLabel.text
        cell.previewTextLabel.font = UIFont(name: fontName, size: cell.previewTextLabel.font.pointSize)
        cell.fontNameTextLabel.text = fontName
        cell.fontNameTextLabel.font = UIFont(name: fontName, size: cell.fontNameTextLabel.font.pointSize)
        
        return cell
    }
}

// MARK: - Delegate

extension EditorViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        textLabel.font = UIFont(name: fontName[indexPath.row], size: textLabel.font.pointSize)
    }
}

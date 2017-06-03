//
//  TimelineViewController.swift
//  TokyoCamera
//
//  Created by 藤井陽介 on 2017/06/03.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit
import FirebaseStorage

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.dataSource = self
        }
    }

    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func reloadData() {
        
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        let ref = Storage.storage().reference(forURL: "gs://tokyocamera-d1e6f.appspot.com")
        let saveData = UserDefaults.standard
        let count = saveData.object(forKey: "count") as? Int ?? 0
        
        if count != 0 {
            for i in 0 ..< count {
                ref.child("image/\(deviceId)/\(i).png").getData(maxSize: 1 * 1024 * 1024) { [unowned self] (data, error) in
                    guard let imageData = data,
                        let image = UIImage(data: imageData) else {
                            return
                    }
                    
                    self.images.append(image)
                }
            }
        }
    }
}

// MARK: - CollectionViewDataSource

extension TimelineViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TimelineCollectionViewCell
        
        cell.imageView.image = images[indexPath.row]
        
        return cell
    }
}

// MARK: - CollectionViewDelegateFlowLayout

extension TimelineViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width / 3
        let height = width
        return CGSize(width: width, height: height)
    }
}

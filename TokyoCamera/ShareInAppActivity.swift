//
//  ShareInAppActivity.swift
//  TokyoCamera
//
//  Created by 藤井陽介 on 2017/06/03.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit
import FirebaseStorage

class ShareInAppActivity: UIActivity {
    
    weak var viewContorller: EditorViewController!

    override var activityTitle: String? {
        return "TokyoCamera"
    }
    
    override var activityImage: UIImage? {
        return #imageLiteral(resourceName: "making")
    }
    
    override var activityType: UIActivityType? {
        guard let bundleId = Bundle.main.bundleIdentifier else {return nil}
        return UIActivityType(rawValue: bundleId + "\(self.classForCoder)")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    override func prepare(withActivityItems activityItems: [Any]) {
        
        // TODO: アプリで共有にする
        guard let image = activityItems[0] as? UIImage else {
            
            return
        }
        
        let saveData = UserDefaults.standard
        let count = saveData.object(forKey: "count") as? Int ?? 0
        saveData.set(count + 1, forKey: "count")
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        let ref = Storage.storage().reference(forURL: "gs://tokyocamera-d1e6f.appspot.com")
        if let data = UIImagePNGRepresentation(image) {
            ref.child("image/\(deviceId)/\(count).png").putData(data, metadata: nil, completion: { (metadata, error) in
                let alert = UIAlertController(title: "アップロード完了しました。", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.viewContorller.present(alert, animated: true, completion: nil)
            })
        }
    }
}

//
//  ShareInAppActivity.swift
//  TokyoCamera
//
//  Created by 藤井陽介 on 2017/06/03.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit

class ShareInAppActivity: UIActivity {

    override var activityTitle: String? {
        return "TokyoCamera"
    }
    
    override var activityImage: UIImage? {
        return UIImage()
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
    }
}

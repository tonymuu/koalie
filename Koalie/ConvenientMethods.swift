//
//  ConvenientMethods.swift
//  Koalie
//
//  Created by Tony Mu on 9/10/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import Foundation

class ConvenientMethods: NSObject {
    static func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    static func applicationDocumentsDirectory()-> URL {
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
    }
    
//    fileprivate func generateProfileImageView(_ urlString: String) -> UIView {
//        let hw = (self.navigationController?.navigationBar.frame.size.height)! - 10
//        let imgViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: hw, height: hw))
//        let imgView = UIImageView(frame: imgViewContainer.frame)
//        let url = URL(string: urlString)
//        if let imgData = try? Data(contentsOf: url!) {
//            imgView.image = UIImage(data: imgData)
//            let textAttachment = NSTextAttachment()
//            textAttachment.image = UIImage(data: imgData)
//            let attachmentString = NSAttributedString(attachment: textAttachment)
//            let myString = NSMutableAttributedString(string: "My Name")
//            myString.append(attachmentString)
//            
//        }
//        imgViewContainer.layer.cornerRadius = hw / 2
//        imgViewContainer.clipsToBounds = true
//        imgView.contentMode = .scaleAspectFill
//        
//        imgViewContainer.addSubview(imgView)
//        
//        
//        return imgViewContainer
//    }

}

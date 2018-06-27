//
//  imageViewExt.swift
//  WaterMarkerMaker
//
//  Created by Peter on 2018. 6. 26..
//  Copyright © 2018년 Peter. All rights reserved.
//

import Foundation
import UIKit

extension UIImage
{
    
    func resizeImage(_ maxSize:CGSize)->CGSize
    {
        let curSize = self.size;
        
        if curSize.width > curSize.height
        {
            let scale = curSize.width / maxSize.width
            
            return CGSize(width: curSize.width / scale, height: curSize.height / scale)
            
        }
        
        let scale = curSize.height / maxSize.height
        
        return CGSize(width: curSize.width / scale, height: curSize.height / scale)
    }
    
    
}

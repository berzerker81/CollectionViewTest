//
//  PhotoManager.swift
//  WaterMarkerMaker
//
//  Created by Peter on 2018. 6. 25..
//  Copyright © 2018년 Peter. All rights reserved.
//

import Foundation
import AssetsLibrary
import Photos


class PhotoManager
{
    static let shared:PhotoManager = PhotoManager()
    var images:Array<UIImage>      = Array()
    let pagePerCount:Int           = 30 //페이지당 사진 수
    private var photoCount:Int     = 0 //사진 갯수
    private var pageIndex:Int      = 0 //페이지 번호
    
    init(){
        print("PhotoManager Created")
        self.photoCount = 0
    }
    
    var count:Int
    {
        return images.count
    }
    
    var loadedIndex:Int            = 0 //현재 보고 있는 사진 번호
    
    public func setLoad(At index:Int, completion:@escaping ([Any])->Void)
    {
        self.loadedIndex = index
        
        if pagePerCount * (pageIndex + 1) - 5 < self.loadedIndex
        {
            pageIndex += 1
            self.getPhotos(completion: completion)
        }
        
    }
    

    var currentAssets:PHFetchResult<PHAsset>?
    
    public func getPhotos(completion:@escaping ([Any])->Void){
        
        switch PHPhotoLibrary.authorizationStatus()
        {
        case .authorized:
            
            currentAssets = PHAsset.fetchAssets(with: .image, options: nil)
            self.photoCount = self.currentAssets!.count
            
            let manager = PHImageManager.default()
            var completeCount:Int = 0
            for i in (pageIndex * pagePerCount) ..< pagePerCount*(pageIndex+1)
            {
                
                let asset = self.currentAssets!.object(at: i)
                manager.requestImage(for: asset,
                                     targetSize: PHImageManagerMaximumSize,
                                     contentMode: .default,
                                     options: nil)
                { (image, dict) in
                   completeCount+=1
                    
                    if let img = image
                    {
                        self.images.append(img)
                    }
                    
                    if completeCount >= self.pagePerCount
                    {
                        completion(self.images)
                    }
                }
            }
            break
            
        case .denied:
            accessOption()
            break
            
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization {
                switch $0
                {
                case .authorized: break
                    
                case .denied:
                    
                    self.accessOption()
                    
                    break
                default: break
                }
            }
            break
            
        case .restricted: break
        }
        
    }
    
    
    private func accessOption()
    {
        
        
        let alert = UIAlertController(title: "사진 접근 권한", message: "사진 접근 권한이 필요합니다. 옵션에서 설정해주세요.", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "이동", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString)
            {
                
                let options = [String:Any]()
                
                UIApplication.shared.open(url, options: options) {
                    if $0
                    {
                        print("open success")
                    }
                }
                
                if let appDel = UIApplication.shared.delegate as? AppDelegate
                {
                    appDel.backGroundReason = .BackGroundActionAccessPhotoAuthorization
                }
            }
        }
        
        let action2 = UIAlertAction(title: "취소", style: .default) { _ in
            
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        
        if let appDel = UIApplication.shared.delegate as? AppDelegate
        {
            if let curVC = appDel.currentViewController()
            {
                curVC.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

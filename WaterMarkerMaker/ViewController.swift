//
//  ViewController.swift
//  WaterMarkerMaker
//
//  Created by Peter on 2018. 6. 25..
//  Copyright © 2018년 Peter. All rights reserved.
//

import UIKit



class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CVLayoutDelegate
{
    
    func CVLayoutItemSize(at ItemPath: IndexPath) -> CGSize? {
        let item = PhotoManager.shared.images[ItemPath.row]
        let resz = item.resizeImage(CGSize(width: 80, height: 80))
        return resz
    }
    
    @IBOutlet weak var waterMarkCollection: UICollectionView!
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var currentImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let man = PhotoManager.shared
        man.getPhotos { (results) in
            
            self.photoCollection.reloadData()
            
        }
        
        if let cvLayout = self.photoCollection.collectionViewLayout as? CVLayout
        {
            cvLayout.delegate = self
        }
        
        
    }
    
    //MARK: collectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.isEqual(self.photoCollection)
        {
            let photoCnt = PhotoManager.shared.count
            print("photo count %d", photoCnt)
            return photoCnt
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:ImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageView", for: indexPath) as! ImageCell
        
        cell.imgView.image = PhotoManager.shared.images[indexPath.row]
        
        
        if let firstCell = collectionView.visibleCells.first
        {
            if firstCell.isEqual(cell)
            {
                cell.largeImg = true
            }else
            {
                cell.largeImg = false
            }

        }
        
        
        return cell
    }
    
    
    //MARK:ScrollView Delegate
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("ScrollView begin decelerating")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("ScrollView end decelerating")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("ScrollView did End Animation")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



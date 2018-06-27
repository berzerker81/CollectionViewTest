//
//  CollectionViewLayout.swift
//  WaterMarkerMaker
//
//  Created by Peter on 2018. 6. 26..
//  Copyright © 2018년 Peter. All rights reserved.
//

import UIKit

protocol CVLayoutDelegate
{
    func CVLayoutItemSize(at ItemPath:IndexPath)->CGSize?
}

class CVLayout:UICollectionViewLayout
{
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    var contentWidth:CGFloat  = 0
    var contentHeight:CGFloat = 0
    
    var delegate:CVLayoutDelegate?
    
    override var collectionViewContentSize: CGSize
    {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {

        if let items = self.collectionView?.numberOfItems(inSection: 0)
        {
            let cvViewHeight = self.collectionView?.bounds.size.height
            
            print("collectionView \(items)")
            
            
            var posX:CGFloat = 0
            var prevWidth:CGFloat = 0
            let spacing:CGFloat = 5
            
            for item in 0..<items
            {
                var itemSz:CGSize = CGSize(width: 0, height: 0)
                let indexPath = IndexPath(row: item, section: 0)
                let curAttr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
               
                if let itemsz = self.delegate?.CVLayoutItemSize(at: indexPath)
                {
                    itemSz = itemsz
                    let itemPos = CGPoint(x: posX + spacing + prevWidth, y: (cvViewHeight! - itemSz.height)/2) //중간Y
                    posX = itemPos.x
                    prevWidth = itemSz.width
                    curAttr.frame = CGRect(origin: itemPos, size: itemSz)
                    
                    print("x:\(itemPos.x) y:\(itemPos.y)")
                    layoutAttributes.append(curAttr)
                }
            }
            
            contentHeight = cvViewHeight!
            contentWidth  = posX + prevWidth
            
        }
    }
    var callCnt:Int = 0
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.item]
    }
}




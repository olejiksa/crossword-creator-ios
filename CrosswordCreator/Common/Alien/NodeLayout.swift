//
//  NodeMap.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 23/01/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class NodeLayout : UICollectionViewFlowLayout {
    var itemWidth : CGFloat
    var itemHeight : CGFloat
    var space : CGFloat
    
    var columns: Int{
        return self.collectionView!.numberOfItems(inSection: 0)
    }
    
    var rows: Int{
        return self.collectionView!.numberOfSections
    }
    
    init(itemWidth: CGFloat, itemHeight: CGFloat, space: CGFloat) {
        self.itemWidth = itemWidth
        self.itemHeight = itemHeight
        self.space = space
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.itemWidth = 50
        self.itemHeight = 50
        self.space = 3
        super.init()
    }
    
    override var collectionViewContentSize: CGSize{
        let w : CGFloat = CGFloat(columns) * (itemWidth + space) - space
        let h : CGFloat = CGFloat(rows) * (itemHeight + space)
        return CGSize(width: w, height: h)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let x : CGFloat = CGFloat(indexPath.row) * (itemWidth + space)
        let y : CGFloat = CGFloat(indexPath.section) * (itemHeight + space)
        attributes.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let minRow : Int = (rect.origin.x > 0) ? Int(floor(rect.origin.x/(itemWidth + space))) : 0
        let maxRow : Int = min(columns - 1, Int(ceil(rect.size.width / (itemWidth + space)) + CGFloat(minRow)))
        var attributes : Array<UICollectionViewLayoutAttributes> = [UICollectionViewLayoutAttributes]()
        for i in 0 ..< rows {
            for j in minRow ... maxRow {
                attributes.append(self.layoutAttributesForItem(at: IndexPath(item: j, section: i))!)
            }
        }
        return attributes
    }
}

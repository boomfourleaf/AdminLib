//
//  GridSystemLayout.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 6/20/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit
import flFoundation

protocol GridSystemLayoutDelegate {
    // 1
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath,
                        withWidth:CGFloat) -> CGFloat
    // 2
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
}

class GridSystemLayout: UICollectionViewLayout {
    // 1
    var delegate: GridSystemLayoutDelegate!
    
    // 2
    var numberOfColumns = DeviceType.IS_IPAD ? 3:1

    var cellPadding: CGFloat = 6.0
    
    // 3
    private var cache = [UICollectionViewLayoutAttributes]()
    
    // 4
    private var contentHeight: CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    
    func clearCacheLayout(){
        cache = []
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func prepareLayout() {
        // 1
        clearCacheLayout()
        if cache.isEmpty {
            // 2
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            var column = 0
            var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
            
            // 3
            for section in 0 ..< collectionView!.numberOfSections() {
                for item in 0 ..< collectionView!.numberOfItemsInSection(section) {
                    
                    let indexPath = NSIndexPath(forItem: item, inSection: section)
                    
                    // 4
                    let width = columnWidth - cellPadding * 2
                    flLog.debug("\(width)")
                    let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath,
                                                              withWidth:width)
                    let annotationHeight = delegate.collectionView(collectionView!,
                                                                   heightForAnnotationAtIndexPath: indexPath, withWidth: width)
                    let height = cellPadding +  photoHeight + annotationHeight + cellPadding
                    let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                    let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                    
                    // 5
                    let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                    attributes.frame = insetFrame
                    cache.append(attributes)
                    
                    // 6
                    contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                    yOffset[column] = yOffset[column] + height
                    
                    column = column >= (numberOfColumns - 1) ? 0 : ++column
                }
            }
        }
    }
}

//
//  PagingCollectionViewLayout.swift
//  Saving insta
//
//  Created by Igor Sorokin on 11.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

import UIKit

@objc protocol PagingCollectionFlowDelegate: NSObjectProtocol {
    func pagingCollectionFlow(currentItemDidChange new: Int)
}

@objcMembers class PagingCollectionViewLayout: UICollectionViewFlowLayout {
    
    dynamic weak var delegate: PagingCollectionFlowDelegate?
    
    var currentItemIndex = 0 {
        didSet {
            delegate?.pagingCollectionFlow(currentItemDidChange: currentItemIndex)
        }
    }
    
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        
        guard let collectionView = collectionView else { return }
        collectionView.decelerationRate = .fast
    }
    
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        
        let nextPosit = nextPosition(for: proposedContentOffset, velocity: velocity)
        let projectedOffset = contentOffset(for: nextPosit)

        let isSameCell = nextPosit == currentItemIndex
        if isSameCell {
            animateBackwardScroll(to: nextPosit)
            return collectionView!.contentOffset
        }

        currentItemIndex = nextPosit
        return projectedOffset
    }

    private func nextPosition(for proposedOffset: CGPoint, velocity: CGPoint) -> Int {
        let thirdPartCell = itemSize.width / 3
        let cellOffsetX = itemSize.width * CGFloat(currentItemIndex) - CGFloat(currentItemIndex) * (minimumLineSpacing * 2) - collectionView!.contentInset.left
        let directionOffset = proposedOffset.x - cellOffsetX
        
        if directionOffset > 0, directionOffset > thirdPartCell {
            return currentItemIndex + 1
        }
        if directionOffset < 0, -directionOffset > thirdPartCell {
            return currentItemIndex - 1
        }

        return currentItemIndex
    }
    
    private func contentOffset(for itemIndex: Int) -> CGPoint {
        let cellWidth = itemSize.width
        let screenHalf = collectionView!.bounds.width / 2
        
        let contentOffsetX = cellWidth * CGFloat(itemIndex) + minimumLineSpacing * CGFloat(itemIndex)
        let midX = contentOffsetX + cellWidth / 2
        let newX = midX - screenHalf

        return CGPoint(x: newX, y: 0)
    }
    
    private func animateBackwardScroll(to index: Int) {
        let path = IndexPath(row: index, section: 0)
        collectionView?.scrollToItem(at: path, at: .centeredHorizontally, animated: true)

        DispatchQueue.main.async {
            self.collectionView?.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
        }
    }
    
}

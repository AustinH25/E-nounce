//
//  UICollectionView_Additions.swift
//  E-nounce
//
//  Created by austin huang on 11/15/19.
//  Copyright © 2019 Yu WenLiao. All rights reserved.
//

import UIKit

extension UIScrollView{
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    
    var isAtBottom: Bool{
        return contentOffset.y >= verticalOffsetForBottom
    }
}

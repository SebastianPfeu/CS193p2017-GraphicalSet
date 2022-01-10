//
//  CardContainerView.swift
//  GraphicalSet
//
//  Created by Sebastian Pfeufer on 08/05/2021.
//

import UIKit

class CardContainerView: UIView {
    
    // definition of grid (i.e. flexible container to place subviews into) and its positions within CardContainerView
    private var grid = Grid(layout: Grid.Layout.aspectRatio(3/2))
    private var centeredRect: CGRect {
        return CGRect(x: bounds.size.width * 0.025, y: bounds.size.height * 0.025, width: bounds.size.width * 0.95, height: bounds.size.height * 0.95)
    }
    
    // all symbol views are stored in an array
    var cardViews = [CardView]()
    
    // each symbol view is placed into a single cell of grid
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.frame = centeredRect
        grid.cellCount = cardViews.count
        
        if grid.cellCount > 0 {
            for i in 0...grid.cellCount-1 {
                if let frame = grid[i] {
                    cardViews[i].frame = frame
                    cardViews[i].backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
                    addSubview(cardViews[i])
                }
            }
        }
    }
    
    // all symbols will be removed from CardContainerView
    func removeCards() {
        for view in subviews {
            view.removeFromSuperview()
        }
        cardViews = [CardView]()
    }
}

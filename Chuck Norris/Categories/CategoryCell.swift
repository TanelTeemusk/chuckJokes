//
//  CategoryTableViewCell.swift
//  Chuck Norris
//
//  Created by Tanel Teemusk on 22/10/2018.
//  Copyright © 2018 Tanel Teemusk. All rights reserved.
//

import UIKit
import BadgeSwift

class CategoryCell: TableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var badge: BadgeSwift!
    
    override func populate(data: TableCellContent) {
        if let data = data as? Category {
            labelTitle.text = data.title.prefix(1).uppercased() + data.title.dropFirst()
            let filtered = JokesModel.shared.favorites.filter { value in
                if let categories = value.category {
                    return categories.contains(data.title)
                }
                return false
            }
            
            badge.text = "\(filtered.count)"
            badge.isHidden = filtered.isEmpty
        }
    }
    
}

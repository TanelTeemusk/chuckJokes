//
//  TableViewCell.swift
//  hINF
//
//  Created by Tanel Teemusk on 29/08/2017.
//  Copyright © 2017 Tanel Teemusk. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    var id:String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        super.setSelected(false, animated: true)
    }

    func populate(data: TableCellContent) {}

}

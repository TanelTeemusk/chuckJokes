//
//  TableControllerDataStructures.swift
//  InaDevelopment
//
//  Created by Tanel Teemusk on 24/05/2018.
//  Copyright © 2018 Tanel Teemusk. All rights reserved.
//

import UIKit

enum CellsIdentifier:String {
    case baseCell
    case CategoryCell
    case JokeCell
}

struct TableSectionData {
    var id: String = ""
    var header: String?
    var headerView: UIView?
    var footerView: UIView?
    var cells: [TableCellData] = []
}

struct TableCellData {
    var id: String = ""
    var identifier: CellsIdentifier = .baseCell
    var data: TableCellContent?
}

protocol TableCellContent {}
protocol Navigable {
    var navvisPoiId: Int? { get set }
}

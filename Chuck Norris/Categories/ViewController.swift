//
//  ViewController.swift
//  Chuck Norris
//
//  Created by Tanel Teemusk on 22/10/2018.
//  Copyright © 2018 Tanel Teemusk. All rights reserved.
//

import UIKit

class ViewController: TableController {

    @IBOutlet weak var buttonStar: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell(identifier: .CategoryCell)
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        self.navigationItem.leftBarButtonItem = JokesModel.shared.favorites.isEmpty ? nil : buttonStar
    }
    
    private func fetchData() {
        NetworkRequest.get(with: .categories) { [unowned self] data, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode([String].self, from: data)
                self.tableData = [self.getTableSection(with: decoded)]
                self.tableView.reloadData()
            } catch let error {
                print("Decode error: \(error)")
            }
        }
    }

    private func getTableSection(with data: [String]) -> TableSectionData {
        var section = TableSectionData()
        data.forEach {
            let cellContent = Category(title: $0)
            var cellData = TableCellData()
            cellData.data = cellContent
            cellData.id = $0
            cellData.identifier = .CategoryCell
            section.cells.append(cellData)
        }
        return section
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toJokes", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? JokesViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            target.category = tableData[indexPath.section].cells[indexPath.row].id
        }
    }
}

struct Category: Codable, TableCellContent {
    var title: String
}


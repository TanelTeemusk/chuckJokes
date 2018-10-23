//
//  JokesViewController.swift
//  Chuck Norris
//
//  Created by Tanel Teemusk on 22/10/2018.
//  Copyright © 2018 Tanel Teemusk. All rights reserved.
//

import UIKit

class JokesViewController: TableController {

    let maxJokes: Int = 3
    var category: String?
    
    var section = TableSectionData()
    var tries: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell(identifier: .JokeCell)
        if let category = self.category {
            self.title = category
            self.fetchJoke()
        } else {
            self.title = "Favorites"
            self.populateWithFavorites()
        }
    }
    
    private func fetchJoke() {
        guard let category = self.category else { return }
        NetworkRequest.get(with: .joke, params: ["category":category]) { data, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode(Joke.self, from: data)
                
                if !self.section.cells.contains(where: { $0.id == decoded.id }) {
                    
                    self.section.cells.append(self.jokeCell(with: decoded))
                    self.tableData = [self.section]
                    self.tableView.reloadData()
                    self.tries = 0
                }
                if self.section.cells.count < self.maxJokes && self.tries < 3 {
                    self.tries += 1
                    self.fetchJoke()
                }
            } catch let error {
                print("Decode error: \(error)")
            }
            
        }
    }
    
    private func jokeCell(with joke: Joke) -> TableCellData {
        var cell = TableCellData()
        cell.id = joke.id
        cell.identifier = .JokeCell
        cell.data = joke
        return cell
    }
    
    private func populateWithFavorites() {
        JokesModel.shared.favorites.forEach {
            self.section.cells.append(self.jokeCell(with: $0))
            self.tableData = [self.section]
            self.tableView.reloadData()
        }
    }

}

struct Joke: Codable, TableCellContent {
    var category: [String]?
    var icon_url: String
    var id: String
    var url: String
    var value: String
}

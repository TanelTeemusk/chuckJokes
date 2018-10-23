//
//  JokeCell.swift
//  Chuck Norris
//
//  Created by Tanel Teemusk on 22/10/2018.
//  Copyright © 2018 Tanel Teemusk. All rights reserved.
//

import UIKit

class JokeCell: TableViewCell {

    @IBOutlet weak var labelBody: UILabel!
    @IBOutlet weak var buttonFavorite: UIButton!
    
    private var data: Joke?
    private var offColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1)
    private var onColor = UIColor(red: 214/255, green: 200/255, blue: 20/255, alpha: 1)
    
    override func populate(data: TableCellContent) {
        if let data = data as? Joke {
            self.data = data
            labelBody.text = data.value
            updateFavorite(with: data)
        }
    }
    
    @IBAction func actionFavorite(_ sender: Any) {
        guard let data = data else { return }
        if let index = JokesModel.shared.favorites.index(where: { $0.id == data.id }) {
            JokesModel.shared.favorites.remove(at: index)
            buttonFavorite.tintColor = offColor
        } else {
            JokesModel.shared.favorites.append(data)
            buttonFavorite.tintColor = onColor
        }
    }
    
    private func updateFavorite(with data: Joke) {
        buttonFavorite.tintColor = JokesModel.shared.favorites.contains(where: { $0.id == data.id}) ? onColor : offColor
    }
}

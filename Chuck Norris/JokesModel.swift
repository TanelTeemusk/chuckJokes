//
//  JokesModel.swift
//  Chuck Norris
//
//  Created by Tanel Teemusk on 22/10/2018.
//  Copyright © 2018 Tanel Teemusk. All rights reserved.
//

import UIKit
import Disk

struct CategoryFavorites {
    var title: String
    var jokes: [Joke] = []
}

class JokesModel: NSObject {
    static let shared: JokesModel = JokesModel()
    
    var favorites: [Joke] = [] {
        didSet {
            if oldValue.count != favorites.count {
                do {
                    try Disk.save(favorites, to: .caches, as: "favorites.json")
                } catch {
                }
            }
        }
    }
    
    override init() {
        do {
         let retrievedFavorites = try Disk.retrieve("favorites.json", from: .caches, as: [Joke].self)
            self.favorites = retrievedFavorites
        } catch {
        }
    }
}

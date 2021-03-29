//
//  GameSelectionViewController.swift
//  Chip8-iOS-Example
//
//  Created by Carlos Duclos on 12/03/21.
//  Copyright © 2021 Chip8. All rights reserved.
//

import Foundation
import UIKit

final class GameSelectionViewController: UITableViewController {
    
    let games: [Game] = [.invaders, .pong, .maze, .space, .tank, .tetris, .tictactoe, .wall, .particle, .brix]
    
    override func viewDidLoad() {
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = games[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameCell
        cell.titleLabel.text = game.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = games[indexPath.row]
        let gameController = GameController.instance(game: game)
        navigationController?.pushViewController(gameController, animated: true)
    }
}

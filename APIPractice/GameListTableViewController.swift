//
//  GameListTableViewController.swift
//  APIPractice
//
//  Created by Bogdan Anishchenkov on 16.09.2022.
//

import UIKit

class GameListTableViewController: UITableViewController {
    
    var games = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchGames()
        registerTableViewCells()
        print(games)
    }
    
    private func fetchGames() {
        guard let url = URL(string: "https://www.freetogame.com/api/games?platform=browser&category=mmorpg&sort-by=release-date") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let parsedJSON = try jsonDecoder.decode([Game].self, from: data)
                    DispatchQueue.main.async {
                        self.games = parsedJSON
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "game") as? GameTableViewCell {
            for label in cell.gameInfoLabel {
                switch label.tag {
                case 0: label.text = "Title: \(games[indexPath.row].title)"
                case 1: label.text = games[indexPath.row].genre
                case 2: label.text = games[indexPath.row].platform
                case 3: label.text = games[indexPath.row].developer
                case 4: label.text = games[indexPath.row].short_description
                default: label.text = games[indexPath.row].release_date
                }
            }
            cell.gameImage.contentMode = .scaleAspectFill
            cell.gameImage.downloaded(from: games[indexPath.row].thumbnail)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    private func registerTableViewCells() {
        let gameCell = UINib(nibName: "GameTableViewCell",
                             bundle: nil)
        self.tableView.register(gameCell,
                                forCellReuseIdentifier: "game")
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
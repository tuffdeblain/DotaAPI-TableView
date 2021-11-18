//
//  ViewController.swift
//  DotaAPI TableView
//
//  Created by Сергей Кудинов on 13.11.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recentMatchesTableView: UITableView!
    @IBOutlet weak var winCountLabel: UILabel!
    @IBOutlet weak var loseCountLabel: UILabel!
    @IBOutlet weak var winRateLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var mmrLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    
    private var recentMatches: [RecentMatch] = []
    private var playerData: PlayerModel?
    private var winRate: Double?
    var steamID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(URLS.playerInfoURL.rawValue + steamID!)
        getData(steamID: steamID!)
        avatarImage.layer.borderWidth = 2
        avatarImage.layer.borderColor = CGColor(red: 102/255, green: 192/255, blue: 244/255, alpha: 1)
        navigationItem.hidesBackButton = true
        recentMatchesTableView.delegate = self
        recentMatchesTableView.dataSource = self
    }

}

extension ViewController {
    private func getData(steamID: String) {
        NetworkManager.shared.getPlayerInfo(url: (URLS.playerInfoURL.rawValue + steamID)) { playerInfo in
            DispatchQueue.main.async {
                self.playerData = playerInfo
                self.nickNameLabel.text = playerInfo.profile?.personaName
                self.mmrLabel.text = "\(playerInfo.soloCompetitiveRank ?? 0)"
                self.regionLabel.text = playerInfo.profile?.countryCode ?? "unknown"
                self.getAvatar(avatarURL: self.playerData?.profile?.avatarFullURL ?? "")
                self.getWinRatePlayer(steamID: steamID)
                self.getRecentMatches(url: URLS.playerInfoURL.rawValue + "904084786/recentMatches")
                
                
                
            }
        }
    }
    
    private func getAvatar(avatarURL: String) {
        NetworkManager.shared.getPlayerAvatar(url: avatarURL) { imageData in
                self.avatarImage.image = UIImage(data: imageData)
            
        }
    }
 
    private func getWinRatePlayer(steamID: String) {
        NetworkManager.shared.getWinRatePlayer(steamID: steamID) { winRate in
            let winRates = self.countWinRate(winCount: (winRate.win ?? 0), and: (winRate.lose ?? 1))
            
            self.winCountLabel.text = String(winRate.win ?? 0)
            self.loseCountLabel.text = String(winRate.lose ?? 0)
            self.winRateLabel.text = String(round(winRates * 100) / 100) + "%"
        }
    }
    
    private func countWinRate(winCount: Int, and loseCount: Int) -> Double {
        (Double(winCount) / (Double(winCount) + Double(loseCount)) * 100)
    }
    
    private func getRecentMatches(url: String) {
        NetworkManager.shared.getPlayerRecentMatches(url: url) { recentMatches in
            self.recentMatches = recentMatches
            print(self.recentMatches.count)
            self.recentMatchesTableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(70)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recentMatches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(recentMatches[indexPath.item].kills ?? 123)
        cell.textLabel?.textColor = .white
        cell.imageView?.image = avatarImage.image
        return cell
    }
    
    
}

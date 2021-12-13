//
//  DotaHeroesViewController.swift
//  DotaAPI TableView
//
//  Created by Сергей Кудинов on 10.11.2021.
//
import Alamofire
import SwiftyJSON
import UIKit

class DotaHeroesViewController: UITableViewController {


    private var imageData: UIImage?
    private var dotaHeroes: [DotaHero?] =  []
    private var jsonArray: [JSON]? = []
    private var index = 0
    private var selectedCellIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dotaHeroes.count 
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as! DotaHeroesTableViewCell
        index = indexPath.item
        if (dotaHeroes[index]?.name != nil){
            
           
            cell.textLabel?.text = dotaHeroes[index]?.localized_name
            cell.textLabel?.textColor = UIColor.white
            cell.getImage(imageURL: URLS.opedDotaURL.rawValue + (self.dotaHeroes[index]?.icon ?? ""))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndex = indexPath.item
        performSegue(withIdentifier: "detailsSegue", sender: nil)
    }
    

}

extension DotaHeroesViewController {
   private func getData() {
        NetworkManager.shared.getDataForHeroes { heroes in
            DispatchQueue.main.async {
                self.dotaHeroes = heroes
                self.tableView.reloadData()
            }
        }
    }

    
    private func getImage(url: String, index: Int){
        NetworkManager.shared.getImageForHeroe(url: url, index: index) { data in
            self.dotaHeroes[index]?.iconData = data
        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let heroDetailsVC = segue.destination as? HeroDetailsViewController else { return }
        heroDetailsVC.dotaHeroes = dotaHeroes[selectedCellIndex]
    }
}

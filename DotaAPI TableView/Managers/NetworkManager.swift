//
//  NetworkManager.swift
//  DotaAPI TableView
//
//  Created by Сергей Кудинов on 08.11.2021.
//

import Foundation
import Alamofire
import SwiftyJSON


class NetworkManager {
    static let shared = NetworkManager()
    

    func getData(_ completion: @escaping ([DotaHero]) -> Void) {
        var dotaHeroes: [DotaHero] = []
        AF.request(URLS.openDotaHeroURL.rawValue, method: .get)
            .validate()
        
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    for count in 1..<(json.count + 22) {
                        
                        let heroJSON = json["\(count)"]
                        
                        if (heroJSON["localized_name"].string != nil) {
                            let hero = DotaHero(id: heroJSON["id"].int,
                                                name: heroJSON["name"].string,
                                                localized_name: heroJSON["localized_name"].string,
                                                icon: heroJSON["icon"].string,
                                                primary_attr: heroJSON["primary_attr"].string,
                                                attack_type: heroJSON["attack_type"].string,
                                                img: heroJSON["img"].string,
                                                base_health: heroJSON["base_health"].int,
                                                base_health_regen: heroJSON["base_health_regen"].double,
                                                base_mana: heroJSON["base_mana"].int,
                                                base_mana_regen: heroJSON["base_mana_regen"].double,
                                                base_armor: heroJSON["base_armor"].int,
                                                base_attack_min: heroJSON["base_attack_min"].int,
                                                base_attack_max: heroJSON["base_attack_max"].int,
                                                base_str: heroJSON["base_str"].int,
                                                base_agi: heroJSON["base_agi"].int,
                                                base_int: heroJSON["base_int"].int,
                                                str_gain: heroJSON["str_gain"].double,
                                                agi_gain: heroJSON["agi_gain"].double,
                                                int_gain: heroJSON["int_gain"].double,
                                                move_speed: heroJSON["move_speed"].int,
                                                legs: heroJSON["legs"].int)
                            dotaHeroes.append(hero)
                        }
                        
                    }
                    completion(dotaHeroes)
                case .failure(let error):
                    print(error)
                }
                
            }
    }
    
    func getImage(url: String, index: Int, completion: @escaping (Data) -> Void){
        AF.download(URLS.opedDotaURL.rawValue + url)
            .validate()
            .responseData { responseData in
                if let data = responseData.value {
                    DispatchQueue.main.async {
                        completion(data)
                    }
                    
                }
            }
    }
    
    
    private init() {}
}


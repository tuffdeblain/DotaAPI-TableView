//
//  HeroDetailsViewController.swift
//  DotaAPI TableView
//
//  Created by Сергей Кудинов on 11.11.2021.
//

import UIKit

class HeroDetailsViewController: UIViewController {

    @IBOutlet weak var heroImage: UIImageView!
    
    @IBOutlet weak var strLabel: UILabel!
    @IBOutlet weak var agiLabel: UILabel!
    @IBOutlet weak var intLabel: UILabel!
    @IBOutlet weak var moveSpeedLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var armorLabel: UILabel!
    @IBOutlet weak var legsLabel: UILabel!
    @IBOutlet weak var primaryAttrLabel: UILabel!
    @IBOutlet weak var attackTypeLabel: UILabel!
    
    var heroImageData: Data?
    var dotaHeroes: DotaHero?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = dotaHeroes?.localized_name
        heroImage.layer.cornerRadius = 10
        strLabel.text = "\(dotaHeroes?.base_str ?? 0)"
        NetworkManager.shared.getImage(url: dotaHeroes?.img ?? "", index: 0) { responseData in
            self.heroImage.image = UIImage(data: responseData)
        }
        customizingLabels()
    }
}

extension HeroDetailsViewController {
    func getColorizedText(base: Int, and gain: Double) -> NSMutableAttributedString {
        var customString = NSMutableAttributedString()
        customString = NSMutableAttributedString(string: "\(base)+\(gain)")
        customString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGreen, range: NSRange(location: 2, length: ("\(gain)").count + 1 ))
        return(customString)
    }
    
    func customizingLabels() {
        strLabel.attributedText = getColorizedText(base: dotaHeroes?.base_str ?? 0, and: dotaHeroes?.str_gain ?? 4)
        agiLabel.attributedText = getColorizedText(base: dotaHeroes?.base_agi ?? 0, and: dotaHeroes?.agi_gain ?? 4)
        intLabel.attributedText = getColorizedText(base: dotaHeroes?.base_int ?? 0, and: dotaHeroes?.int_gain ?? 4)
        armorLabel.text = String(dotaHeroes?.base_armor ?? 0)
        moveSpeedLabel.text = String(dotaHeroes?.move_speed ?? 0)
        attackLabel.text = "\(dotaHeroes?.base_attack_min ?? 0)-\(dotaHeroes?.base_attack_max ?? 0)"
        legsLabel.text = String(dotaHeroes?.legs ?? 2)
        primaryAttrLabel.text = "Primary Attribute: \(dotaHeroes?.primary_attr?.localizedUppercase ?? "")"
        attackTypeLabel.text = "Attack Type: \(dotaHeroes?.attack_type ?? "")"
    }
}

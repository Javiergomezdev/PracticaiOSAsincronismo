//
//  HeroTableViewCell.swift
//  KCProfessional
//
//  Created by Luis Escamez Sanchez on 30/4/25.
//

import UIKit

class HeroTableViewCell: UITableViewCell {

    @IBOutlet weak var heroTitleText: UILabel!
    @IBOutlet weak var heroImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with hero: HerosModel) {
        textLabel?.text = hero.name
        // Aquí puedes añadir más configuración, como imagen si tienes imageView
    }
}

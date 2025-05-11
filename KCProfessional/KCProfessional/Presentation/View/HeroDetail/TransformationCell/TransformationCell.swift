//
//  TransformationCell.swift
//  KCProfessional
//
//  Created by Javier Gomez on 5/5/25.
//

import UIKit

class TransformationCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor(named: "AppBackground")
       
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
    // Metodo para configurar la celda con los datos del view model
    func configure(with viewModel: TransformationCellViewModel) {
        nameLabel.text = viewModel.name
        
        
        if let url = URL(string: viewModel.imageUrl), !viewModel.imageUrl.isEmpty {
            imageView.loadImageRemote(url: url)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
}

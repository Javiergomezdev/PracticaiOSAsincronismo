//
//  HeroDetailView.swift
//  KCProfessional
//
//  Created by Javier Gomez on 5/5/25.
//

import UIKit

final class HeroDetailView: UIView {

    public let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    public let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.textAlignment = .justified
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    public let transformationsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "TRANSFORMATIONS"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public let transformationsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: 120, height: 140)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isHidden = true
        collectionView.register(TransformationCell.self, forCellWithReuseIdentifier: "TransformationCell")
        return collectionView
    }()

    init(hero: HerosModel) {
        super.init(frame: .zero)
        setupViews()
        configure(with: hero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .systemBackground
        addSubview(heroImageView)
        addSubview(descriptionTextView)
        addSubview(transformationsTitleLabel)
        addSubview(transformationsCollectionView)

        NSLayoutConstraint.activate([
            heroImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            heroImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            heroImageView.heightAnchor.constraint(equalTo: heroImageView.widthAnchor, multiplier: 0.6),

            descriptionTextView.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 300),

            transformationsTitleLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 8),
            transformationsTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            transformationsTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            transformationsTitleLabel.heightAnchor.constraint(equalToConstant: 20),

            transformationsCollectionView.topAnchor.constraint(equalTo: transformationsTitleLabel.bottomAnchor, constant: 10),
            transformationsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            transformationsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            transformationsCollectionView.heightAnchor.constraint(equalToConstant: 120),
            transformationsCollectionView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }

    func configure(with hero: HerosModel) {
        if let url = URL(string: hero.photo) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.heroImageView.image = image
                    }
                }
            }
        }
        descriptionTextView.text = hero.description
    }

    func updateTransformations(isHidden: Bool) {
        transformationsTitleLabel.isHidden = isHidden
        transformationsCollectionView.isHidden = isHidden
    }

    func setCollectionViewDelegate(_ delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        transformationsCollectionView.delegate = delegate
        transformationsCollectionView.dataSource = dataSource
    }
}

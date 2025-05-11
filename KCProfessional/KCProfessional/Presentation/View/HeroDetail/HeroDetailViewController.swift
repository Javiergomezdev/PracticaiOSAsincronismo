//
//  HeroDetailViewController.swift
//  KCProfessional
//
//  Created by Javier Gomez on 5/5/25.
//

import UIKit
import Combine

final class HeroDetailViewController: UIViewController {
   

    private let hero: HerosModel
    public let heroDetailView: HeroDetailView
    private let transformationsViewModel: TransformationsViewModel
    public var transformations: [TransformationModel] = []
    public var subscriptions = Set<AnyCancellable>()


    init(hero: HerosModel) {
        self.hero = hero
        self.heroDetailView = HeroDetailView(hero: hero)
        self.transformationsViewModel = TransformationsViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   
    override func loadView() {
        heroDetailView.setCollectionViewDelegate(self, dataSource: self)
        view = heroDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupBindings()
        fetchTransformations()
    }


    func setupBindings() {
        transformationsViewModel.$transformationData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] transformations in
                guard let self = self else { return }
                self.transformations = transformations
                self.heroDetailView.updateTransformations(isHidden: transformations.isEmpty)
                self.heroDetailView.transformationsCollectionView.reloadData()
            }
            .store(in: &subscriptions)
    }

    func fetchTransformations() {
        Task {
            await transformationsViewModel.getTransformations(id: hero.id)
        }
    }

    func setupNavigationBar() {
        let exitButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: self,
            action: #selector(navigateBack))
        exitButton.tintColor = .blue
        navigationItem.leftBarButtonItem = exitButton
    }

    @objc public func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension HeroDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transformations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransformationCell", for: indexPath) as? TransformationCell else {
            fatalError("Unable to dequeue TransformationCell")
        }
        let transformation = transformations[indexPath.item]
        cell.configure(with: transformation)
        return cell
    }

    
}

//
//  TransformationUseCase.swift
//  KCProfessional
//
//  Created by Javier Gomez on 5/5/25.
//

import Foundation

protocol TransformationUseCaseProtocol {
    var repo: TransformationRepositoryProtocol { get set }
    
    func getTransformation(filter: UUID) async -> [TransformationModel]
}

final class TransformationUseCase: TransformationUseCaseProtocol {
    var repo: TransformationRepositoryProtocol
    
    init(repo: TransformationRepositoryProtocol = TransformationRepository(network: NetworkTransformations())) {
        self.repo = repo
    }
    
    func getTransformation(filter: UUID) async -> [TransformationModel] {
        return await repo.getTransformations(filter: filter)
    }
}

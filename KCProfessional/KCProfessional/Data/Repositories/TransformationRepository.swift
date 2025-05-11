//
//  TransformationRepository.swift
//  KCProfessional
//
//  Created by Javier Gomez on 5/5/25.
//

import Foundation


final class TransformationRepository: TransformationRepositoryProtocol {
    
    private var network: NetworkTransformationsProtocol
    
    init(network: NetworkTransformationsProtocol) {
        self.network = network
        
    }
    
    func getTransformations(filter: UUID) async -> [TransformationModel] {
        return await network.getTransformations(filter: filter)
    }
}

final class TransformationsRepositryFake: TransformationRepositoryProtocol {
    private var network: NetworkTransformationsProtocol
    
    
    init(network: NetworkTransformationsProtocol = NetworkTransformationsFake()) {
        self.network = network
    }
    
    func getTransformations(filter: UUID) async -> [TransformationModel] {
        return await network.getTransformations(filter: filter)
    }
    
}
final class TransformationRepositoryFakeEmpty: TransformationRepositoryProtocol {
    func getTransformations(filter: UUID) async -> [TransformationModel] {
        return []
    }
    
    private var network: NetworkTransformationsProtocol
    
    
    init(network: NetworkTransformationsProtocol = NetworkTransformationsFake()) {
        self.network = network
    }
    
    
    
}


//
//  HeroUseCase.swift
//  KCProfessional
//
//  Created by Luis Escamez Sanchez on 30/4/25.
//

import Foundation

protocol HeroUseCaseProtocol {
    var repo:  HerosRepositoryProtocol { get set }
    func getHeros(filter: String) async -> [HerosModel]
}

final class HeroUseCase: HeroUseCaseProtocol {
    var repo: HerosRepositoryProtocol
    
    init(repo: HerosRepositoryProtocol = HerosRepository(network: NetworkHeros())) {
        self.repo = repo
    }
    
    func getHeros(filter: String) async -> [HerosModel] {
        return await repo.getHeros(fitler: filter)
    }
}

final class HeroUseCaseFake: HeroUseCaseProtocol {
    var repo: HerosRepositoryProtocol
    
    init(repo: HerosRepositoryProtocol = HerosRepository(network: NetworkHerosFake())) {
        self.repo = repo // Asigna el repositorio proporcionado o el valor por defecto.
    }
    
    func getHeros(filter: String) async -> [HerosModel] {
        return await repo.getHeros(fitler: filter)
    }
} 


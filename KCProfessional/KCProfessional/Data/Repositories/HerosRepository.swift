//
//  HerosRepository.swift
//  KCProfessional
//
//  Created by Luis Escamez Sanchez on 30/4/25.
//

import Foundation

final class HerosRepository: HerosRepositoryProtocol {
    private var network: NetworkHerosProtocol
    
   init(network: NetworkHerosProtocol) {
        self.network = network
    }
    
    func getHeros(fitler: String) async -> [HerosModel] {
        return await network.getHeros(filter: fitler)
    }
}

final class HerosRepositoryFake: HerosRepositoryProtocol {
    private var network: NetworkHerosProtocol
    
   init(network: NetworkHerosProtocol = NetworkHerosFake()) {
        self.network = network
    }
    
    func getHeros(fitler: String) async -> [HerosModel] {
        return await network.getHeros(filter: fitler)
    }
} 


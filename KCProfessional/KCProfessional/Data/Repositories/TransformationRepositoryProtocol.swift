//
//  TransformationRepositoryProtocol.swift
//  KCProfessional
//
//  Created by Javier Gomez on 5/5/25.
//


protocol TransformationRepositoryProtocol {
    func getTransformations(forHeroId id: UUID) async throws -> [TransformationModel]
}
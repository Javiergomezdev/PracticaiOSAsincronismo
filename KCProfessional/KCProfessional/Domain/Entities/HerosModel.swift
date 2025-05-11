//
//  HerosModel.swift
//  KCProfessional
//
//  Created by Luis Escamez Sanchez on 30/4/25.
//

import Foundation

struct HerosModel: Codable {
    let id: UUID
    let favorite: Bool
    let description: String
    let photo: String
    let name: String
    let transformations: [TransformationModel]?
}

//Filter the request od Heros by name
struct HeroModelRequest: Codable {
    let name: String
}

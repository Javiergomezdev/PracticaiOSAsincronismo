//
//  TransformationRepositoryProtocol.swift
//  KCProfessional
//
//  Created by Javier Gomez on 5/5/25.
//

import Foundation


protocol TransformationRepositoryProtocol {
    func getTransformations(filter: UUID) async  -> [TransformationModel]
}

//
//  HerosRepositoryProtocol.swift
//  KCProfessional
//
//  Created by Luis Escamez Sanchez on 30/4/25.
//

import Foundation

protocol HerosRepositoryProtocol {
    func getHeros(fitler: String) async -> [HerosModel]
    }
   
    

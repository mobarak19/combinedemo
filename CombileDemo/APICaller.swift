//
//  APICaller.swift
//  CombileDemo
//
//  Created by Genusys Inc on 10/19/22.
//
import Combine
import Foundation

class APICaller{
    static let shared = APICaller()
    
    func fetchCompanies()->Future<[String],Error>{
        return Future{ promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                promise(.success(["Apple","Microsoft","IBM","Google","Facebook","Whatsapp"]))

            }
            
        }
    }
}

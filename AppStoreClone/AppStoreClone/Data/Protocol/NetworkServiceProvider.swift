//
//  NetworkServiceProvider.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/27/25.
//

protocol NetworkServiceProvider {
    func callRequest<T: Decodable>(api: APIRouter, type: T.Type) async throws -> T
}

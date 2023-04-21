//
//  BaseCredentialsService.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

protocol BaseCredentialsService {
    func checkCredentialsState(for userID: String, _ onCheckCredentialsValid: @escaping (Bool) -> Void)
}

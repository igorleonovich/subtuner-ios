//
//  SignedRequest.swift
//  Subtuner
//
//  Created by Untitled on 5/12/20.
//  Copyright © 2020 Subtuner. All rights reserved.
//

import Foundation
import JWTDecode

extension URLSessionTask {
    
    func signedResume(core: Core) {
        checkAndTryToRefreshAccessToken(core: core) { error in
            if let error = error {
                print(error)
            } else {
                self.resume()
            }
        }
    }
    
    func checkAndTryToRefreshAccessToken(core: Core, _ completion: @escaping (Swift.Error?) -> Void) {
        do {
            guard let accessToken = try core.authManager.secureStoreWithGenericPwd.getValue(for: "accessToken") else { return }
            let jwt = try decode(jwt: accessToken)
            if jwt.expired || 1 > 0 {
                // Maybe TODO: Add ~5 sec before expiration check
                core.authManager.refreshToken { error in
                    completion(error)
                }
            } else {
                completion(nil)
            }
        } catch {
            completion(nil)
        }
    }
}

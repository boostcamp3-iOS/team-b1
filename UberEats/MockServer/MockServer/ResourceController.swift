//
//  ResourceController.swift
//  MockServer
//
//  Created by 장공의 on 06/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

class ResourceController {

    private init() {}

    static func resourceWithString(path: String, root: AnyClass, ofType type: String? = nil) throws -> String {

        guard let ret = String(data: try resourceWithData(path: path, root: root, ofType: type), encoding: .utf8) else {
            throw ResourceControlError.resourceNotFoundError
        }

        return ret
    }

    static func resourceWithData(path: String, root: AnyClass, ofType type: String? = nil) throws -> Data {

        var fileType = type

        if type == nil {
            fileType = "json"
        }

        let bundle = Bundle(for: root)

        guard let indexBundlePath = bundle.path(forResource: "index", ofType: "bundle") else {
            throw ResourceControlError.indexBundleNotFoundError
        }

        guard let indexBundle = Bundle(path: indexBundlePath) else {
            throw ResourceControlError.indexBundleNotFoundError
        }

        guard let resultPath = indexBundle.path(forResource: path, ofType: fileType) else {
            throw ResourceControlError.resourceNotFoundError
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: resultPath), options: .mappedIfSafe)

            return data

        } catch {
            fatalError()
        }

        return Data()
    }
}

enum ResourceControlError: Error {
    case resourceNotFoundError
    case indexBundleNotFoundError
}

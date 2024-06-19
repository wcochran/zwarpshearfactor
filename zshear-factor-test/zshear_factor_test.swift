//
//  zshear_factor_test.swift
//  zshear-factor-test
//
//  Created by Wayne Cochran on 6/19/24.
//

import XCTest
import simd
@testable import zshear_factor

class zshear_factor_test: XCTestCase {
    static func verifySVD(a : Float, b : Float, c : Float, svd : SVDFactors) -> Bool {
        let A = simd_float3x3(rows: [
            simd_float3(1, 0, a),
            simd_float3(0, 1, b),
            simd_float3(0, 0, c)
        ])
        let A_ = svd.U * svd.S * simd_transpose(svd.V)
        return simd_almost_equal_elements(A, A_, 0.0001)
    }

    func testzWarpShearFactor() {
        let testValues : [Float] = [0, -1, +1, 10, -10, 1.23, -1.23]
        for a in testValues {
            for b in testValues {
                for c in testValues {
                    let SVD = zWarpShearFactor(a: a, b: b, c: c)
                    XCTAssertTrue(Self.verifySVD(a: a, b: b, c: c,
                                                 svd: SVD),
                                  "zWarpShearFactor(\(a),\(b),\(c) FAIL")
                }
            }
        }
    }

}

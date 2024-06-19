//
//  zShearFactor.swift
//  zshear-factor
//
//  Created by Wayne Cochran on 6/17/24.
//

import Foundation
import simd

struct SVDFactors {
    let U : simd_float3x3
    let S : simd_float3x3
    let V : simd_float3x3
}

//
// Singular Value Decomposition (SVD) of matrix of the following form
//        _     _
//   A = | 1 0 a |, c > 0
//       | 0 1 b |
//       | 0 0 c |
//        -     -
// A is decomposed into a rotation U, (non-uniform) scale S, and rotation V^T
//    A = U S V^T
// U may contain a reflection if c < a.
// Math details at:
// https://tinyurl.com/3z4mm44c
//
func zWarpShearFactor(a : Float, b : Float, c : Float) -> SVDFactors {
    let m = a*a + b*b

    if m < Float.leastNonzeroMagnitude { // A is a diagonal matrix
        let I = matrix_identity_float3x3
        let S = simd_float3x3(rows: [
            simd_float3(1, 0, 0),
            simd_float3(0, 1, 0),
            simd_float3(0, 0, c)
        ])
        return (SVDFactors(U: I, S: S, V: I))
    }

    let s = m + c*c + 1
    let q = sqrt(s*s - 4*c*c)
    let lambda = simd_float3((s + q)/2, 1, (s - q)/2)
    let sigma = simd_float3(sqrt((s + q)/2),1,sqrt((s - q)/2))
    let S = simd_diagonal_matrix(sigma)
    let e0 = simd_normalize(simd_float3(a, b, lambda.x-1))
    let e1 = simd_normalize(simd_float3(-b, a, 0))
    let e2 = simd_normalize(simd_float3(a, b, lambda.z-1))
    let V_ = simd_float3x3(e0, e1, e2)
    let V = simd_determinant(V_) >= 0 ? V_ : simd_float3x3(e0, e1, -e2)
    let A = simd_float3x3(rows: [
        simd_float3(1, 0, a),
        simd_float3(0, 1, b),
        simd_float3(0, 0, c)
    ])
    let U : simd_float3x3
    if abs(sigma.z) >= Float.leastNonzeroMagnitude { // c != 0
        U = A*V*simd_inverse(S)
    } else {  // c == 0
        let e0 = simd_normalize(1/sigma.x * simd_float3(V[0,0] + a*V[0,2],
                                                        V[0,1] + b*V[0,2],
                                                        0))
        let e1 = simd_normalize(1/sigma.y * simd_float3(V[1,0] + a*V[1,2],
                                                        V[1,1] + b*V[1,2],
                                                        0))
        let e2 = simd_float3(0,0,1)
        U = simd_float3x3(e0, e1, e2)
    }
    return SVDFactors(U: U, S: S, V: V)
}

//func verifySVD(a : Float, b : Float, c : Float, svd : SVDFactors) -> Bool {
//    let A = simd_float3x3(rows: [
//        simd_float3(1, 0, a),
//        simd_float3(0, 1, b),
//        simd_float3(0, 0, c)
//    ])
//    let SVD = zWarpShearFactor(a: a, b: b, c: c)
//    let A_ = SVD.U * SVD.S * simd_transpose(SVD.V)
//    return simd_almost_equal_elements(A, A_, 0.0001)
//}

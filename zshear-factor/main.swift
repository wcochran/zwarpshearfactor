//
//  main.swift
//  zshear-factor
//
//  Created by Wayne Cochran on 6/17/24.
//

import Foundation
import simd

let a : Float = 1 // 2
let b : Float = -4 // 3
let c : Float = 0// 4

let SVD = zWarpShearFactor(a: a, b: b, c: c)
print("U=\n\(SVD.U)")
print("S=\n\(SVD.S)")
print("V=\n\(SVD.V)")

let A = simd_float3x3(rows: [
    simd_float3(1, 0, a),
    simd_float3(0, 1, b),
    simd_float3(0, 0, c)
])

let A_ = SVD.U * SVD.S * simd_transpose(SVD.V)
print("A=\n\(A)")
print("A_=\n\(A_)")

//var pass = 0, count = 0
//for i in -3 ... 3 {
//    for j in -3 ... 3 {
//        for k in -3 ... 3 {
//            let a = Float(i)
//            let b = Float(j)
//            let c = Float(k)
//            let SVD = zWarpShearFactor(a: a, b: b, c: c)
//            if !verifySVD(a: a, b: b, c: c, svd: SVD) {
//                print("fail a=\(a), b=\(b), c=\(c)")
//            } else {
//                pass += 1
//            }
//            count += 1
//        }
//    }
//}
//
//print("pass = \(pass) / \(count)")

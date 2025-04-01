////
////  main.swift
////  preview
////
////  Created by 박신영 on 3/18/25.
////
//
//import Foundation
//
//
////Y = 29초 이내 10, 30초 이상 20
////M = 59초 이내 15, 60초 이상 30
//let callCount = Int(readLine()!)!
//let input = readLine()!.split(separator: " ").map{Int(String($0))!}
//var yResult = 0
//var mResult = 0
//
//for i in input {
//    if i % 30 == 0 {
//        yResult += i/30 * 20
//    } else {
//        yResult += i/30 * 20 + 10
//    }
//    
//    if i % 60 == 0 {
//        mResult += i/60 * 30
//    } else {
//        mResult += i/60 * 30 + 15
//    }
//}
//
//
//if yResult < mResult {
//    print("Y \(yResult)")
//} else if mResult < yResult {
//    print("M \(mResult)")
//} else {
//    print("Y M \(yResult)")
//}

boj_10808()

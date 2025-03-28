//
//  두 수의 합.swift
//  preview
//
//  Created by 박신영 on 3/28/25.
//

//어째서 런타임 에러가..1
func 두수의합() {
    let n = Int(readLine()!)!
    let arr = readLine()!.split(separator: " ").map { Int($0)! }
    let x = Int(readLine()!)!
    
    var vis: [Bool] = .init(repeating: false, count: 2000000 + 2)
    var answer = 0
    
    for element in arr {
        vis[x - element] = true
    }
    
    for element in arr {
        
        if element < x && vis[x - element] { answer += 1 }
    }
    print(answer/2)
}

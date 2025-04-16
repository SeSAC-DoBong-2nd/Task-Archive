//
//  해커의수열퍼즐.swift
//  preview
//
//  Created by 박신영 on 4/14/25.
//

import Foundation

func 해커의수열퍼즐() {
    var a = [0, 1, 2, 3, 4, 19]
    
    for i in 6...30 {
        let k = 2*(a[i-1]) + 3*(a[i-2]) - a[i-3] + 4*(a[i-4])
        a.append(k)
    }
    print(a[30])
}

//
//  공포의369.swift
//  preview
//
//  Created by 박신영 on 4/14/25.
//

import Foundation

func 공포의369() {
    var cnt = 0
    for i in 1...10_000_000 {
        let t = String(i).filter { $0 == "3" || $0 == "6" || $0 == "9" }.count
        cnt += t
    }
    print(cnt)
}

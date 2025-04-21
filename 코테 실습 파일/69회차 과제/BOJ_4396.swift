//
//  BOJ_4396.swift
//  preview
//
//  Created by 박신영 on 4/21/25.
//

///델타탐색을 잘 다루지 못해 풀이 실패하고, 답안을 보며 이해하였습니다..

import Foundation

func boj_4396() {
    //그리드 크기 읽기
    let n = Int(readLine()!)!
    
    //지뢰 그리드 읽기
    var mine_grid: [[Character]] = []
    for _ in 0..<n {
        let row = Array(readLine()!)
        mine_grid.append(row)
    }
    
    //클릭 그리드 읽기
    var clicked_grid: [[Character]] = []
    for _ in 0..<n {
        let row = Array(readLine()!)
        clicked_grid.append(row)
    }
    
    //지뢰가 클릭되었는지 확인
    var mine_clicked = false
    for i in 0..<n {
        for j in 0..<n {
            if clicked_grid[i][j] == Character("x") && mine_grid[i][j] == Character("*") {
                mine_clicked = true
                break
            }
        }
        if mine_clicked { break }
    }
    
    //인접 지뢰 개수를 세는 함수
    func countMines(_ i: Int, _ j: Int) -> Int {
        var count = 0
        for di in -1...1 {
            for dj in -1...1 {
                if di == 0 && dj == 0 { continue } //자기 자신은 제외
                let ni = i + di
                let nj = j + dj
                if ni >= 0 && ni < n && nj >= 0 && nj < n { //그리드 경계 내
                    if mine_grid[ni][nj] == Character("*") {
                        count += 1
                    }
                }
            }
        }
        return count
    }
    
    //출력 그리드 초기화
    var output: [[Character]] = Array(repeating: Array(repeating: Character("."), count: n), count: n)
    
    //출력 그리드 생성
    if mine_clicked {
        for i in 0..<n {
            for j in 0..<n {
                if mine_grid[i][j] == Character("*") {
                    output[i][j] = Character("*")
                } else if clicked_grid[i][j] == Character("x") {
                    let num = countMines(i, j)
                    output[i][j] = Character(String(num))
                }
            }
        }
    } else {
        for i in 0..<n {
            for j in 0..<n {
                if clicked_grid[i][j] == Character("x") {
                    let num = countMines(i, j)
                    output[i][j] = Character(String(num))
                }
            }
        }
    }
    
    //출력
    for row in output {
        print(String(row))
    }
}

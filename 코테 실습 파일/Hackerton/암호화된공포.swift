//
//  암호화된공포.swift
//  preview
//
//  Created by 박신영 on 4/14/25.
//

import Foundation

//SINI
func 암호화된공포() {
    let encrypted = "JQLWKJLI#H#JQRGG#WRQ#HWLKZ#WRQ#DKDK#HPDQ#WDF#QDUE#VL#UHZVQD#HKW#KXK#NFDOE#HPDQ#WDF#QDUE#VL#UHZVQD#HKW#DKDK".uppercased().reversed()
    
    var blankStr = ""
    for char in String(encrypted) {
        if char == "#" {
            blankStr += " "
        } else {
            blankStr += String(char)
        }
    }
    
    var result = ""
    for char in blankStr {
        if char == " " {
            result += " "
        } else {
            // ASCII 값을 활용해 3칸 앞으로 이동
            let ascii = Int(char.asciiValue!) //A=65, Z=90
            var newAscii = ascii - 3
            if newAscii < 65 { //A(65)보다 작아지면 Z(90)쪽으로 순환
                newAscii += 26
            }
            result += String(UnicodeScalar(newAscii)!)
        }
    }
    
    print(result)
}

//
//  단어마법사.swift
//  preview
//
//  Created by 박신영 on 4/14/25.
//

import Foundation

func 단어마법사() {
    let str = "dufjqnswoaldlTdmtlwygpgpanswpduftlaglaksemfrhdlTtmqslekgggdlanswpakwcnrhdjffmsekdmaanswpfhsjadjrktlwyekdmaanswprkdufjqnsemfdmfrlekflrhdlTtmqslekdlrjfthsdmfhvntlsmsqnsdmsdjqtdmtlrpTwy".lowercased()
    var aeiouCnt = 0
    var result = 0
    
    for (index,char) in str.enumerated() {
        var k = char.asciiValue.map { Int($0) - 96 } ?? 0
        k += index
        result += k
        
        if ["a", "e", "i", "o", "u"].contains(char) {
            aeiouCnt += 1
        }
        
    }
    result = result * str.count
    result += aeiouCnt
    
    print(result)
    
}

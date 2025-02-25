//
//  NaverSearchViewModel.swift
//  DailyTask_week4
//
//  Created by 박신영 on 2/6/25.
//

import Foundation

final class NaverSearchViewModel {
    
    let inputSearchText: Observable<String?> = Observable("")
    
    let outputIsValidSearchText: Observable<Bool> = Observable(false)
    let outputNavtitle: Observable<String> = Observable("psy의 쇼핑쇼핑")
    
    init() {
        bindViewModel()
    }
    
    private func bindViewModel() {
        inputSearchText.lazyBind { [weak self] text in
            guard let self else {return}
            self.isValidSearchText(text: text)
        }
    }
    
}

private extension NaverSearchViewModel {
    
    func isValidSearchText(text: String?) {
        guard let text = text?.trimmingCharacters(in: .whitespaces) else {
            print("searchBarSearchButtonClicked error")
            return
        }
        switch text.count < 2 {
        case true:
            outputIsValidSearchText.value = false
        case false:
            outputIsValidSearchText.value = true
        }
    }
    
}

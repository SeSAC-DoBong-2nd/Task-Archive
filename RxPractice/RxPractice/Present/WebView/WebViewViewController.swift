//
//  WebViewViewController.swift
//  RxPractice
//
//  Created by 박신영 on 2/27/25.
//

import UIKit
import WebKit

import SnapKit
import Then
import RxCocoa
import RxSwift

final class WebViewViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let request: URLRequest
    private let webView = WKWebView()
    
    init(navTitle: String, request: URLRequest) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.title = navTitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setStyle()
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        loadWebView()
        bind()
    }
    
    func setStyle() {
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                           style: .done,
                                                           target: nil,
                                                           action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"),
                                                            style: .done,
                                                            target: nil,
                                                            action: nil)
    }
    
    func bind() {
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .bind(with: self, onNext: { owner, _ in
                print("rightNavBtnTap")
            }).disposed(by: disposeBag)
    }
    
    private func loadWebView() {
        webView.load(self.request)
    }

}

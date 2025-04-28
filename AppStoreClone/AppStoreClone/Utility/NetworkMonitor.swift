//
//  NetworkMonitor.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/28/25.
//

import Foundation
import Combine
import Network

final class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var timer: AnyCancellable?
    private var pingFailCount = 0
    private let pingFailThreshold = 2
    
    @Published var isConnected: Bool = true

    private init() {
        // 1. NWPathMonitor의 초기 상태 반영
        isConnected = monitor.currentPath.status == .satisfied

        monitor.pathUpdateHandler = { [weak self] path in
//            print("지금 끊겼다!!")
            DispatchQueue.main.async {
//                print("지금 끊겼다!!")
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
        
        // 2. 앱 시작 시 즉시 Ping
        ping()

        // 4. 이후 2초마다 Ping
        timer = Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.ping()
            }
    }
    
    ///ping send
    ///ping 횟수로 첫 네트워크 단절 감지 시간을 줄이고자 하였으나, iOS 내부 재시도 정책 때문에 해결하지 못함..
    //TODO: 위 문제 해결방안 모색
    private func ping() {
//        print(#function, "지금 핑 시작")
        guard let url = URL(string: "https://www.apple.com/library/test/success.html") else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 0.7
        request.cachePolicy = .reloadIgnoringLocalCacheData

        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = false
        let session = URLSession(configuration: config)

        session.dataTask(with: request) { _, response, _ in
            DispatchQueue.main.async {
                if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                    self.pingFailCount = 0
                    self.isConnected = true
                } else {
                    self.pingFailCount += 1
                    if self.pingFailCount >= self.pingFailThreshold {
                        self.isConnected = false
                    }
                }
            }
        }.resume()
    }
} 

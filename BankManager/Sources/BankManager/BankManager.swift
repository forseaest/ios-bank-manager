import Foundation

public struct BankManager {
    private var taskCount: Int = 0
    private var businessHour: Double = 0
   
    public init() {
    }
    
    public func startTask(clientNumber: Int, serviceType: String) {
        print("\(clientNumber)번 고객 \(serviceType)업무 시작")
    }
    
    public mutating func endTask(clientNumber: Int, serviceType: String) {
        print("\(clientNumber)번 고객 \(serviceType)업무 완료")
        taskCount += 1
        if serviceType == "예금" {
            businessHour += 0.7
        }
        if serviceType == "대출" {
            businessHour += 1.1
        }
    }
    
    public func finishTasks() {
        print("업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(taskCount)명이며, 총 업무시간은 \(String(format: "%.1f", businessHour))초입니다.")
    }
    
    func manageBanking() {
        var bank = Bank()
        let randomNumber = Int.random(in: 10...30)
        var randomServiceType: Int
        
        for ticket in 1...randomNumber {
            randomServiceType = Int.random(in: 1...2)
            
            if randomServiceType == 1 {
                bank.clients.enqueue(element: Client(clientNumber: ticket, serviceType: "예금"))
            } else {
                bank.clients.enqueue(element: Client(clientNumber: ticket, serviceType: "대출"))
            }
        }
        
        let group = DispatchGroup()
        let loanSemaphore = DispatchSemaphore(value: 1)
        let depositSemaphore = DispatchSemaphore(value: 2)
        
        while !bank.clients.isEmpty {
            guard let info = bank.clients.dequeue() else {
                return
            }
            
            let currentService: DispatchWorkItem
            
            switch info.serviceType {
            case "대출":
                currentService = DispatchWorkItem {
                    loanSemaphore.wait()
                    bank.manager.startTask(clientNumber: info.clientNumber , serviceType: info.serviceType)
                    Thread.sleep(forTimeInterval: 1.1)
                    bank.manager.endTask(clientNumber: info.clientNumber , serviceType: info.serviceType)
                    loanSemaphore.signal()
                }
            default :
                currentService = DispatchWorkItem {
                    depositSemaphore.wait()
                    bank.manager.startTask(clientNumber: info.clientNumber, serviceType: info.serviceType)
                    Thread.sleep(forTimeInterval: 0.7)
                    bank.manager.endTask(clientNumber: info.clientNumber , serviceType: info.serviceType)
                    depositSemaphore.signal()
                }
            }
            DispatchQueue.global().async(group: group, execute: currentService)
        }
        group.wait()
        bank.manager.finishTasks()
    }
}

import Foundation

public class BankManager {
    private var taskCount: Int = 0
    private var businessHour: TimeInterval = 0
    public var clients = BankQueue<Client>()
    
    public init() {
    }
    
    public func initRecord() {
        taskCount = 0
        businessHour = 0
    }
    
    public func startTask(clientNumber: Int, serviceType: ServiceType) {
        print("\(clientNumber)번 고객 \(serviceType.koreanName) 업무 시작")
    }
    
    public func endTask(clientNumber: Int, serviceType: ServiceType) {
        print("\(clientNumber)번 고객 \(serviceType.koreanName) 업무 완료")
        taskCount += 1
        if serviceType == .deposit {
            businessHour += 0.7
        }
        if serviceType == .loan {
            businessHour += 1.1
        }
    }
    
    public func finishTasks() {
        print("업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(taskCount)명이며, 총 업무시간은 \(String(format: "%.2f", businessHour))초입니다.")
    }
    
    func manageBanking() {
        initRecord()
        
        let startBusinessTime = Date()
        let randomNumber = Int.random(in: 10...30)
        var randomServiceType: Int
        
        for ticket in 1...randomNumber {
            randomServiceType = Int.random(in: 1...2)
            
            if randomServiceType == 1 {
                clients.enqueue(element: Client(clientNumber: ticket, serviceType: .deposit))
            } else {
                clients.enqueue(element: Client(clientNumber: ticket, serviceType: .loan))
            }
        }
        
        let group = DispatchGroup()
        let loanSemaphore = DispatchSemaphore(value: 1)
        let depositSemaphore = DispatchSemaphore(value: 2)
        
        while !clients.isEmpty {
            guard let info = clients.dequeue() else {
                return
            }
            
            let currentService: DispatchWorkItem
            
            switch info.serviceType {
            case .loan:
                currentService = DispatchWorkItem {
                    loanSemaphore.wait()
                    self.startTask(clientNumber: info.clientNumber, serviceType: info.serviceType)
                    Thread.sleep(forTimeInterval: 1.1)
                    self.endTask(clientNumber: info.clientNumber, serviceType: info.serviceType)
                    loanSemaphore.signal()
                }
            default :
                currentService = DispatchWorkItem {
                    depositSemaphore.wait()
                    self.startTask(clientNumber: info.clientNumber, serviceType: info.serviceType)
                    Thread.sleep(forTimeInterval: 0.7)
                    self.endTask(clientNumber: info.clientNumber, serviceType: info.serviceType)
                    depositSemaphore.signal()
                }
            }
            DispatchQueue.global().async(group: group, execute: currentService)
        }
        group.wait()
        
        businessHour = Date().timeIntervalSince(startBusinessTime)
        self.finishTasks()
    }
}

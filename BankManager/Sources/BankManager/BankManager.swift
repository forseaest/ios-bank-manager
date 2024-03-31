import Foundation

public class BankManager {
    private var taskCount: Int = 0
    private var businessHour: TimeInterval = 0
    public var clients = BankQueue<Client>()
    
    public init() {
    }
    
    private func initRecord() {
        taskCount = 0
        businessHour = 0
    }
    
    private func startTask(clientNumber: Int, serviceType: ServiceType) {
        print("\(clientNumber)번 고객 \(serviceType.koreanName) 업무 시작")
    }
    
    private func endTask(clientNumber: Int, serviceType: ServiceType) {
        print("\(clientNumber)번 고객 \(serviceType.koreanName) 업무 완료")
        taskCount += 1
        if serviceType == .deposit {
            businessHour += 0.7
        }
        if serviceType == .loan {
            businessHour += 1.1
        }
    }
    
    private func finishTasks() {
        print("업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(taskCount)명이며, 총 업무시간은 \(String(format: "%.2f", businessHour))초입니다.")
    }
    
    private func generateClients() {
        for clientNumber in 1...Int.random(in: 10...30) {
            guard let serviceType = ServiceType.allCases.randomElement() else {
                continue
            }
            clients.enqueue(element: Client(clientNumber: clientNumber, serviceType: serviceType))
        }
    }
    
    func manageBanking() {
        initRecord()
        generateClients()
        
        let startBusinessTime = Date()
        
        let group = DispatchGroup()
        let loanSemaphore = DispatchSemaphore(value: 1)
        let depositSemaphore = DispatchSemaphore(value: 2)
        
        while !clients.isEmpty {
            guard let info = clients.dequeue() else {
                return
            }
            
            let currentService: DispatchWorkItem
            
            switch info.serviceType {
            case .deposit:
                currentService = performBankService(info: info, semaphore: depositSemaphore)
            case .loan:
                currentService = performBankService(info: info, semaphore: loanSemaphore)
            }
            
            DispatchQueue.global().async(group: group, execute: currentService)
        }
    
        group.wait()
        
        businessHour = Date().timeIntervalSince(startBusinessTime)
        self.finishTasks()
    }
    
    func performBankService(info: Client, semaphore: DispatchSemaphore) -> DispatchWorkItem {
        return DispatchWorkItem {
            semaphore.wait()
            
            self.startTask(clientNumber: info.clientNumber, serviceType: info.serviceType)
            Thread.sleep(forTimeInterval: info.serviceType.processTime)
            self.endTask(clientNumber: info.clientNumber, serviceType: info.serviceType)
            
            semaphore.signal()
        }
    }
}

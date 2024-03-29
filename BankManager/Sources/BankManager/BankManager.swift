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
    
    public init() {
        
    }
}

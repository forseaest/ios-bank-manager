//
//  Bank.swift
//  BankManagerConsoleApp
//
//  Created by Gama, Gray on 2024/03/22.
//

import Foundation

public struct Bank {
    public var manager = BankManager()
    
    public init() {
    }
    
    public mutating func run() {
        printMenu()
        
        do {
            try inputMenu()
        } catch InputError.nilInput {
            print("nil을 입력 받았습니다.")
        } catch InputError.exceptionalInput {
            print("1, 2 외의 입력을 받았습니다.")
        } catch {
            print("알 수 없는 에러가 발생했습니다.")
        }
    }

    mutating func inputMenu() throws {
        let input = readLine()
      
        switch input {
        case "1":
            manager.manageBanking()
            run()
        case "2":
            finishBanking()
        case .none:
            throw InputError.nilInput
        default:
            throw InputError.exceptionalInput
        }
    }

    func printMenu() {
        print("1 : 은행 개점\n2 : 종료")
        print("입력 : ", terminator: "")
    }

    func finishBanking() {
        print("프로그램을 종료합니다.")
    }
}

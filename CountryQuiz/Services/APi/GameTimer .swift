//
//  GameTimer .swift
//  CountryQuiz
//
//  Created by iOS Developer on 29/10/25.
//

import Foundation

@MainActor
protocol GameTimeDelegate: AnyObject{
    func timerDidUpdate(timeRemaining: Int)
    func timerDidfinish()
}

@MainActor
final class GameTimer{
    
    //MARK: - Properties
    private var timerTask: Task<Void, Never>?
    @Published private var timeRemaining: Int = 0 
    
    weak var delegate: GameTimeDelegate?
    
    func startTimer(seconds: Int){
        timerTask?.cancel()
        timeRemaining = seconds
        
        delegate?.timerDidUpdate(timeRemaining: timeRemaining)
        
        timerTask = Task{ [weak self] in
            guard let self else { return }
            
            while !Task.isCancelled{
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if Task.isCancelled { return }
                
                self.timeRemaining -= 1
                self.delegate?.timerDidUpdate(timeRemaining: self.timeRemaining)
                
                if self.timeRemaining <= 0{
                    self.delegate?.timerDidfinish()
                    self.timerTask?.cancel()
                    return
                }
            }
        }
    }
    
    func cancel(){
        timerTask?.cancel()
    }
    
    
    deinit {
        timerTask?.cancel()
    }
}

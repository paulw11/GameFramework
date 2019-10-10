//
//  Game.swift
//  QuizzleTV
//
//  Created by Paul Wilkinson on 24/12/18.
//  Copyright © 2018 Paul Wilkinson. All rights reserved.
//

import Foundation
import Combine

public final class Game: ObservableObject {
    
    public let gameCode: String = {
        return String(Int.random(in: 1000...9999))
    }()
	
	
	public let provider: GameProvider
    public let difficulty: Difficulty?
    public let category: GameCategory?
	public let duration: Int?
	
    @Published
	public private (set) var questions: [Question]?
	@Published
	public private (set) var status: GameStatus
    
	public init(provider: GameProvider, duration: Int, difficulty: Difficulty?, category: GameCategory?) {
		self.provider = provider
        self.duration = duration
        self.difficulty = difficulty
        self.category = category
		self.status = .initialised
		let _ = provider.questionPublisher.sink(receiveCompletion: { (completion) in
			switch completion {
			case .finished:
				self.status = .ready
			case .failure:
				self.status = .failed
			}
		}, receiveValue: { (questions) in
			self.questions = questions
		})
	}
	
	public func start() {
		guard self.status == .ready else {
			fatalError("Attempt to start game that is not ready")
		}
		self.status = .inProgress
	}
	
	public func gameOver() {
		guard self.status == .inProgress else {
			fatalError("Attempt to end game that is not inProgress")
		}
		self.status = .over
	}
    
   /* public func fetchQuestions(from provider: GameProvider) {
        provider.getQuestions(for: self) { (questions, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            self.questions = questions
            print("questions \(questions!)")
        }
    }*/
    
}


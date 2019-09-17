//
//  Game.swift
//  QuizzleTV
//
//  Created by Paul Wilkinson on 24/12/18.
//  Copyright © 2018 Paul Wilkinson. All rights reserved.
//

import Foundation

public final class Game {
    
    public let gameCode: String = {
        return String(Int.random(in: 1000...9999))
    }()

    public let difficulty: Difficulty?
    public let category: GameCategory?
    public private (set) var questions: [Question]?
    
    public let gameSize: Int
    
    public init(gameSize: Int, difficulty: Difficulty?, category: GameCategory?) {
        self.gameSize = gameSize
        self.difficulty = difficulty
        self.category = category
    }
    
    public func fetchQuestions(from provider: GameProvider) {
        provider.getQuestions(for: self) { (questions, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            self.questions = questions
            print("questions \(questions!)")
        }
    }
    
}


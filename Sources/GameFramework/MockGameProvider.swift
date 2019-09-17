//
//  File.swift
//  
//
//  Created by Paul Wilkinson on 17/9/19.
//

import Foundation
import Combine

struct MockGameCategory: GameCategory {
	var id: Int
	var name: String
}

struct MockQuestion: Question {
	var question: String
	
	var category: String
	
	var type: QuestionType
	
	var difficulty: Difficulty
	
	var answers: [String]
	
	var correctAnswerIndex: Int
	
	
}

class MockGameProvider: GameProvider {
	var categoryPublisher: AnyPublisher<[GameCategory], Error> {
		return Just<[GameCategory]>([MockGameCategory(id:1, name:"History"),MockGameCategory(id:2, name:"TV"), MockGameCategory(id:3,name:"Music")]).setFailureType(to: Error.self).eraseToAnyPublisher()
	}
	
	var questionPublisher: AnyPublisher<[Question],Error> {
		
		let question1 = MockQuestion(question: "John, Paul, George and Ringo were members of which band?", category: "Music", type: .multipleChoice, difficulty: .easy, answers: ["The Beatles","The Rolling Stones","The Trogs","The Doors"], correctAnswerIndex: 0)
		
		let question2 = MockQuestion(question: "Dr Spock appeared in Star Trek", category: "TV", type: .boolean, difficulty: .medium, answers: ["True","False"], correctAnswerIndex: 1)
		
		return Just([question1,question2]).setFailureType(to: Error.self).eraseToAnyPublisher()
	}
	
	
	var difficulties: [Difficulty] {
		return [Difficulty(rawValue: "any")!,Difficulty(rawValue: "easy")!, Difficulty(rawValue: "medium")!, Difficulty(rawValue: "hard")!]
	}
	
	var durations: [Int] {
		return [1,2]
	}
	
	
}

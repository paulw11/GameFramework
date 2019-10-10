//
//  File.swift
//  
//
//  Created by Paul Wilkinson on 17/9/19.
//

import Foundation
import Combine

struct MockGameCategory: GameCategory, Hashable {
	var id: Int
	var name: String
}

struct MockQuestion: Question {
	
	var id: String
	
	var question: String
	
	var category: String
	
	var type: QuestionType
	
	var difficulty: Difficulty
	
	var answers: [String]
	
	var correctAnswerIndex: Int
	
}

class MockGameProvider: GameProvider {
	
	var categoryPublisher: AnyPublisher<[GameCategory],GameFrameworkError> {
		return Just<[GameCategory]>(self.mockCategories).setFailureType(to: GameFrameworkError.self).eraseToAnyPublisher()
	}
	
	var questionPublisher: AnyPublisher<[Question],GameFrameworkError> {
		
		guard let duration = self.duration, let _ = self.difficulty, let category = self.category else {
			return Fail(outputType: [Question].self, failure: GameFrameworkError.gameParametersRequired).eraseToAnyPublisher()
		}
		
		if let questions = self.mockQuestions[category as! MockGameCategory] {
			let trimmedQuestions = Array(questions.prefix(duration))
			return Just(trimmedQuestions).setFailureType(to: GameFrameworkError.self).eraseToAnyPublisher()
		} else {
			return Fail(outputType: [Question].self, failure: GameFrameworkError.noQuestionsAvailable).eraseToAnyPublisher()
		}
	}
	
	
	var difficulties: [Difficulty] {
		return [Difficulty(rawValue: "any")!,Difficulty(rawValue: "easy")!, Difficulty(rawValue: "medium")!, Difficulty(rawValue: "hard")!]
	}
	
	var durations: [Int] {
		return [1,2]
	}
	
	var duration: Int?
	
	var difficulty: Difficulty?
	
	var category: GameCategory?
	
	private var mockCategories: [MockGameCategory]
	
	private var mockQuestions: [MockGameCategory:[MockQuestion]]
	
	init() {
		self.mockCategories = [MockGameCategory(id:1, name:"Music"),MockGameCategory(id:2, name:"TV")]
		
		self.mockQuestions = [self.mockCategories[0]:[
			MockQuestion(id:"1",question: "John, Paul, George and Ringo were members of which band?", category: "Music", type: .multipleChoice, difficulty: .easy, answers: ["The Beatles","The Rolling Stones","The Trogs","The Doors"], correctAnswerIndex: 0),
			MockQuestion(id:"2",question: "Madonna's real name is Mary-Sue?", category: "Music", type: .boolean, difficulty: .easy, answers: ["True","False"], correctAnswerIndex: 1)
			],
							  self.mockCategories[1]:[
								MockQuestion(id:"3",question: "Dr Spock appeared in Star Trek", category: "TV", type: .boolean, difficulty: .medium, answers: ["True","False"], correctAnswerIndex: 1),
								MockQuestion(id:"4",question: "The main character in The X-Files is _____ Mulder", category: "TV", type: .multipleChoice, difficulty: .medium, answers: ["Wolf","Tiger","Fox","Bob"], correctAnswerIndex: 2)
		]]
		
	}
	
	
}

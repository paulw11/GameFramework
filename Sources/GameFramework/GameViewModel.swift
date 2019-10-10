//
//  File.swift
//  
//
//  Created by Paul Wilkinson on 18/9/19.
//
import Combine
import Foundation


class GameViewModel: ObservableObject {
	
	@Published
	public private (set) var players = [Player]()
	
	@Published
	public private (set) var question = "" {
		didSet {
			self.answeredPlayers.removeAll()
		}
	}
	
	@Published
	public private (set) var answers = [String]()
	
	@Published
	public private (set) var answeredPlayers = Set<Player>()
	
	public func clearPlayers() {
		self.players.removeAll()
	}
	
	public func addPlayer(_ player: Player) {
		self.players.append(player)
	}
	
	public func setQuestion(_ questionText: String) {
		self.question = questionText
		self.answeredPlayers.removeAll()
	}
	
	public func setAnswers(_ answers: [String]) {
		self.answers = answers
	}
	
	public func recordAnswer(for player: Player) {
		self.answeredPlayers.insert(player)
	}
}

//
//  ViewController.swift
//  Project_7_8_9_Combine
//
//  Created by Subhrajyoti Chakraborty on 05/07/20.
//  Copyright © 2020 Subhrajyoti Chakraborty. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var hint: String = ""
    var letter: Character = "a"
    var word: String = ""
    var displayWord: String = ""
    var dataSet = [String]()
    var currentGameLevel: Int = 0
    var usedLetters = [String]()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var wrongAnswerCount = 0 {
        didSet {
            wrongLabel.text = "Wrong: \(wrongAnswerCount)"
        }
    }
    
    var displayLabel: UILabel!
    var wrongLabel: UILabel!
    var scoreLabel: UILabel!
    var hintLabel: UILabel!
    var lettersButtons = [UIButton]()
    let lettersArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white
        
        wrongLabel = UILabel()
        wrongLabel.translatesAutoresizingMaskIntoConstraints = false
        wrongLabel.text = "Wrong: \(wrongAnswerCount)"
        view.addSubview(wrongLabel)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score: \(score)"
        view.addSubview(scoreLabel)
        
        displayLabel = UILabel()
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.text = ""
        displayLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        view.addSubview(displayLabel)
        
        hintLabel = UILabel()
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.text = "Hint: "
        hintLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(hintLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        
        NSLayoutConstraint.activate([
            wrongLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            wrongLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 0),
            
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            
            displayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hintLabel.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: 40),
            
            buttonsView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: 180),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 40),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let letterWidth = 53
        let letterHeight = 40
        
        for row in 0...3 {
            for col in 0...6 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                letterButton.setTitle(" ", for: .normal)
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor(ciColor: .red).cgColor
                
                let frame = CGRect(x: col * letterWidth, y: row * letterHeight, width: letterWidth, height: letterHeight)
                
                letterButton.frame = frame
                letterButton.isHidden = true
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                buttonsView.addSubview(letterButton)
                
                lettersButtons.append(letterButton)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
    }
    
    func loadData() {
        if let levelFileUrl = Bundle.main.url(forResource: "level", withExtension: "txt") {
            if let levelContent = try? String(contentsOf: levelFileUrl) {
                var lines = levelContent.components(separatedBy: "\n")
                lines = lines.dropLast()
                lines.shuffle()
                
                for i in 0..<lettersArray.count {
                    lettersButtons[i].setTitle(lettersArray[i], for: .normal)
                    lettersButtons[i].isHidden = false
                }
                
                dataSet = lines
                loadWordToGuess()
            }
        }
    }
    
    func loadWordToGuess() {
        if currentGameLevel < dataSet.count {
            let parts = dataSet[currentGameLevel].components(separatedBy: ":")
            
            word = parts[0]
            hint = parts[1]
            
            print(word)
            print(hint)
            
            hintLabel.text = "Hint: \(hint)"
            generateBlanks(count: word.count)
        } else {
            let ac = UIAlertController(title: "Reload Game", message: "please reload the game", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Reload", style: .default, handler: reload))
            present(ac, animated: true)
        }
    }
    
    func generateBlanks(count: Int) {
        for _ in 0..<count {
            displayWord += "? "
        }
        
        displayLabel.text = displayWord
        print(displayWord)
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        sender.isEnabled = false
        if let letter = sender.titleLabel?.text {
            print(letter)
            
            if word.contains(letter) {
                score += 1
            } else {
                score -= 1
                wrongAnswerCount += 1
            }
            
            if wrongAnswerCount == 7 {
                let ac = UIAlertController(title: "Gave Over", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: reload))
                present(ac, animated: true)
                return
            }
            
            displayModifiedString(usedLetter: letter)
        }
    }
    
    func displayModifiedString(usedLetter: String) {
        var displayedWord = ""
        usedLetters.append(usedLetter)
        
        for letter in word {
            let letterStr = String(letter)
            
            if usedLetters.contains(letterStr) {
                displayedWord += letterStr + " "
            } else {
                displayedWord += "? "
            }
        }
        
        displayLabel.text = displayedWord
        next()
        
    }
    
    func next() {
        if let text = displayLabel.text {
            if text.contains("?") {
                return
            }
            
            resetData(fromNext: true)
            loadWordToGuess()
        }
    }
    
    func reload(action: UIAlertAction) {
        resetData(fromNext: false)
        self.loadData()
    }
    
    func resetData(fromNext: Bool) {
        if fromNext {
            currentGameLevel += 1
        } else {
            currentGameLevel = 0
            score = 0
        }
        wrongAnswerCount = 0
        displayWord = ""
        usedLetters = [String]()
        
        for button in lettersButtons {
            button.isEnabled = true
        }
    }
}


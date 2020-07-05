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
    
    var displayLabel: UILabel!
    var hintLabel: UILabel!
    var lettersButtons = [UIButton]()
    let lettersArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    override func loadView() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        print(screenSize.width)
        
        view = UIView()
        view.backgroundColor = .white
        
        displayLabel = UILabel()
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.text = ""
        displayLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        displayLabel.backgroundColor = .lightGray
        view.addSubview(displayLabel)
        
        hintLabel = UILabel()
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.text = "Hint: "
        hintLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(hintLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.backgroundColor = .green
        view.addSubview(buttonsView)
        
        
        NSLayoutConstraint.activate([
            displayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //            displayLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            
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
        if currentGameLevel <= dataSet.count {
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
        print(sender.titleLabel?.text)
    }
    
    func displayModifiedString() {
        //
    }
    
    func next() {
        currentGameLevel += 1
    }
    
    func reload(action: UIAlertAction) {
        self.loadData()
    }
    
    
}


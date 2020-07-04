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
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
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
        
        
        NSLayoutConstraint.activate([
            displayLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            displayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hintLabel.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: 40)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
    }
    
    func loadData() {
        if let levelFileUrl = Bundle.main.url(forResource: "level", withExtension: "txt") {
            if let levelContent = try? String(contentsOf: levelFileUrl) {
                var lines = levelContent.components(separatedBy: "\n")
                lines.shuffle()
                
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


//
//  ViewController.swift
//  CatchTheKenny
//
//  Created by Hüsnü Taş on 7.01.2022.
//

import UIKit

typealias alertBlock = ((UIAlertAction) -> Void)

class ViewController: UIViewController {
    
    private var timer: Timer!
    private var timerHide: Timer!
    private var time = 10
    private var score = 0
    private var highscore = 0
    
    private var maxX: Int!
    private var maxY: Int!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var kennyImageView: UIImageView!
    @IBOutlet weak var kennyX: NSLayoutConstraint!
    @IBOutlet weak var kennyY: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maxX = Int(containerView.bounds.width)/2
        maxY = Int(containerView.bounds.height)/2
        kennyImageView.isUserInteractionEnabled = true
        kennyImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: .tapKenny))
        
        if let storedHighscore = UserDefaults.standard.object(forKey: "highscore") as? Int {
            highscore = storedHighscore
            highscoreLabel.text = "Highscore: \(highscore)"
        }
        
        startTimer()
    }
    
    private func startTimer() {
        time = 10
        timeLabel.text = "\(time)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: .countDown, userInfo: nil, repeats: true)
        timerHide = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: .hideKenny, userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func countDown() {
        if time > 0 {
            time -= 1
            timeLabel.text = "\(time)"
        } else {
            endGame()
        }
    }
    
    @objc fileprivate func hideKenny() {
        let randomX = Int.random(in: -maxX...maxX)
        let randomY = Int.random(in: -maxY...maxY)
        
        kennyX.constant = CGFloat(randomX)
        kennyY.constant = CGFloat(randomY)
    }
    
    @objc fileprivate func tapKenny() {
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    private func endGame() {
        kennyImageView.isHidden = true
        timer.invalidate()
        timerHide.invalidate()
        makeAlert()
        checkHighscore()
    }
    
    private func makeAlert() {
        let alert = UIAlertController(title: "Game Over", message: "Play Again?", preferredStyle: .alert)
        let closeButton = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        let againButton = UIAlertAction(title: "Again", style: .default, handler: playAgain)
        alert.addAction(closeButton)
        alert.addAction(againButton)
        present(alert, animated: true, completion: nil)
    }
    
    private func resetGame() {
        kennyImageView.isHidden = false
        score = 0
        scoreLabel.text = "Score: \(score)"
        startTimer()
    }
    
    private func checkHighscore() {
        if score > highscore {
            highscore = score
            highscoreLabel.text = "Highscore: \(highscore)"
            UserDefaults.standard.set(highscore, forKey: "highscore")
        }
    }
    
    private lazy var playAgain: alertBlock = { [weak self] action in
        self?.resetGame()
    }
    
}

fileprivate extension Selector {
    static let countDown = #selector(ViewController.countDown)
    static let hideKenny = #selector(ViewController.hideKenny)
    static let tapKenny = #selector(ViewController.tapKenny)
}


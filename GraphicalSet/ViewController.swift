//
//  ViewController.swift
//  GraphicalSet
//
//  Created by Sebastian Pfeufer on 02/05/2021.
//

import UIKit

class ViewController: UIViewController {
    
//MARK: - Set-up of outlets and supporting variables
    @IBOutlet weak var cardContainerView: CardContainerView! {
        didSet {
            let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            swipeGestureRecognizer.direction = .down
            cardContainerView.addGestureRecognizer(swipeGestureRecognizer)
            let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation))
            cardContainerView.addGestureRecognizer(rotationGestureRecognizer)
            
        }
    }
    @IBOutlet weak var setsCount: UILabel!
    @IBOutlet weak var scoreCount: UILabel!
    @IBOutlet weak var dealButton: UIButton!
    
    lazy var setGame = SetGame()
    var visibleCards = 12
    var cardDict = [CardView: Card]()
    var endLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 100))
    
//MARK: - Loading visible cards after starting app
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setGame.newGame(initialNumberOfCards: visibleCards)
        updateViewFromModel()
    }
    
//MARK: - Implementation of actions caused by user
    // actions caused when player clicks on dealButton
    @IBAction func dealPressed(_ sender: UIButton) {
        setGame.addPlayingCards()
        updateViewFromModel()
    }
    
    // actions caused when player clicks on New Game
    @IBAction func newGamePressed(_ sender: UIButton) {
        visibleCards = 12
        setGame.newGame(initialNumberOfCards: visibleCards)
        updateViewFromModel()
        view.backgroundColor = UIColor.lightGray
        endLabel.removeFromSuperview()
        cardContainerView.isHidden = false
        setsCount.isHidden = false
        scoreCount.isHidden = false
        dealButton.isHidden = false
        cardContainerView.setNeedsLayout()
    }
    
    // actions caused when player swipes from top to bottom
    @objc func handleSwipe() {
        setGame.addPlayingCards()
        updateViewFromModel()
    }
    
    // actions caused when player rotates
    @objc func handleRotation() {
        setGame.shufflePlayingCards()
        updateViewFromModel()
    }
    
    // actions caused when player clicks on a symbol
    @objc func handleCardTap(_ recognizer: UITapGestureRecognizer) {
        if let cardView = recognizer.view as? CardView {
            if let cardViewIndex = cardContainerView.cardViews.firstIndex(of: cardView) {
                setGame.addToSelectedCards(selectedCardIndex: cardViewIndex)
                updateViewFromModel()
            }
        }
    }
    
//MARK: - Supporting functions
    private func updateViewFromModel() {
        cardContainerView.removeCards()
        cardDict.removeAll()
        
        // each card to be displayed is translated into its corresponding view
        for card in setGame.playingCards {
            let cardView = CardView()
            switch card.feature1 {
                case .v1: cardView.cardSymbolAmount = CardView.CardSymbolAmount.one
                case .v2: cardView.cardSymbolAmount = CardView.CardSymbolAmount.two
                case .v3: cardView.cardSymbolAmount = CardView.CardSymbolAmount.three
            }
            switch card.feature2 {
                case .v1: cardView.cardSymbolShape = CardView.CardSymbolShape.oval
                case .v2: cardView.cardSymbolShape = CardView.CardSymbolShape.diamond
                case .v3: cardView.cardSymbolShape = CardView.CardSymbolShape.squiggle
            }
            switch card.feature3 {
                case .v1: cardView.cardSymbolColor = CardView.CardSymbolColor.red
                case .v2: cardView.cardSymbolColor = CardView.CardSymbolColor.green
                case .v3: cardView.cardSymbolColor = CardView.CardSymbolColor.blue
            }
            switch card.feature4 {
                case .v1: cardView.cardSymbolShading = CardView.CardSymbolShading.solid
                case .v2: cardView.cardSymbolShading = CardView.CardSymbolShading.outlined
                case .v3: cardView.cardSymbolShading = CardView.CardSymbolShading.striped
            }
            
            // highlighting selected cards
            if setGame.selectedCards.contains(card) {
                cardView.layer.borderWidth = 3.0
                cardView.layer.borderColor = UIColor.yellow.cgColor
                
                // highlighting matched cards
                if setGame.matchedCards.contains(card) {
                    cardView.layer.borderWidth = 3.0
                    cardView.layer.borderColor = UIColor.green.cgColor
                }
            }
            
            // each symbol is added to an array containing all symbols to be displayed - a dictionairy keeps track of which card corresponds to which (sub)view
            cardContainerView.cardViews.append(cardView)
            cardDict[cardView] = card
        }
        
        // a timer ensures that the user sees the matched cards highlighted for a while before continuing
        if setGame.matchedCards.count == 3 {
            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { _ in
                self.setGame.addPlayingCards()
                self.updateViewFromModel()
            }
        }
        
        // each created view is equipped with a tap gesture recognizer
        if cardContainerView.cardViews.count > 0 {
            for i in 0...cardContainerView.cardViews.count-1 {
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(_:)))
                cardContainerView.cardViews[i].addGestureRecognizer(tapGestureRecognizer)
            }
        }
        
        // updating score label and sets label
        scoreCount.text = "Score: \(setGame.score)"
        setsCount.text = "Sets: \(setGame.numberOfSets)"
        
        // If the user manages to find every possible set, the user interface will notify him/her accordingly
        if setGame.numberOfSets == (setGame.cardDeck.count / 3) {
            cardContainerView.removeCards()
            cardDict.removeAll()
            cardContainerView.isHidden = true
            setsCount.isHidden = true
            scoreCount.isHidden = true
            dealButton.isHidden = true
            view.backgroundColor = UIColor.green
            endLabel.center = CGPoint(x: view.center.x, y: view.center.y)
            endLabel.textAlignment = .center
            endLabel.textColor = UIColor.black
            endLabel.numberOfLines = .max
            endLabel.text = "Congratulations! You've found all \(setGame.numberOfSets) sets! Your score is \(setGame.score)!"
            view.addSubview(endLabel)
        }
    }
}

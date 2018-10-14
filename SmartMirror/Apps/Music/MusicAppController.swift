//
//  MusicAppController.swift
//  SmartMirror
//
//  Created by Rob Stokes on 12/10/2018.
//  Copyright © 2018 Rob Stokes. All rights reserved.
//

import Cocoa

final class Cell: NSCollectionViewItem {
    
    var card: MagicCard?
    var art: NSImageView?
    var artist: NSTextField?
    var album: NSTextField?
    
    var index: Int?
    
    override func loadView() {
        self.view = MagicCardView()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.layer?.cornerRadius = 10
        
        art = NSImageView(frame: NSMakeRect(0, 100, 205, 205))
        self.view.addSubview(art!)
        
        artist = NSTextField(frame: NSMakeRect(10, 50, 185, 30))
        artist!.alignment = NSTextAlignment.center
        artist!.font = NSFont(name: "Helvetica Neue Bold", size: 14)
        artist!.isBordered = false
        self.view.addSubview(artist!)
        
        album = NSTextField(frame: NSMakeRect(10, 20, 185, 30))
        album!.alignment = NSTextAlignment.center
        album!.font = NSFont(name: "Helvetica Neue Thin", size: 12)
        album!.isBordered = false
        album!.usesSingleLineMode = false
        album!.maximumNumberOfLines = 2
        album!.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.view.addSubview(album!)
    }
    
    public func setCard(card: MagicCard) {
        self.card = card
        let url = URL(string: card.artUrl!)
        
        art!.imageScaling = NSImageScaling.scaleAxesIndependently
        
        art!.sd_setImage(with: url) { (image, err, cach, url) in
            self.art!.image = image
        }
        
        artist?.stringValue = (self.card?.artist)!
        album?.stringValue = (self.card?.title)!
        
        let view = self.view as! MagicCardView
        view.index = self.index
    }
}

class MusicAppController: BaseAppController, NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    @IBOutlet var collectionView: NSCollectionView?
    
    var cards: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        let layout = NSCollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.itemSize = NSMakeSize(205, 305)
        
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
        self.collectionView!.register(NSCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MyCell"))
        self.collectionView!.collectionViewLayout = layout
        self.collectionView!.allowsMultipleSelection = false
        self.collectionView!.backgroundColors = [.clear]
        
        
        self.collectionView!.register(
            Cell.self,
            forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Cell")
        )
        
        DataManager.sharedInstance.getMagicCards(success: { (array) in
            self.cards = array
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }) {
            
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.cards != nil) {
            return (self.cards?.count)!
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(
            withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Cell"),
            for: indexPath
            ) as! Cell
        
        cell.index = indexPath.item
        cell.setCard(card: (self.cards?.object(at: indexPath.item) as? MagicCard)!)
        
        let tapGesture = NSClickGestureRecognizer(target: self, action:#selector(self.tapHandler(sender:)))
        cell.view.addGestureRecognizer(tapGesture)
        
        
        return cell
    }
    
    @objc func tapHandler(sender: NSClickGestureRecognizer) {
        let view = sender.view as! MagicCardView
        let index = view.index
        
        let card = self.cards?.object(at: index!) as! MagicCard
        
        DataManager.sharedInstance.playMagicCard(card: card , success: { (str) in
            
        }) {
            
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        
        return NSSize(
            width: 200,
            height: 200
        )
    }
}

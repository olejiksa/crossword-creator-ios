//
//  SpotlightService.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 30/07/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import CoreSpotlight
import MobileCoreServices

final class SpotlightService {
    
    private let searchableIndex = CSSearchableIndex.default()
    
    func setupSpotlight(with crosswords: [Crossword], domainID: String) {
        var searchableItems = [CSSearchableItem]()
        searchableIndex.deleteSearchableItems(withDomainIdentifiers: [domainID], completionHandler: nil)
        
        crosswords.forEach {
            let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            searchableItemAttributeSet.title = $0.name
            
            let date = $0.updatedOn ?? $0.createdOn ?? Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            
            var contentDescription = $0.isTermsList ? "Dictionary" : "Crossword"
            contentDescription += ", " + dateFormatter.string(from: date)
            
            searchableItemAttributeSet.contentDescription = contentDescription
            
            let searchableItem = CSSearchableItem(uniqueIdentifier: "com.olejiksa.crosswordCreator.\($0.id)",
                domainIdentifier: domainID,
                attributeSet: searchableItemAttributeSet)
            
            searchableItems.append(searchableItem)
        }
        
        searchableIndex.indexSearchableItems(searchableItems)
    }
}

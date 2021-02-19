//
//  AboutPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 02.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit
import Toolkit

final class AboutPresenter: NSObject {
    
    let dataSource = SectionDataSource()
    weak var viewController: AboutViewController?
    
    private let developerURL = URL(string: "itms-apps://apps.apple.com/developer/id1460125465")
    
    override init() {
        super.init()
        setupSections()
    }
}

// MARK: - Private

private extension AboutPresenter {
    
    func setupSections() {
        dataSource.setup([Section(items: [RightDetailItem(title: "developer".localized,
                                                          subtitle: "oleg_samoylov".localized,
                                                          actionBlock: allApps,
                                                          hasDisclosureIndicator: true,
                                                          isEnabled: areAllAppsAvailable),
                                          RightDetailItem(title: "edition".localized,
                                                          subtitle: "Crossword Creator Lite"),
                                          RightDetailItem(title: "version".localized,
                                                          subtitle: "1.1.1")])])
    }
    
    func allApps(item: ItemProtocol) {
        guard let url = developerURL, UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    var areAllAppsAvailable: Bool {
        #if DEBUG
        return false
        #else
        return developerURL.map(UIApplication.shared.canOpenURL) ?? false
        #endif
    }
}

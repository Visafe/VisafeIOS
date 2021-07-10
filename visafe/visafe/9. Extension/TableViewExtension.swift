//
//  TableViewExtension.swift
//  EConversation
//
//  Created by Cuong Nguyen on 9/21/19.
//  Copyright © 2019 EConversation. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh

extension UITableView {
    func registerCells(cells: [String]) {
        for name in cells {
            let nib = UINib(nibName: name, bundle: nil)
            register(nib, forCellReuseIdentifier: name)
        }
    }
}

extension UITableView {
    
    func addPullToRefresh(_ block: @escaping MJRefreshComponentAction) -> Void {
        let header = MJRefreshNormalHeader(refreshingBlock: block)
        header.arrowView?.image = nil
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
        
        self.mj_header = header
    }
    
    func addLoadmore(canLoadMore flag: Bool, block: @escaping MJRefreshComponentAction) {
        if flag {
            if self.mj_footer == nil {
                let footer = MJRefreshAutoNormalFooter(refreshingBlock: block)
                footer.isRefreshingTitleHidden = true
                
                self.mj_footer = footer
            }
        } else {
            if let _ = self.mj_footer {
                self.mj_footer = nil
            }
        }
    }
    
    func endRefreshing() {
        if let header = self.mj_header {
            header.endRefreshing()
        }
        if let footer = self.mj_footer {
            footer.endRefreshing()
        }
    }
    
}

extension UICollectionView {
    func registerCells(cells: [String]) {
        for name in cells {
            let nib = UINib(nibName: name, bundle: nil)
            register(nib, forCellWithReuseIdentifier: name)
        }
    }
}

extension UICollectionView {
    
    func addPullToRefresh(_ block: @escaping MJRefreshComponentAction) -> Void {
        let header = MJRefreshNormalHeader(refreshingBlock: block)
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
        
        self.mj_header = header
    }
    
    func addLoadmore(canLoadMore flag: Bool, block: @escaping MJRefreshComponentAction) {
        if flag {
            if self.mj_footer == nil {
                let footer = MJRefreshAutoNormalFooter(refreshingBlock: block)
                footer.isRefreshingTitleHidden = true
                
                self.mj_footer = footer
            }
        } else {
            if let _ = self.mj_footer {
                self.mj_footer = nil
            }
        }
    }
    
    func endRefreshing() {
        if let header = self.mj_header {
            header.endRefreshing()
        }
        if let footer = self.mj_footer {
            footer.endRefreshing()
        }
    }
    
}

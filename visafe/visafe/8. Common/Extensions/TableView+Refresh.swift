//
//  TableView+Refresh.swift
//  Pexels
//
//  Created by quangpc on 6/6/17.
//  Copyright © 2017 quangpc. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh

extension UITableView {
    
    func addPullToRefresh(_ block: @escaping MJRefreshComponentRefreshingBlock) -> Void {
        let header = MJRefreshNormalHeader(refreshingBlock: block)
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
        
        self.mj_header = header
    }
    
    func addLoadmore(canLoadMore flag: Bool, block: @escaping MJRefreshComponentRefreshingBlock) {
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
    
    func addPullToRefresh(_ block: @escaping MJRefreshComponentRefreshingBlock) -> Void {
        let header = MJRefreshNormalHeader(refreshingBlock: block)
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
    
        self.mj_header = header
    }
    
    func addLoadmore(canLoadMore flag: Bool, block: @escaping MJRefreshComponentRefreshingBlock) {
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

//
//  MentionDisplayView.swift
//  Tagging
//
//  Created by Hung NV on 9/23/19.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

class MentionDisplayView: UIView {

    private let tableView = UITableView()
    
    private let heightCell: CGFloat = 40
    
    var didSelectItem:((String,Int)->Void)?
    
    var padding : CGFloat = 16
    
    var paddingTop : CGFloat = 8
    
    var datas: [String] = []{
        didSet{
            tableView.reloadData()
            layoutSubviews()
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bounds = CGRect(x: padding, y: 0, width: bounds.width - 2 * padding, height: CGFloat(datas.count) * heightCell)
        tableView.frame = bounds
        updateGradient()
    }
    
    func setupGradient() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 5
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1 / UIScreen.main.scale
        clipsToBounds = true
//        layer.shadowOpacity
    }
    
    func updateGradient() {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 5)
        layer.shadowPath = path.cgPath
    }
    
    func show(inView: UIView, fromView: UIView) {
        removeFromSuperview()
        inView.addSubview(self)
        let convertFrame = fromView.superview!.convert(fromView.frame, to: inView)
        frame = CGRect(x: convertFrame.origin.x, y: convertFrame.origin.y + convertFrame.height + paddingTop, width: convertFrame.width, height: frame.height)
    }
}

extension MentionDisplayView: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = datas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectItem?(datas[indexPath.row],indexPath.row)
    }
    
}

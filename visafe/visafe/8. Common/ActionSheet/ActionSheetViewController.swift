//
//  ActionSheetViewController.swift
//  TripTracker
//
//  Created by Hung NV on 5/15/19.
//  Copyright © 2019 triptracker. All rights reserved.
//

import UIKit
//import FittedSheets
class ActionSheetItem: NSObject {
    var imageName: String?
    var title:String?
    var titleColor:UIColor?
    init(imageName:String? = nil, title:String? = nil, titleColor:UIColor? = UIColor.black) {
        self.imageName = imageName
        self.title = title
        self.titleColor = titleColor
    }
}

class ActionSheetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var listItems:[ActionSheetItem]!
    var didSelectedItem:((_ item: ActionSheetItem)->Void)?
    init(listItems:[ActionSheetItem]) {
        self.listItems = listItems
        super.init(nibName: "ActionSheetViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }
    func setupTableView() {
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let item = listItems[indexPath.row]
        if let imageName = item.imageName,let image = UIImage(named: imageName){
            cell.imageView?.image = image
            cell.textLabel?.textAlignment = NSTextAlignment.left
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        }else{
            cell.textLabel?.textAlignment = NSTextAlignment.center
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        }
        
        cell.textLabel?.text = item.title
        cell.textLabel?.textColor = item.titleColor
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectedItem?(listItems[indexPath.row])
    }
}

extension UIViewController{
    func showActionSheet(items:[ActionSheetItem],didSelectedItem:@escaping ((_ item: ActionSheetItem)->Void)){
        if items.count == 0{
            return
        }
        let controller = ActionSheetViewController(listItems: items)
        
        let heightController = min(50 * (CGFloat)(items.count) + 50, CGFloat(UIScreen.main.bounds.size.height - 50))
        let sizes = [SheetSize.fixed(heightController)]
        let sheetController = SheetViewController(controller: controller, sizes: sizes)
        controller.didSelectedItem = {(item) in
            sheetController.dismiss(animated: false, completion: {
                didSelectedItem(item)
            })
        }
        sheetController.adjustForBottomSafeArea = true
        sheetController.blurBottomSafeArea = true
        sheetController.dismissOnBackgroundTap = true
        sheetController.extendBackgroundBehindHandle = true
        sheetController.topCornersRadius = 15
        
        sheetController.willDismiss = { _ in
            print("Will dismiss \(0)")
        }
        sheetController.didDismiss = { _ in
            print("Will dismiss \(1)")
        }
        
        self.present(sheetController, animated: false, completion: nil)
    }
    
    func presentSheetViewController(_ viewController: UIViewController,sizes:[SheetSize] = [SheetSize.fullScreen],overlayColor:UIColor = AppColor.lightBlue) {
        let controller = UINavigationController(rootViewController: viewController)
        let sheetController = SheetViewController(controller: controller, sizes: sizes)
        sheetController.adjustForBottomSafeArea = true
        sheetController.blurBottomSafeArea = true
        sheetController.dismissOnBackgroundTap = true
        sheetController.extendBackgroundBehindHandle = true
        sheetController.topCornersRadius = 15
        sheetController.overlayColor = overlayColor
        sheetController.handleColor = "707070".toColor()
        sheetController.handleTopEdgeInset = 0
        sheetController.handleBottomEdgeInset = 9
        sheetController.willDismiss = { _ in
            print("Will dismiss \(0)")
        }
        sheetController.didDismiss = { _ in
            print("Will dismiss \(1)")
        }
//        self.navigationController?.pushViewController(sheetController, animated: false)
        self.present(sheetController, animated: false, completion: nil)
    }
}

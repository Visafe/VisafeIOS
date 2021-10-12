//
//  GroupListDeviceVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/24/21.
//

import UIKit

class GroupListDeviceVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextfield: BaseTextField!
    
    var group: GroupModel
    var listDevice: [DeviceGroupModel] = []
    var listDeviceSearch: [DeviceGroupModel] = []
    var onUpdate:(() -> Void)?
    
    init(group: GroupModel) {
        self.group = group
        listDevice = group.devicesGroupInfo
        listDeviceSearch = group.devicesGroupInfo
        super.init(nibName: GroupListDeviceVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quản lý thiết bị"
        tableView.registerCells(cells: [GroupDeviceCell.className])
        searchTextfield.setState(type: .active)
        tableView.reloadData()
    }
    
    @IBAction func valueChanged(_ sender: UITextField) {
        let text = sender.text?.lowercased() ?? ""
        listDeviceSearch = listDevice.filter({ (device) -> Bool in
            if text.isEmpty { return true }
            if device.deviceName?.lowercased().contains(text) == true {
                return true
            }
            return false
        })
        tableView.reloadData()
    }
}

extension GroupListDeviceVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            return listDeviceSearch.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupDeviceCell.className) as? GroupDeviceCell else {
            return UITableViewCell()
        }
        let device = listDeviceSearch[indexPath.row]
        cell.binding(device: device)
        cell.moreAction = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.showMoreAction(device: device)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let view = BaseAddView.loadFromNib() else { return UIView() }
            view.bindingInfo(type: .device)
            view.addAction = { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.addDevice()
            }
            return view
        } else {
            if listDeviceSearch.count == 0 { return UIView() }
            let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 48))
            viewHeader.backgroundColor = UIColor.white
            let label = UILabel(frame: CGRect(x: 16, y: 6, width: kScreenWidth - 32, height: 48))
            label.text = "\(listDeviceSearch.count) thiết bị"
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            viewHeader.addSubview(label)
            return viewHeader
        }
    }
    
    func addDevice() {
        let vc = AddDeviceToGroupVC(group: group)
        vc.addDevice = { [weak self] device in
            guard let weakSelf = self else { return }
            weakSelf.listDevice.append(device)
            weakSelf.reloadData()
            weakSelf.onUpdate?()
        }
        present(vc, animated: true)
    }
    
    func showMoreAction(device: DeviceGroupModel) {
        guard let view = MoreActionView.loadFromNib() else { return }
        view.binding(title: device.deviceName ?? "", type: .device)
        view.deleteAction = { [weak self] in
            guard let weakSelf = self else { return }
            Timer.scheduledTimer(timeInterval: 0.3, target: weakSelf, selector:#selector(weakSelf.confirmDeleteDevice(sender:)), userInfo: device, repeats:false)
        }
        view.editAction = { [weak self] in
            guard let weakSelf = self else { return }
            Timer.scheduledTimer(timeInterval: 0.3, target: weakSelf, selector:#selector(weakSelf.editDevice(sender:)), userInfo: device, repeats:false)
        }
        showPopup(view: view)
    }
    
    @objc func confirmDeleteDevice(sender: Timer) {
        guard let devcie = sender.userInfo as? DeviceGroupModel else { return }
        showConfirmDelete(title: "Bạn có chắc chắn muốn xóa thiết bị \(devcie.deviceName ?? "") khỏi nhóm?") { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.deleteDevice(device: devcie)
        }
    }
    
    func deleteDevice(device: DeviceGroupModel) {
        showLoading()
        let param = DeleteDeviceToGroupParam()
        param.groupId = group.groupid
        param.deviceId = device.deviceID
        param.deviceMonitorID = device.deviceMonitorID
        GroupWorker.deleteDevice(param: param) { [weak self] (result, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.listDevice.removeFirst(where: { (d) -> Bool in
                return d.deviceID == device.deviceID
            })
            weakSelf.reloadData()
            weakSelf.onUpdate?()
        }
    }
    
    @objc func editDevice(sender: Timer) {
        guard let device = sender.userInfo as? DeviceGroupModel else { return }
        guard let view = BaseEnterValueView.loadFromNib() else { return }
        view.bindingData(type: .deviceName, name: device.deviceOwner)
        view.enterTextfield.text = device.deviceName
        view.acceptAction = { [weak self] name in
            guard let weakSelf = self else { return }
            device.deviceName = name
            weakSelf.updateNameDevice(device: device)
        }
        showPopup(view: view)
    }
    
    func updateNameDevice(device: DeviceGroupModel) {
        showLoading()
        let param = Common.getDeviceInfo()
        param.deviceId = device.deviceID
        param.deviceName = device.deviceName
        param.deviceOwner = device.deviceOwner
        param.deviceType = device.deviceType?.rawValue
        param.deviceDetail = device.deviceDetail
        GroupWorker.updateDevice(param: param) { [weak self] (result, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.reloadData()
            weakSelf.onUpdate?()
        }
    }
    
    func reloadData() {
        let text = searchTextfield.text ?? ""
        listDeviceSearch = listDevice.filter({ (device) -> Bool in
            if text.isEmpty { return true }
            if device.deviceName?.contains(text) == true {
                return true
            }
            return false
        })
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 72
        } else {
            if listDeviceSearch.count == 0 { return 0.0001 }
            return 48
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}

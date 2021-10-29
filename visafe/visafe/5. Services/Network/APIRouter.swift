//
//  APIRouter.swift
//  TripTracker
//
//  Created by quangpc on 7/18/18.
//  Copyright © 2018 triptracker. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import ObjectMapper

enum APIRouter {
    //authen
    case loginGoogle(token: String?)
    case loginFacebook(token: String?)
    case loginApple(token: String?)
    case login(param: LoginParam)
    case register(param: RegisterParam)
    case forgotPassword(username: String?)
    case resetPassword(param: ResetPassParam)
    case changePassword(param: ChangePassParam)
    case changeProfile(param: UserModel)
    case reactivation
    case profile
    case activeAccount(param: ActiveAccountParam)
    
    //workspace
    case getListWorkspace
    case addWorkspace(param: WorkspaceModel)
    case updateWorkspace(param: WorkspaceModel)
    case deleteWorkspace(wspId: String?)
    case updateNameWorkspace(param: WorkspaceUpdateNameParam)
    
    //group
    case addGroup(param: GroupModel)
    case updateGroup(param: GroupModel)
    case updateNameGroup(param: RenameGroupParam)
    case deleteGroup(groupId: String, fkUserId: Int)
    case addDeviceGroup(param: AddDeviceToGroupParam)
    case updateDeviceGroup(param: AddDeviceToGroupParam)
    case deleteDeviceGroup(param: DeleteDeviceToGroupParam)
    case createIdentifier(name: String, groupId: String)
    case updateIdentifier(name: String, groupId: String)
    case deleteIdentifier(id: String)
    case getIdentifier(id: String)
    case addDeviceToIden(param: AddDeviceToIdentifierParam)
    case deleteDeviceToIden(param: DeleteDeviceToIdentifierParam)
    case inviteToGroup(param: InviteToGroupParam)
    case deleteGroupMember(param: DeleteToGroupParam)
    case changeManagerPermision(param: ChangeManagerPermisionParam)
    case changeViewerPermision(param: ChangeViewerPermisionParam)
    case getGroups(wspId: String)
    case groupUpdateWhitelist(param: GroupUpdateWhitelistParam)
    case groupUserToManager(userId: Int?, groupId: String?)
    case groupUserToViewer(userId: Int?, groupId: String?)
    case groupDeleteUser(userId: Int?, groupId: String?)
    case deleteDeviceFromGroup(param: DeleteDeviceGroupParam)
    case getGroup(id: String)
    
    //notification
    case listNotification(pageIndex: Int)
    case readNotification(id: Int)
    
    //statistic
    case statisticWorkspace(id: String, limit: Int)
    case statisticGroup(id: String, limit: Int)
    case logGroup(param: QueryLogParam)
    case logWorkspace(param: QueryLogParam)
    case deleteLog(group_id: String?, logId: String?)

    //gen device id
    case genDeviceId
    case registerDevice(token: String?, deviceId: String?)
    
    //payment
    case packages
    case order(id: Int)

    //botnet
    case checkBotNet

    // báo cáo web
    case reportPhishing(url: String)
    // check version iOS
    case iosVersion(name: String)
    case checkDevice
    case requestOutGroup(groupId: String)
    case activeVip(key: String)
    case changeUseProfile(param: ChangeProfileParam)

    case routing
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serverLogicError(message: let msg):
            return msg
        default:
            return "There is something wrong with data."
        }
    }
}

extension APIRouter: TargetType {
    var baseURL: URL {
        return URL(string: APIConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .loginFacebook:
            return "/login/facebook"
        case .loginGoogle:
            return "/login/google"
        case .login:
            return "/login"
        case .register:
            return "/register"
        case .forgotPassword:
            return "/forgot-password"
        case .resetPassword:
            return "/reset-password"
        case .changePassword:
            return "/user/change-password"
        case .changeProfile:
            return "/change_profile"
        case .getGroups:
            return "/groups"
        case .reactivation:
            return "/re-activation"
        case .profile:
            return "/user/profile"
        case .activeAccount:
            return "/activate-account"
        case .getListWorkspace:
            return "/workspaces"
        case .addWorkspace:
            return "/workspace/add"
        case .updateWorkspace:
            return "/workspace/update"
        case .deleteWorkspace:
            return "/workspace/delete"
        case .updateNameWorkspace:
            return "/workspace/update/rename"
        case .addGroup:
            return "/group/add"
        case .updateGroup:
            return "/group/update"
        case .updateNameGroup:
            return "/group/update/rename"
        case .deleteGroup:
            return "/group/delete"
        case .addDeviceGroup:
            return "/group/invite/device"
        case .deleteDeviceGroup:
            return "/group/delete/device"
        case .createIdentifier:
            return "/create-identifier"
        case .updateIdentifier:
            return "/update-identifier"
        case .deleteIdentifier:
            return "/del-identifier"
        case .getIdentifier:
            return "/identifiers"
        case .addDeviceToIden:
            return "/add-device-to-identifier"
        case .deleteDeviceToIden:
            return "/del-device-from-identifier"
        case .inviteToGroup:
            return "/group/invite/members"
        case .deleteGroupMember:
            return "/group/delete/members"
        case .changeManagerPermision:
            return "/group/update/user-to-manager"
        case .changeViewerPermision:
            return "/group/update/user-to-viewer"
        case .listNotification:
            return "/user/notifications"
        case .statisticWorkspace:
            return "/stats/workspace"
        case .statisticGroup:
            return "/stats/group"
        case .logGroup:
            return "/querylog_group"
        case .logWorkspace:
            return "/querylog_workspace"
        case .groupUpdateWhitelist:
            return "/group/update/whitelist"
        case .groupUserToManager:
            return "/group/update/user-to-manager"
        case .groupUserToViewer:
            return "/group/update/user-to-viewer"
        case .groupDeleteUser:
            return "/group/delete/member"
        case .deleteLog:
            return "/stats/delete_log"
        case .loginApple:
            return "/login/apple"
        case .deleteDeviceFromGroup:
            return "/group/delete/device"
        case .updateDeviceGroup:
            return "/group/update/device"
        case .genDeviceId:
            return "/control/gen-device-id"
        case .getGroup:
            return "/group"
        case .registerDevice:
            return "/device/register"
        case .readNotification:
            return "/user/read-notification"
        case .packages:
            return "/packages"
        case .order:
            return "/order"
        case .checkBotNet:
            return "/ipma"
        case .reportPhishing:
            return "/report_phishing"
        case .iosVersion:
            return "/version/ios"
        case .checkDevice:
            return "/device/check"
        case .requestOutGroup:
            return "/device/request-out-group"
        case .activeVip:
            return "/device/active-vip"
        case .changeUseProfile:
            return "/user/change-profile"
        case .routing:
            return "/routing"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getListWorkspace, .profile, .getGroups, .listNotification,
             .statisticWorkspace, .statisticGroup,
             .logGroup, .logWorkspace, .genDeviceId, .getGroup, .packages,
             .iosVersion, .routing:
            return .get
        case .deleteWorkspace, .deleteGroup,
             .groupDeleteUser, .deleteDeviceFromGroup, .deleteDeviceGroup:
            return .delete
        case .updateWorkspace, .updateNameWorkspace,
             .updateGroup, .updateNameGroup,
             .groupUpdateWhitelist, .groupUserToViewer,
             .groupUserToManager, .updateDeviceGroup, .changePassword, .changeUseProfile:
            return .patch
        default:
            break
        }
        return .post
    }
    
    var parameters: [String: Any] {
        var pars = [String: Any]()
        switch self {
        case .loginGoogle(token: let token):
            pars["token"] = token
        case .loginFacebook(token: let token):
            pars["token"] = token
        case .login(param: let param):
            pars = param.toJSON()
        case .register(param: let param):
            pars = param.toJSON()
        case .forgotPassword(username: let username):
            pars["username"] = username
        case .resetPassword(param: let param):
            pars = param.toJSON()
        case .changePassword(param: let param):
            pars = param.toJSON()
        case .changeProfile(param: let param):
            pars = param.toJSON()
        case .addWorkspace(param: let param):
            pars = param.toJSON()
        case .updateWorkspace(param: let param):
            pars = param.toJSON()
        case .deleteWorkspace(wspId: let id):
            pars["workspaceId"] = id
        case .updateNameWorkspace(param: let param):
            pars = param.toJSON()
        case .addGroup(param: let param):
            pars = param.toJSON()
        case .updateGroup(param: let param):
            pars = param.toJSON()
        case .updateNameGroup(param: let param):
            pars = param.toJSON()
        case .deleteGroup(groupId: let id, fkUserId: let userId):
            pars["groupId"] = id
            pars["fkUserId"] = userId
        case .addDeviceGroup(param: let param):
            pars = param.toJSON()
        case .deleteDeviceGroup(param: let param):
            pars = param.toJSON()
        case .createIdentifier(name: let name, groupId: let groupId):
            pars["groupId"] = groupId
            pars["name"] = name
        case .updateIdentifier(name: let name, groupId: let groupId):
            pars["groupId"] = groupId
            pars["name"] = name
        case .getGroups(wspId: let wspId):
            pars["wsId"] = wspId
        case .deleteIdentifier(id: let id):
            pars["id"] = id
        case .getIdentifier(id: let id):
            pars["id"] = id
        case .addDeviceToIden(param: let param):
            pars = param.toJSON()
        case .deleteDeviceToIden(param: let param):
            pars = param.toJSON()
        case .inviteToGroup(param: let param):
            pars = param.toJSON()
        case .deleteGroupMember(param: let param):
            pars = param.toJSON()
        case .changeManagerPermision(param: let param):
            pars = param.toJSON()
        case .changeViewerPermision(param: let param):
            pars = param.toJSON()
        case .activeAccount(param: let param):
            pars = param.toJSON()
        case .listNotification(pageIndex: let page):
            pars["page"] = page
        case .statisticWorkspace(id: let wspId, limit: let time):
            pars["workspace_id"] = wspId
            pars["time_limit"] = time
        case .statisticGroup(id: let gId, limit: let time):
            pars["group_id"] = gId
            
            pars["time_limit"] = time
        case .logGroup(param: let param):
            pars = param.toJSON()
        case .logWorkspace(param: let param):
            pars = param.toJSON()
        case .groupUpdateWhitelist(param: let param):
            pars = param.toJSON()
        case .groupUserToManager(userId: let userId, groupId: let groupId):
            pars["userId"] = userId
            pars["groupId"] = groupId
        case .groupUserToViewer(userId: let userId, groupId: let groupId):
            pars["userId"] = userId
            pars["groupId"] = groupId
        case .groupDeleteUser(userId: let userId, groupId: let groupId):
            pars["userId"] = userId
            pars["groupId"] = groupId
        case .deleteLog(group_id: let groupId, logId: let logId):
            pars["group_id"] = groupId
            pars["doc_id"] = logId
        case .loginApple(token: let token):
            pars["token"] = token
        case .deleteDeviceFromGroup(param: let param):
            pars = param.toJSON()
        case .updateDeviceGroup(param: let param):
            pars = param.toJSON()
        case .getGroup(id: let groupId):
            pars["groupid"] = groupId
        case .registerDevice(token: let token, deviceId: let deviceId):
            pars["token"] = token
            pars["deviceId"] = deviceId
        case .readNotification(id: let id):
            pars["id"] = id
        case .order(id: let id):
            pars["package_price_time_id"] = id
            pars["device_id"] = CacheManager.shared.getDeviceId()
        case .reportPhishing(url: let url):
            pars["url"] = url
        case .iosVersion(name: let name):
            pars["name"] = name
        case .checkDevice:
            pars["deviceId"] = CacheManager.shared.getDeviceId()
            pars["token"] = CacheManager.shared.getFCMToken()
        case .requestOutGroup(groupId: let groupId):
            pars["device_id"] = CacheManager.shared.getDeviceId()
            pars["group_id"] = groupId
        case .activeVip(key: let key):
            pars["deviceId"] = CacheManager.shared.getDeviceId()
            pars["key"] = key
        case .changeUseProfile(param: let param):
            pars = param.toJSON()
        case .reactivation, .getListWorkspace,
             .profile, .genDeviceId, .checkBotNet,
             .packages, .routing:
            break
        }
        return pars
    }
    
    var task: Task {
        switch self {
        case .register, .login, .resetPassword, .changePassword, .changeProfile, .reactivation, .addWorkspace, .updateWorkspace, .updateNameWorkspace, .addGroup, .updateGroup, .updateNameGroup, .deleteGroup, .addDeviceGroup, .deleteDeviceGroup, .createIdentifier, .updateIdentifier, .deleteIdentifier, .addDeviceToIden, .deleteDeviceToIden,.inviteToGroup, .deleteGroupMember, .changeManagerPermision, .changeViewerPermision, .activeAccount, .deleteWorkspace, .loginFacebook, .loginGoogle, .forgotPassword, .groupUpdateWhitelist, .groupUserToManager, .groupUserToViewer, .groupDeleteUser, .deleteLog, .loginApple, .deleteDeviceFromGroup, .updateDeviceGroup, .registerDevice, .readNotification, .order, .checkBotNet, .reportPhishing, .checkDevice, .requestOutGroup, .activeVip, .changeUseProfile:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        default:
            break
        }
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var headers: [String : String]? {
        var hea: [String: String] = [:]
        switch self {
        case .getListWorkspace, .addWorkspace, .updateWorkspace, .deleteWorkspace, .updateNameWorkspace, .addGroup, .updateGroup, .updateNameGroup, .deleteGroup, .deleteDeviceGroup, .createIdentifier, .updateIdentifier, .deleteIdentifier, .getIdentifier, .addDeviceToIden, .deleteDeviceToIden, .inviteToGroup, .deleteGroupMember, .changeManagerPermision, .changeViewerPermision, .profile, .getGroups, .listNotification, .statisticWorkspace, .statisticGroup, .logGroup, .logWorkspace, .groupUpdateWhitelist, .groupUserToViewer, .groupUserToManager, .groupDeleteUser, .deleteLog, .deleteDeviceFromGroup, .updateDeviceGroup, .getGroup, .readNotification, .packages, .order, .reportPhishing, .changePassword, .checkDevice, .requestOutGroup, .activeVip, .changeUseProfile:
            hea["Authorization"] = (CacheManager.shared.getLoginResult()?.token ?? "")
        default:
            break
        }
        return hea
    }
}

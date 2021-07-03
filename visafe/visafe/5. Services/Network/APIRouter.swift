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
    case login(param: LoginParam)
    case register(param: RegisterParam)
    case forgotPassword(username: String?)
    case resetPassword(param: ResetPassParam)
    case changePassword(param: ChangePassParam)
    case changeProfile(param: UserModel)
    case reactivation
    case profile
    case activeAccount(param: PasswordModel)
    
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
    case deleteDeviceGroup(param: DeleteDeviceToGroupParam)
    case createIdentifier(name: String, groupId: String)
    case updateIdentifier(name: String, groupId: String)
    case deleteIdentifier(id: String)
    case getIdentifier(id: String)
    case addDeviceToIden(param: AddDeviceToIdentifierParam)
    case deleteDeviceToIden(param: DeleteDeviceToIdentifierParam)
    case inviteToGroup(param: InviteToGroupParam)
    case deleteToGroup(param: DeleteToGroupParam)
    case changeManagerPermision(param: ChangeManagerPermisionParam)
    case changeViewerPermision(param: ChangeViewerPermisionParam)
    case getGroups(wspId: String)
}

enum APIError: Error {
    case serverLogicError(message: String)
    case parseError
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

enum APIConstant {
    static let baseURL = "https://staging.visafe.vn/api/v1"
}

extension APIRouter: TargetType {
    var baseURL: URL {
        return URL(string: APIConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .register:
            return "/register"
        case .forgotPassword:
            return "/forgot-password"
        case .resetPassword:
            return "/reset-password"
        case .changePassword:
            return "/change_password"
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
            return "/invite/device"
        case .deleteDeviceGroup:
            return "/device/delete"
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
            return "/invite/send-mail-invite"
        case .deleteToGroup:
            return "/del-user"
        case .changeManagerPermision:
            return "/change-permission-to-manage"
        case .changeViewerPermision:
            return "/change-permission-to-view"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .forgotPassword, .getListWorkspace, .profile, .getGroups:
            return .get
        case .deleteWorkspace, .deleteGroup:
            return .delete
        case .updateWorkspace, .updateNameWorkspace, .updateGroup, .updateNameGroup:
            return .patch
        default:
            break
        }
        return .post
    }
    
    var parameters: [String: Any] {
        var pars = [String: Any]()
        switch self {
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
        case .deleteToGroup(param: let param):
            pars = param.toJSON()
        case .changeManagerPermision(param: let param):
            pars = param.toJSON()
        case .changeViewerPermision(param: let param):
            pars = param.toJSON()
        case .activeAccount(param: let param):
            pars = param.toJSON()
        case .reactivation, .getListWorkspace, .profile:
            break
        }
        return pars
    }
    
    var task: Task {
        switch self {
        case .register, .login, .resetPassword, .changePassword, .changeProfile, .reactivation, .addWorkspace, .updateWorkspace, .updateNameWorkspace, .addGroup, .updateGroup, .updateNameGroup, .deleteGroup, .addDeviceGroup, .deleteDeviceGroup, .createIdentifier, .updateIdentifier, .deleteIdentifier, .addDeviceToIden, .deleteDeviceToIden,.inviteToGroup, .deleteToGroup, .changeManagerPermision, .changeViewerPermision, .activeAccount, .deleteWorkspace:
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
        case .getListWorkspace, .addWorkspace, .updateWorkspace, .deleteWorkspace, .updateNameWorkspace, .addGroup, .updateGroup, .updateNameGroup, .deleteGroup, .addDeviceGroup, .deleteDeviceGroup, .createIdentifier, .updateIdentifier, .deleteIdentifier, .getIdentifier, .addDeviceToIden, .deleteDeviceToIden, .inviteToGroup, .deleteToGroup, .changeManagerPermision, .changeViewerPermision, .profile, .getGroups:
            hea["Authorization"] = (CacheManager.shared.getLoginResult()?.token ?? "")
        default:
            break
        }
        return hea
    }
}

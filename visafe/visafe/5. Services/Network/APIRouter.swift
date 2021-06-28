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
    case forgotPassword(email: String?)
    case resetPassword(param: ResetPassParam)
    case changePassword(param: ChangePassParam)
    case changeProfile(param: UserModel)
    case reactivation
    
    //workspace
    case getListWorkspace
    case addWorkspace(param: WorkspaceModel)
    case updateWorkspace(param: WorkspaceModel)
    case deleteWorkspace(wspId: String?)
    case updateNameWorkspace(param: WorkspaceUpdateNameParam)
    
    //group
    case addGroup(param: GroupModel)
    case updateGroup(param: GroupModel)
    case renameGroup(param: RenameGroupParam)
    case deleteGroup(groupId: String)
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
    static let baseURL = "https://staging.visafe.vn"
}

extension APIRouter: TargetType {
    var baseURL: URL {
        return URL(string: APIConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/control/login"
        case .register:
            return "/control/register"
        case .forgotPassword:
            return "/control/forgot-password"
        case .resetPassword:
            return "/control/reset-password"
        case .changePassword:
            return "/control/change_password"
        case .changeProfile:
            return "/control/change_profile"
        case .reactivation:
            return "/re-activation"
        case .getListWorkspace:
            return "/control/get-workspace"
        case .addWorkspace:
            return "/control/create-workspace"
        case .updateWorkspace:
            return "/control/update-workspace"
        case .deleteWorkspace:
            return "/control/delete-workspace"
        case .updateNameWorkspace:
            return "/update-name-workspace"
        case .addGroup:
            return "/clients/add"
        case .updateGroup:
            return "/clients/update"
        case .renameGroup:
            return "/clients/rename"
        case .deleteGroup:
            return "/clients/delete"
        case .addDeviceGroup:
            return "/control/invite/device"
        case .deleteDeviceGroup:
            return "/control/device/delete"
        case .createIdentifier:
            return "/control/create-identifier"
        case .updateIdentifier:
            return "/control/update-identifier"
        case .deleteIdentifier:
            return "/control/del-identifier"
        case .getIdentifier:
            return "/control/identifiers"
        case .addDeviceToIden:
            return "/control/add-device-to-identifier"
        case .deleteDeviceToIden:
            return "/control/del-device-from-identifier"
        case .inviteToGroup:
            return "/control/invite/send-mail-invite"
        case .deleteToGroup:
            return "/control/del-user"
        case .changeManagerPermision:
            return "/control/change-permission-to-manage"
        case .changeViewerPermision:
            return "/control/change-permission-to-view"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .forgotPassword, .getListWorkspace:
            return .get
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
        case .forgotPassword(email: let email):
            pars["email"] = email
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
        case .renameGroup(param: let param):
            pars = param.toJSON()
        case .deleteGroup(groupId: let id):
            pars["groupId"] = id
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
        case .reactivation, .getListWorkspace:
            break
        }
        return pars
    }
    
    var task: Task {
        switch self {
        case .register, .login, .resetPassword, .changePassword, .changeProfile, .reactivation, .addWorkspace, .updateWorkspace, .updateNameWorkspace, .addGroup, .updateGroup, .renameGroup, .deleteGroup, .addDeviceGroup, .deleteDeviceGroup, .createIdentifier, .updateIdentifier, .deleteIdentifier, .addDeviceToIden, .deleteDeviceToIden,.inviteToGroup, .deleteToGroup, .changeManagerPermision, .changeViewerPermision:
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
        case .getListWorkspace, .addWorkspace, .updateWorkspace, .deleteWorkspace, .updateNameWorkspace, .addGroup, .updateGroup, .renameGroup, .deleteGroup, .addDeviceGroup, .deleteDeviceGroup, .createIdentifier, .updateIdentifier, .deleteIdentifier, .getIdentifier, .addDeviceToIden, .deleteDeviceToIden, .inviteToGroup, .deleteToGroup, .changeManagerPermision, .changeViewerPermision:
            hea["Authorization"] = (CacheManager.shared.getLoginResult()?.token ?? "")
        default:
            break
        }
        return hea
    }
}

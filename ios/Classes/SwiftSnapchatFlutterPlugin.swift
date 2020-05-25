import Flutter
import UIKit
import SCSDKLoginKit

public class SwiftSnapchatFlutterPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "snapchat_flutter_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftSnapchatFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method.elementsEqual("getPlatformVersion") {
            result("iOS " + UIDevice.current.systemVersion)
        }else if call.method.elementsEqual("snap_chat_login"){
            self.openSnapChat(result: result)
        }else if call.method.elementsEqual("snap_chat_logout"){
            self.logout()
            result("logout")
        }else{
            result(FlutterMethodNotImplemented)
        }
    }
   
   func openSnapChat(result: @escaping FlutterResult){
    SCSDKLoginClient.login(from: (UIApplication.shared.keyWindow?.rootViewController.self!) ?? UIViewController(), completion: { success, error in
            if let error = error {
                print(error.localizedDescription)
                result(FlutterError.init(
                    code: "400",
                    message: error.localizedDescription,
                    details: nil))
                return
            }
            if success {
                 DispatchQueue.main.async {
                self.fetchSnapUserInfo(result: result)
            }
        }
    })
}
    
    private func fetchSnapUserInfo(result:@escaping FlutterResult){
        let graphQLQuery = "{me{displayName, bitmoji{avatar}, externalId}},"
        SCSDKLoginClient
            .fetchUserData(
                withQuery: graphQLQuery,
                variables: nil,
                success: { userInfo in
                    if let userInfo = userInfo,
                        let dataValue = try? JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted),
                        let _ = try? JSONDecoder().decode(UserEntity.self, from: dataValue) {
                        DispatchQueue.main.async {
                            var hashKey = [String:Any]()
                            if let data = userInfo["data"] as? [String:Any]{
                                if let me_data = data["me"] as? [String:Any]{
                                    hashKey["fullName"] = me_data["displayName"]
                                    hashKey["_id"] = me_data["externalId"]
                                    if let bitmoji_Data = me_data["bitmoji"] as? [String:Any]{
                                        if let avatar = bitmoji_Data["avatar"]{
                                            hashKey["avatar"] = avatar
                                        }
                                    }
                                }
                            }
                            result(hashKey)
                        }
                    }
            }) { (error, isUserLoggedOut) in
                result(FlutterError.init(
                    code: "400",
                    message :error?.localizedDescription ?? "",
                    details:nil))
        }
    }
    
    
    private func logout(){
        SCSDKLoginClient.clearToken()
    }
    
}

struct UserEntity {
    let displayName: String?
    let avatar: String?
    let id: String?
    
    private enum CodingKeys: String, CodingKey {
        case data
    }
    
    private enum DataKeys: String, CodingKey {
        case me
    }
    
    private enum MeKeys: String, CodingKey {
        case displayName
        case bitmoji
        case id
    }
    
    private enum BitmojiKeys: String, CodingKey {
        case avatar
    }
}

extension UserEntity: Decodable {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let data = try values.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let me = try data.nestedContainer(keyedBy: MeKeys.self, forKey: .me)
        
        displayName = try? me.decode(String.self, forKey: .displayName)
        id = try? me.decode(String.self, forKey: .id)
        let bitmoji = try me.nestedContainer(keyedBy: BitmojiKeys.self, forKey: .bitmoji)
        avatar = try? bitmoji.decode(String.self, forKey: .avatar)
    }
}

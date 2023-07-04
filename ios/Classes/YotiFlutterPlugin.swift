import Flutter
import UIKit
import YotiSDKCommon
import YotiSDKCore
import YotiSDKDocument
import YotiSDKFaceTec

public class YotiFlutterPlugin: NSObject, FlutterPlugin, YotiSDKDataSource, YotiSDKDelegate  {

  public func navigationController(_ navigationController: YotiSDKCore.YotiSDKNavigationController, didFinishWithResult result: YotiSDKCommon.YotiSDKResult) {
      UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true)
      
      switch result {
          case .success:
              self.flutterResult!(Bool(true))
              break
          case .failure(let error):
          self.flutterResult!(FlutterError(code: String(error.errorCode),
                                            message: String(error.errorCode),
                                                details: nil))
              print(error)
          }
  }
  
  public func sessionID(for navigationController: YotiSDKNavigationController) -> String {
      self.sessionIdString
  }

  public func sessionToken(for navigationController: YotiSDKNavigationController) -> String {
      self.sessionTokenString
  }
  
  public func isReactNativeClient(for navigationController: YotiSDKNavigationController) -> Bool {
      true
  }


  public func supportedModuleTypes(for navigationController: YotiSDKNavigationController) -> [YotiSDKModule.Type] {
      [YotiSDKDocumentModule.self, YotiSDKFaceTecModule.self]
  }
  

  var sessionIdString = "";
  var sessionTokenString = "";
  var flutterResult: FlutterResult?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "yoti_flutter", binaryMessenger: registrar.messenger())
    let instance = YotiFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "startYoti":
      
      let arguments = call.arguments as? [String: Any]
      let sessionId: String = arguments?["sessionId"] as! String;
      let sessionToken: String = arguments?["sessionToken"] as! String;

      self.startYoti(sessionId: sessionId ?? "", sessionToken: sessionToken ?? "", result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func startYoti(sessionId: String, sessionToken: String, result: @escaping FlutterResult) {
      self.sessionIdString = sessionId;
      self.sessionTokenString = sessionToken;
      self.flutterResult = result;
      let navigationController = YotiSDKNavigationController()
      navigationController.sdkDataSource = self
      navigationController.sdkDelegate = self
      //navigationController.with
      
      UIApplication.shared.keyWindow?.rootViewController?.present(
          navigationController, animated: true, completion: nil)
      //navigationController.did
      //self.result = result;

  }

}
//
//  Service.swift
//  Umaass
//
//  Created by Hesam on 7/10/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//


import Foundation
import Alamofire
import SwiftyJSON


struct ServiceAPI {
    
    func fileName(url:URL) -> String {
        return url.lastPathComponent
    }
    static let shared = ServiceAPI()
    
    
    func fetchGenericData<T: Decodable>(urlString: String,parameters:Parameters,methodInput:HTTPMethod,isHeaders:Bool = false , completion: @escaping (T? , Error?,Int?) -> ()) {
        
        var headers:HTTPHeaders? = nil
        if isHeaders {
            headers = [
                "Authorization": "Bearer \(accessToken)",
                "X-Requested-With": "application/json",
              //  "Content-type" : "application/json",
                "Accept" : "application/json"
                
                
            ]
        }
        
        Alamofire.request(urlString, method: methodInput, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success:
                let  jsonDecoder = JSONDecoder()
                guard let data = response.result.value else { completion(nil,nil,response.response?.statusCode); return }
                print(data)
                swiftyJsonVar = JSON(response.result.value)
                print("swiftyJsonvar --------- ",swiftyJsonVar)
                do {
                    let json = try jsonDecoder.decode(T.self, from: data)
                    print(json)
                    completion(json, nil,response.response?.statusCode)
                    
                }catch let error{
                    completion(nil,error,response.response?.statusCode)
                }
            case .failure(let error):
                completion(nil,error,response.response?.statusCode)
            }
        }
    }
    
    // --------------------------------- upload file -------------------------------------
    
    func uploadFile<T: Decodable>(apiUrl: String, urlLocal: URL, parameters:Parameters ,completion: @escaping (Result<T>) -> ()) {
        
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-type": "multipart/form-data"
        ]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            multipartFormData.append(urlLocal, withName: "image", fileName: self.fileName(url: urlLocal), mimeType: URL.mimeType(urlLocal)())
        }, usingThreshold: UInt64.init(), to: apiUrl, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                    //self.uploadStrem.onNext(("progress",Progress.fractionCompleted))
                })
                upload.response { response in
                    let statusCode = response.response?.statusCode
                    let  jsonDecoder = JSONDecoder()
                    guard let data = response.data else { return }
                    do {
                        if statusCode == 200 {
                            let json = try jsonDecoder.decode(T.self, from: data)
                            completion(.success(json, statusCode))
                        }else {
                            completion(.failure(response.error,statusCode,"try again"))
                            print("error service ",statusCode ?? 0)
                        }
                    }catch let error{
                        print(error.localizedDescription)
                        completion(.failure(error,statusCode,"try again"))
                    }
                }
            case .failure( let error):
                print("Error in upload: \(error.localizedDescription)")
                completion(.failure(error,500,"try again"))
            }
        }
    }
    
    // --------------------------------- upload file -------------------------------------
    
    func uploadAvatar<T: Decodable>(apiUrl: String, urlLocal: URL, parameters:Parameters ,completion: @escaping (Result<T>) -> ()) {
        
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-type": "multipart/form-data"
        ]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            multipartFormData.append(urlLocal, withName: "avatar", fileName: self.fileName(url: urlLocal), mimeType: URL.mimeType(urlLocal)())
        }, usingThreshold: UInt64.init(), to: apiUrl, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                    //self.uploadStrem.onNext(("progress",Progress.fractionCompleted))
                })
                upload.response { response in
                    let statusCode = response.response?.statusCode
                    let  jsonDecoder = JSONDecoder()
                    guard let data = response.data else { return }
                    do {
                        if statusCode == 200 {
                            let json = try jsonDecoder.decode(T.self, from: data)
                            completion(.success(json, statusCode))
                        }else {
                            completion(.failure(response.error,statusCode,"try again"))
                            print("error service ",statusCode ?? 0)
                        }
                    }catch let error{
                        print(error.localizedDescription)
                        completion(.failure(error,statusCode,"try again"))
                    }
                }
            case .failure( let error):
                print("Error in upload: \(error.localizedDescription)")
                completion(.failure(error,500,"try again"))
            }
        }
    }
}




var swiftyJsonVar = JSON()

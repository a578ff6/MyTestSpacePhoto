//
//  PhotoInfoController.swift
//  MyTestSpacePhoto
//
//  Created by 曹家瑋 on 2023/10/31.
//

import Foundation
import UIKit

// MARK: -  Swift 5.5 的 async/await


class PhotoInfoController {
    
    // 定義一個自訂的錯誤類型，用於處理與照片資訊相關的錯誤
    enum PhotoInfoError: Error, LocalizedError {
        case itemNotfound           // 找不到項目時的錯誤
        case imgaeDataMissing       // 照片數據缺失時的錯誤
    }
    
    // 這個函數現在是異步的，並且當一切順利時返回一個PhotoInfo對象。
    func fetchPhotoInfo() async throws -> PhotoInfo {
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
        urlComponents.queryItems = [
            "api_key": "DEMO_KEY"
        ].map({ URLQueryItem(name: $0.key, value: $0.value) })
        
        // 進行異步的網路請求，取得資料和回應
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        // 確認回應的狀態碼是200（表示成功），否則拋出錯誤
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PhotoInfoError.itemNotfound
        }
        
        // 解碼獲得的JSON資料，然後回傳解碼後的PhotoInfo物件
        let jsonDecoder = JSONDecoder()
        let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
        return(photoInfo)
        
    }
    
    // 使用異步函數從指定URL取得照片
    func fetchImage(from url: URL) async throws -> UIImage {
        
        // 透過修改 URLComponents 的 scheme 屬性來將網址從 HTTP 改為 HTTPS。
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.scheme = "https"
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // 確認回應的狀態碼是200（表示成功），否則拋出錯誤
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PhotoInfoError.imgaeDataMissing
        }
        
        // 從獲取的數據中建立UIImage物件
        guard let image = UIImage(data: data) else {
            throw PhotoInfoError.imgaeDataMissing
        }
        
        return image
    }
}




// MARK: - dataTask


/*
class PhotoInfoController {
    
    // 定義一個自訂的錯誤類型，用於處理與照片資訊相關的錯誤
    enum PhotoInfoError: Error, LocalizedError {
        case itemNotfound           // 找不到項目時的錯誤
        case imgaeDataMissing       // 照片數據缺失時的錯誤
        case invalidURL             // 錯誤的URL
    }
    
    // 當資料取得成功或失敗時，都會透過completion回調通知呼叫者
    func fetchPhotoInfo(completion: @escaping (Result<PhotoInfo, Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
        urlComponents.queryItems = [
            "api_key": "DEMO_KEY"
        ].map({ URLQueryItem(name: $0.key, value: $0.value)})
        
        // 使用URLSession的dataTask方法來進行網路請求
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
            // 如果有任何網路錯誤，直接通知呼叫者
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // 檢查回應的資料和狀態碼是否都是正確的
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(PhotoInfoError.itemNotfound))
                return
            }
            
            // 嘗試解碼JSON資料
            do {
                let jsonDecoder = JSONDecoder()
                let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
                completion(.success(photoInfo))                     // 如果解碼成功，通知呼叫者取得了照片資訊
            } catch {
                completion(.failure(error))                         // 如果解碼失敗，通知呼叫者錯誤訊息
            }
        }.resume()          // 啟動網路請求
    }
    
    // 使用異步函數從指定URL取得照片
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        // 首先創建URLComponents實例，確保可以修改URL的部件
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        // 將協定切換為HTTPS
        urlComponents?.scheme = "https"
        
        // 確保URL有效，然後繼續
        guard let secureUrl = urlComponents?.url else {
            completion(.failure(PhotoInfoError.invalidURL))
            return
        }
        
        // 使用URLSession的dataTask方法來進行網路請求
        let task = URLSession.shared.dataTask(with: secureUrl) { data, response, error in
            // 如果有任何網路錯誤，直接通知呼叫者
            if let error = error {
                completion(.failure(error))
            }
            
            // 檢查回應的資料和狀態碼是否都是正確的
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(PhotoInfoError.itemNotfound))
                return
            }
            
            // 嘗試從數據創建UIImage對象
            if let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(PhotoInfoError.imgaeDataMissing))
            }
        }.resume()
    }
    
}
*/

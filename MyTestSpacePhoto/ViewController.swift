//
//  ViewController.swift
//  MyTestSpacePhoto
//
//  Created by 曹家瑋 on 2023/10/31.
//

// MARK: - Task、MainActor

import UIKit

@MainActor
class ViewController: UIViewController {

    // 顯示資訊
    @IBOutlet weak var nasaImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    // 創建 PhotoInfoController 的實例，進行網路請求
    let photoInfoController = PhotoInfoController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 將標題設為空字串
        title = ""
        // 將 nasaImageView 的圖片設為系統提供的預設圖片
        nasaImageView.image = UIImage(systemName: "photo.circle.fill")
        // 將 descriptionLabel 、copyrightLabel 的文字設為空字串
        descriptionLabel.text = ""
        copyrightLabel.text = ""
        
        // 使用 Task 來執行異步操作
        Task {
            do {
                // 嘗試非同步地從 photoInfoController 獲取照片資訊
                let photoInfo = try await photoInfoController.fetchPhotoInfo()
                // 使用獲取到的照片資訊更新 UI
                updateUI(with: photoInfo)
            } catch {
                // 如果有錯誤發生，則使用錯誤資訊更新 UI
                updateUI(with: error)
            }
        }
        
    }
    
    /// 使用獲取到的照片資訊更新 UI
    func updateUI(with photoInfo: PhotoInfo) {
        Task {
            do {
                // 從 photoInfoController 獲取圖片
                let image = try await photoInfoController.fetchImage(from: photoInfo.url)
                nasaImageView.image = image
                // 更新視圖控制器的標題和兩個標籤的文字內容
                title = photoInfo.title
                descriptionLabel.text = photoInfo.description
                copyrightLabel.text = photoInfo.copyright
            } catch {
                // 如果有錯誤發生，則使用錯誤資訊更新 UI
                updateUI(with: error)
            }
        }
    }
    
    /// 如果發生錯誤
    func updateUI(with error: Error) {
        // 如果獲取照片資訊過程中發生錯誤，則更新 UI 以顯示相關錯誤訊息
        title = "Error Fetching Photo"
        nasaImageView.image = UIImage(systemName: "exclamationmark.triangle")
        descriptionLabel.text = error.localizedDescription         // 使用 error 的 localizedDescription 來獲取錯誤的描述，
        copyrightLabel.text = ""
    }
    
}



// MARK: - 在 ViewController 的 viewDidLoad 方法中，將異步回調改為使用 Result 類型來捕獲成功和失敗的結果。使用 DispatchQueue.main.async 在主線程上更新 UI。

/*
import UIKit

class ViewController: UIViewController {
    
    // 顯示資訊
    @IBOutlet weak var nasaImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    // 創建 PhotoInfoController 的實例，進行網路請求
    let photoInfoController = PhotoInfoController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化UI元件
        setupInitialUI()
        
        // 使用PhotoInfoController的fetchPhotoInfo方法取得NASA的照片資訊
        photoInfoController.fetchPhotoInfo { [weak self] result in
            // 使用DispatchQueue確保更新UI的操作在主線程執行
            DispatchQueue.main.async {
                switch result {
                // 若網路請求成功，則更新UI元件的內容
                case .success(let photoInfo):
                    self?.updateUI(with: photoInfo) // 使用updateUI方法直接更新界面
                // 若網路請求失敗，則顯示錯誤資訊和圖示
                case .failure(let error):
                    self?.updateUI(with: error)
                }
            }
            
        }
        
    }
    
    /// 初始化UI元件
    func setupInitialUI() {
        // 將標題設為空字串
        title = ""
        // 將 nasaImageView 的圖片設為系統提供的預設圖片
        nasaImageView.image = UIImage(systemName: "photo.circle.fill")
        // 將 descriptionLabel 、copyrightLabel 的文字設為空字串
        descriptionLabel.text = ""
        copyrightLabel.text = ""
    }
    
    /// 使用照片資訊更新UI
    /// - Parameter photoInfo: 從NASA API取得的照片資訊
    func updateUI(with photoInfo: PhotoInfo) {
        // 更新標題、描述和版權資訊
        title = photoInfo.title
        descriptionLabel.text = photoInfo.description
        copyrightLabel.text = photoInfo.copyright
        
        // 使用photoInfo的URL取得照片
        photoInfoController.fetchImage(from: photoInfo.url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                // 若取得照片成功，則將照片設為 nasaImageView 的圖片
                case .success(let image):
                    self?.nasaImageView.image = image
                // 若取得照片失敗，則使用錯誤訊息更新UI
                case .failure(let error):
                    self?.updateUI(with: error)
                }
            }
        }
    }
    
    /// 使用錯誤資訊更新UI
    /// - Parameter error: 網路請求的錯誤資訊
    func updateUI(with error: Error) {
        // 若網路請求失敗，則顯示錯誤資訊和圖示
        title = "Error Fetching Photo"
        nasaImageView.image = UIImage(systemName: "exclamationmark.triangle")
        descriptionLabel.text = error.localizedDescription
        copyrightLabel.text = ""
    }
    
}
 */




// MARK: - DispatchQueue.main.async  還未抓取圖片
/*
import UIKit

class ViewController: UIViewController {
    
    // 顯示資訊
    @IBOutlet weak var nasaImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    // 創建 PhotoInfoController 的實例，進行網路請求
    let photoInfoController = PhotoInfoController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 將標題設為空字串
        title = ""
        // 將 nasaImageView 的圖片設為系統提供的預設圖片
        nasaImageView.image = UIImage(systemName: "photo.circle.fill")
        // 將 descriptionLabel 、copyrightLabel 的文字設為空字串
        descriptionLabel.text = ""
        copyrightLabel.text = ""
        
        // 使用PhotoInfoController的fetchPhotoInfo方法取得NASA的照片資訊
        photoInfoController.fetchPhotoInfo { [weak self] result in
            // 使用DispatchQueue確保更新UI的操作在主線程執行
            DispatchQueue.main.async {
                switch result {
                // 若網路請求成功，則更新UI元件的內容
                case .success(let photoInfo):
                    self?.title = photoInfo.title
                    self?.descriptionLabel.text = photoInfo.description
                    self?.copyrightLabel.text = photoInfo.copyright
                // 若網路請求失敗，則顯示錯誤資訊和圖示
                case .failure(let error):
                    self?.title = "Error Fetching Photo"
                    self?.nasaImageView.image = UIImage(systemName: "exclamationmark.triangle")
                    self?.descriptionLabel.text = error.localizedDescription
                    self?.copyrightLabel.text = ""
                }
            }
        }
    }
    
}
*/

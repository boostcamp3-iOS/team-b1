//
//  ImageNetworkManager.swift
//  Common
//
//  Created by admin on 13/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//
import UIKit

class ImageNetworkManager {

    private let session: URLSession

    static let shared = ImageNetworkManager()

    private let cache: NSCache = NSCache<NSString, UIImage>()

    private init(_ configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }

    private convenience init() {
        self.init(.default)
    }

    private func downloadImage(imageURL: URL, complection: @escaping (UIImage?, Error?) -> Void) {
        session.dataTask(with: imageURL) { (data, _, error) in
            if error != nil {
                //실패시 기본 이미지로 처리.
                print("네트워크 에러")
            }

            guard let data = data else {
                print("데이터 변환 에러")
                return
            }

            print("image: \(imageURL)")
            print("imagedata: \(data)")

            guard let image: UIImage = UIImage(data: data) else {
                print("이미지 변환 에러")
                return
            }

            self.cache.setObject(image, forKey: imageURL.absoluteString as NSString)

            DispatchQueue.main.async {
                complection(image, nil)
            }
            }.resume()
    }

    func getImageByCache(imageURL: URL, complection: @escaping (UIImage?, Error?) -> Void) {
        if let image = cache.object(forKey: imageURL.absoluteString as NSString) {
            complection(image, nil)
            return
        } else {
            downloadImage(imageURL: imageURL, complection: complection)
        }
    }

}

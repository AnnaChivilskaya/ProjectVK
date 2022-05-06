//
//  PhotoService.swift
//  vkontakte
//
//  Created by Аня on 18.04.2022.
//

import Foundation
import Alamofire
import UIKit

final class PhotoService {

    private var images = [String: UIImage]()
    private let casheLifeTime: TimeInterval = 30 * 24 * 60 * 60

    private static let pathName: String = {
           let fileManager = FileManager.default
           let pathName = "images"

           guard let cashesDirectory = fileManager
                    .urls(for: .cachesDirectory, in: .userDomainMask)
                    .first else { return pathName }
           let url = cashesDirectory.appendingPathComponent(pathName,
                                                          isDirectory: true)

           if !fileManager.fileExists(atPath: url.path) {
               try? fileManager.createDirectory(atPath: url.path,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
           }
           return pathName
       }()

    func photo(at indexPath: IndexPath, url: String?) -> UIImage? {
        guard let url = url else { return nil }
        var image : UIImage?

        if let photo = images[url] {
            image = photo
        } else if let photo = getImageFromCache(url: url) {
            image = photo
        } else {
            loadPhoto(at: indexPath, url: url)
            }
        return image
        }

    private func getFilePath(url: String) -> String? {
        guard let cachesDirectory = FileManager.default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first else { return nil }

        let hashName = url.split(separator: "/").last ?? "default"

        return cachesDirectory .appendingPathComponent(Self.pathName + "/" + hashName)
            .path
        }
    

    private func saveImageToCache(url: String, image: UIImage) {
        guard
            let filePath = getFilePath(url: url),
            let data = image.pngData() else { return }
        
        FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
    }


    private func getImageFromCache(url: String) -> UIImage? {
        guard
            let filePath = getFilePath(url: url),
            let info = try? FileManager.default.attributesOfItem(atPath: filePath),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date else { return nil }

        let lifeTime = Date().timeIntervalSince(modificationDate)

        guard
            lifeTime <= casheLifeTime,
            let image = UIImage(contentsOfFile: filePath) else { return nil }

        DispatchQueue.main.async {
            self.images[url] = image
            }

        return image
        }
    
    
    private func loadPhoto(at indexPath: IndexPath, url: String) {
        guard let imgUrl = URL(string: url) else { return }
        DispatchQueue.global().async { [weak self] in
        if let data = try? Data(contentsOf: imgUrl) {
            if let image = UIImage(data: data) {

                DispatchQueue.main.async {
                    self?.images[url] = image
                }
                self?.saveImageToCache(url: url, image: image)

                DispatchQueue.main.async {
                    self?.container.reloadRow(at: indexPath)
                }
            }
        }
        }

        }

    private let container: DataReloadable

    init(container: UITableView) {
        self.container = Table(table: container)
        }
    init(container: UICollectionView) {
        self.container = Collection(collection: container)
        }
    }

protocol DataReloadable {
    func reloadRow(at indexPath: IndexPath)
}

extension PhotoService {

    class Table: DataReloadable {
        let table: UITableView

        init(table: UITableView) {
            self.table = table
        }

        func reloadRow(at indexPath: IndexPath) {
            table.reloadRows(at: [indexPath], with: .none)
        }
    }

    class Collection: DataReloadable {
        let collection: UICollectionView

        init(collection: UICollectionView) {
            self.collection = collection
        }

        func reloadRow(at indexPath: IndexPath) {
            collection.reloadItems(at: [indexPath])
        }
    }

}

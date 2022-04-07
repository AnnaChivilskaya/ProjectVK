//
//  PhotoViewController.swift
//  vkontakte
//
//  Created by Аня on 01.02.2022.
//

import UIKit
import RealmSwift
import Kingfisher

class PhotosViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToNotificationRealm()
        
        
        GetPhoto().loadData(ownerID)
    }
    
    var realm: Realm = {
        let configrealm = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: configrealm)
        return realm
    }()
    
    lazy var photosFromRealm: Results<Photos> = {
        return realm.objects(Photos.self).filter("ownerID == %@", ownerID)
    }()
    
    var notificationToken: NotificationToken?
    
    
    var ownerID = ""
    var collectionPhotos: [Photos] = []
    
    
    class PhotosUICollectionView: UICollectionViewCell {
        @IBOutlet weak var photosFriendImage: UIImageView!
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosFriendCell", for: indexPath) as! PhotosUICollectionView
        
        if let imgUrl = URL(string: collectionPhotos[indexPath.row].photo) {
            let photo = ImageResource(downloadURL: imgUrl)
            cell.photosFriendImage.kf.setImage(with: photo)
            
          
        }
        
        return cell
    }
    
    private func subscribeToNotificationRealm() {
        notificationToken = photosFromRealm.observe { [weak self] (changes) in
            switch changes {
            case .initial:
                self?.loadPhotosFromRealm()
           
            case .update:
                self?.loadPhotosFromRealm()

            case let .error(error):
                print(error)
            }
        }
    }
    
    func loadPhotosFromRealm() {
            collectionPhotos = Array(photosFromRealm)
            guard collectionPhotos.count != 0 else { return }
            collectionView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showPhoto"{
            
            guard let photosFriend = segue.destination as? FriendsViewController else { return }
            
            
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                photosFriend.allPhotos = collectionPhotos
                photosFriend.countCurentPhoto = indexPath.row
            }
        }
    }
    
    
}

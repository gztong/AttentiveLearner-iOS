//
//  RemoteImage.swift
//  edX
//
//  Created by Michael Katz on 9/24/15.
//  Copyright © 2015 edX. All rights reserved.
//

import Foundation

protocol RemoteImage {
    var placeholder: UIImage? { get }
    var brokenImage: UIImage? { get }
    var image: UIImage? { get }
    
    /** Callback should be on main thread */
    func fetchImage(completion: (remoteImage : NetworkResult<RemoteImage>) -> ()) -> Removable
}


private let imageCache = NSCache()

class RemoteImageImpl: RemoteImage {
    let placeholder: UIImage?
    let url: String
    var localImage: UIImage?
    let networkManager: NetworkManager
    let persist: Bool
    
    init(url: String, networkManager: NetworkManager, placeholder: UIImage?, persist: Bool) {
        self.url = url
        self.placeholder = placeholder
        self.networkManager = networkManager
        self.persist = persist
    }
    
    private var filename: String {
        return url.oex_md5
    }
    
    private var localFile: String {
        let cachesDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
        let remoteImageDir = (cachesDir as NSString).stringByAppendingPathComponent("remoteimages")
        if !NSFileManager.defaultManager().fileExistsAtPath(remoteImageDir) {
            _ = try? NSFileManager.defaultManager().createDirectoryAtPath(remoteImageDir, withIntermediateDirectories: true, attributes: nil)
        }
        return (remoteImageDir as NSString).stringByAppendingPathComponent(filename)
    }
    
    var image: UIImage? {
        if localImage != nil { return localImage }
        
        if let cachedImage = imageCache.objectForKey(filename) {
            return cachedImage as? UIImage
        }
        else if let localImage = UIImage(contentsOfFile: localFile) {
            let cost = Int(localImage.size.height * localImage.size.width)
            imageCache.setObject(localImage, forKey: filename, cost: cost)
            return localImage
        }
        else {
            return nil
        }
    }
    
    private func imageDeserializer(response: NSHTTPURLResponse, data: NSData) -> Result<RemoteImage> {
        if let newImage = UIImage(data: data) {
            let result = self
            result.localImage = newImage
            
            let cost = data.length
            imageCache.setObject(newImage, forKey: filename, cost: cost)
            
            if persist {
                data.writeToFile(localFile, atomically: false)
            }
            return Success(result)
        }
        
        return Failure(NSError.oex_unknownError())
    }
    
    func fetchImage(completion: (remoteImage : NetworkResult<RemoteImage>) -> ()) -> Removable {
        // Only authorize requests to the API host
        // This is necessary for two reasons:
        // 1. We don't want to leak credentials by loading random images
        // 2. Some servers will explicitly reject our credentials even if
        // the image is public. Causing the load to fail
        let host = NSURL(string: url).flatMap { $0.host }
        let noHost = host?.isEmpty ?? true
        let matchesBaseHost = host == self.networkManager.baseURL.host

        let requiresAuth = noHost || matchesBaseHost
        
        let request = NetworkRequest(method: .GET,
            path: url,
            requiresAuth: requiresAuth,
            deserializer: .DataResponse(imageDeserializer)
        )
        return networkManager.taskForRequest(request, handler: completion)
    }
}

struct RemoteImageJustImage : RemoteImage {
    let placeholder: UIImage?
    var image: UIImage?
    
    init (image: UIImage?) {
        self.image = image
        self.placeholder = image
    }
}

extension RemoteImage {
    var brokenImage:UIImage? { return placeholder }
    func fetchImage(completion: (remoteImage : NetworkResult<RemoteImage>) -> ()) -> Removable {
        let result = NetworkResult<RemoteImage>(request: nil, response: nil, data: self, baseData: nil, error: nil)
        completion(remoteImage: result)
        return BlockRemovable {}
    }
}

extension UIImageView {
    private struct AssociatedKeys {
        static var SpinerName = "remoteimagespinner"
        static var LastRemoteTask = "lastremotetask"
        static var HidesLoadingSpinner = "hidesLoadingSpinner"
    }
    
    var spinner: SpinnerView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.SpinerName) as? SpinnerView
        }
        set {
            if let oldSpinner = objc_getAssociatedObject(self, &AssociatedKeys.SpinerName) as? SpinnerView {
                oldSpinner.removeFromSuperview()
            }
            if newValue != nil {
                objc_setAssociatedObject(self, &AssociatedKeys.SpinerName, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }
    
    var lastRemoteTask: Removable? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.LastRemoteTask) as? Removable
        }
        set {
            if let oldTask = objc_getAssociatedObject(self, &AssociatedKeys.LastRemoteTask) as? Removable {
                oldTask.remove()
            }
            if let newTask = newValue as? AnyObject {
                objc_setAssociatedObject(self, &AssociatedKeys.LastRemoteTask, newTask, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }
    
    var hidesLoadingSpinner : Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.HidesLoadingSpinner) as? NSNumber)?.boolValue ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.HidesLoadingSpinner, NSNumber(bool: newValue), .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var remoteImage: RemoteImage? {
        get { return RemoteImageJustImage(image: image) }
        set {
            guard let ri = newValue else { image = nil; return }
            
            let localImage = ri.image
            if localImage != nil {
                image = localImage
                return
            }
            
            image = ri.placeholder
            
            if !hidesLoadingSpinner {
                startSpinner()
            }
            lastRemoteTask = ri.fetchImage(self.handleRemoteLoaded)
        }
    }
    
    func handleRemoteLoaded(result : NetworkResult<RemoteImage>) {
        self.stopSpinner()
        
        if let remoteImage = result.data {
            if let im = remoteImage.image {
                image = im
            } else {
                image = remoteImage.brokenImage
            }
        }
    }
    
    func startSpinner() {
        let spinner = self.spinner ?? SpinnerView(size: .Large, color: .Primary)
        self.spinner = spinner
        
        superview?.addSubview(spinner)
        spinner.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(snp_center)
        }
        spinner.startAnimating()
        spinner.hidden = false
    }
    
    func stopSpinner() {
        spinner?.stopAnimating()
        spinner?.removeFromSuperview()
    }
}
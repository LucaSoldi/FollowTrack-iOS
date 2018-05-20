//
//  Socket.swift
//  FollowTrack
//
//  Created by Luca Soldi on 11/02/17.
//  Copyright © 2017 Luca Soldi. All rights reserved.
//

import Foundation
import SocketIO
import CryptoSwift

protocol SocketFollowDelegate: class {
    func didSocketConnected(sender: Socket)
    func didUpdateLocation(sender: Socket, latitude: Double, longitude: Double, track_id: String, follower: Int?)
}

public class Socket {
    
    static let sharedInstance: Socket = Socket()
    weak var delegate:SocketFollowDelegate?

    var socket: SocketIOClient?
    var passkey: String!
    var iv: String!
    
    #if (arch(i386) || arch(x86_64)) && os(iOS)
    private var socketUrl = "http://127.0.0.1:8080"
    #else
    private var socketUrl = "http://172.20.10.3:8080"
    #endif
    
    private let guideMove = "guideMove"
    private let setupTrack = "setupTrack"
    
    init() {
        socket = SocketIOClient(socketURL: URL(string:socketUrl)!)
        socket!.connect()
        self.addHandlers()
    }
    
    func setupPasskey(_ passkey: String, iv: String) {
        self.passkey = passkey
        self.iv = iv
    }
    
    func addHandlers() {
        
        socket?.on("updateLocation") {data,ack in  
            var latitude = Double()
            var longitude = Double()
            if let latitudeCipher = data[0] as? Array<UInt8> {
                let latitudePlain = try! latitudeCipher.decrypt(cipher: AES(key: self.passkey, iv: self.iv))
                latitude = Double(latitudePlain.reduce("", { $0 + String(format: "%c", $1)}))!
            }
            if let longitudeCipher = data[1] as? Array<UInt8> {
                let longitudePlain = try! longitudeCipher.decrypt(cipher: AES(key: self.passkey, iv: self.iv))
                longitude = Double(longitudePlain.reduce("", { $0 + String(format: "%c", $1)}))!
            }
            if let track_id = data[2] as? String {
                self.delegate?.didUpdateLocation(sender: self, latitude: latitude, longitude: longitude, track_id: track_id, follower: nil)
            }
                       
        }
        socket?.onAny {
            if ($0.event == "connect") {
                self.delegate?.didSocketConnected(sender: self)
            }
            //print("Got event: \($0.event), with items: \($0.items)")
        }
    }
    
    func setupTrackSocket(leader: Bool, trackID: String) {
        //print("\(leader) \(trackID)")
        self.socket?.emit("setupTrack", leader, trackID)
    }
    
    func sendNewLocation(latitude: Double, longitude: Double, trackID: String) {
        do {
            let aes = try AES(key: passkey, iv: self.iv) // aes128
            let latitudeCipher = try aes.encrypt(Array(String(latitude).utf8))
            let longitudeCipher = try aes.encrypt(Array(String(longitude).utf8))
            self.socket?.emit("guideMove", latitudeCipher, longitudeCipher, trackID)
            
        } catch { }
    }

}

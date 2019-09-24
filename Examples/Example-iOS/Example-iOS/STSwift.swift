//
//  STSwift.swift
//  Carvoice_rn
//
//  Created by wxf on 2019/9/17.
//  Copyright © 2019 Facebook. All rights reserved.
//

import SwiftyZeroMQ
@objc(STSwift)
//    var index = 10
//
//    while index < 20
//    {
//      let buffer = UnsafeMutablePointer<CChar>.allocate(
//        capacity: 300)
//      zmq_recv(responder, buffer, 300, 0);
//      let data = Data(bytes: buffer, count: Int(300))
//      let s =  String(data: data, encoding: String.Encoding.utf8)
//      print(s)
//    }

public class STSwift: NSObject {
    private let endpoint = "tcp://pms.carvoice.net:18000";
    private let context : SwiftyZeroMQ.Context
    private let responder : SwiftyZeroMQ.Socket
//    private var callback : (String, Array<Data>) -> Void = Void
    @objc public init(id: String) throws {
        context = try SwiftyZeroMQ.Context()
        responder = try context.socket(.dealer)
        try responder.setStringSocketOption(ZMQ_IDENTITY, id)
        try responder.connect(endpoint)
    }
    
    @objc public func notify (_ callback: @escaping (String, Array<Data>) -> Void) {
//        self.callback = callback
        let queue = DispatchQueue(label: "zmq-recv")
        queue.async {
            do {
                while true { //@TODO need to exit on dstr
                    var msgs = try self.responder.recvMultipart()
                    if (msgs.isEmpty) {
                        print("Received empty message")
                        return
                    }
                    let id = String(data: msgs.removeFirst(), encoding: String.Encoding.utf8)
                    callback(id ?? "", msgs)
                }
            } catch let error {
                print("Error \(error)")
            }
        }
    }
    ///发送信息
    @objc func send(dest: String, msg: String) throws {
        try responder.send(string: dest, options: .sendMore);
        try responder.send(string: msg)
  }
}

//
// Copyright (c) 2016-2017 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

import UIKit
import SwiftyZeroMQ

class ViewController: UIViewController {

    @IBOutlet weak var versionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Show version information
        let frameworkVersion = SwiftyZeroMQ.frameworkVersion
        let version = SwiftyZeroMQ.version.versionString
        versionTextView.text =
        "SwiftyZeroMQ version is \(frameworkVersion)\n" +
            "ZeroMQ library version is \(version)"
        
        do {
            let zmq = try STSwift.init(id: "abc")
            //Use notify to set a callback when data recieved. Only need to call once.
            zmq.notify( { (id: String, data: Array<Data>) in
                print("got message from \(id)!")
                for msg in data {
                    print(String(data: msg, encoding: String.Encoding.utf8) ?? "Non string msg!")
                }
            })
            try zmq.send(dest: "123", msg: "hello from ios 1")
            try zmq.send(dest: "123", msg: "hello from ios 2")
            try zmq.send(dest: "123", msg: "hello from ios 3")
        } catch let error {
            print("Got error: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


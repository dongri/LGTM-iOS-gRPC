//
//  FirstViewController.swift
//  LGTM
//
//  Created by Dongri Jin on 2017/12/14.
//  Copyright © 2017 Dongri Jin. All rights reserved.
//

import UIKit
import api

class FirstViewController: UIViewController {

    let hostAddress = "159.203.119.125:5555"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GRPCCall.useInsecureConnections(forHost: hostAddress)
        GRPCCall.setUserAgentPrefix("api/1.0", forHost: hostAddress)
        
        let client = LGTM(host: hostAddress)
        let request = ItemsRequest()
        request.page = Int64(0)

        client.items(with: request, handler: { (res: ItemsResponse?, error: Error?) -> Void in
            if let res = res {
                let items: NSMutableArray = res.itemsArray
                for item in items {
                    let i = item as! Item
                    print("id = " + String(i.id_p))
                    print("url = " + i.url)
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


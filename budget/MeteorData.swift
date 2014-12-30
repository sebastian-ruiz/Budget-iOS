//
//  MeteorData.swift
//  budget
//
//  Created by Sebastian Ruiz on 26/12/2014.
//  Copyright (c) 2014 Sebastian Ruiz. All rights reserved.
//

import Foundation

class MeteorData {
    
    var userId: Int
    var name: String
    var meteorClient: MeteorClient;
    
    class var sharedInstance : MeteorData {
        struct Static {
            static let instance : MeteorData = MeteorData()
        }
        return Static.instance
    }
    
    init() {
        println("Initialising Meteor Client");
        userId = 0;
        name = "";
        meteorClient = initialiseMeteor("pre2", "ws://localhost:3000/websocket");
        meteorClient.addSubscription("things")
        meteorClient.addSubscription("lists")
    }
    
    
    
}
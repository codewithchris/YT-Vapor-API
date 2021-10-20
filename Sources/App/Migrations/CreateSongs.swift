//
//  CreateSongs.swift
//  
//
//  Created by Mikaela Caron on 10/19/21.
//

import Fluent

struct CreateSongs: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("songs")
            .id()
            .field("title", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("songs").delete()
    }
}

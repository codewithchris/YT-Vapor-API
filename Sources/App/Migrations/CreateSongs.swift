//
//  CreateSongs.swift
//  
//
//  Created by Mikaela Caron on 10/19/21.
//

import Fluent

struct CreateSongs: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("songs")
            .id()
            .field("title", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("songs").delete()
    }
}

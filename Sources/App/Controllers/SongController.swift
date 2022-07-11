//
//  SongController.swift
//  
//
//  Created by Mikaela Caron on 10/19/21.
//

import Fluent
import Vapor

struct SongController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let songs = routes.grouped("songs")
        songs.get(use: index)
        songs.post(use: create)
        songs.put(use: update)
        songs.group(":songID") { song in
            song.delete(use: delete)
        }
    }
    
    
    // GET Request /songs route
    func index(req: Request) async throws -> [Song] {
//        return Song.query(on: req.db).all()
        try await Song.query(on: req.db).all()
    }
    
    // POST Request /songs route
    func create(req: Request) async throws -> HTTPStatus {
        let song = try req.content.decode(Song.self)
//        return song.save(on: req.db).transform(to: .ok)
        
        try await song.save(on: req.db)
        return .ok
    }
    
    // PUT Request /songs routes
    func update(req: Request) async throws -> HTTPStatus {
        let song = try req.content.decode(Song.self)
        
//        return Song.find(song.id, on: req.db)
//        .unwrap(or: Abort(.notFound))
//        .flatMap {
//            $0.title = song.title
//            return $0.update(on: req.db).transform(to: .ok)
//        }
        
        guard let songFromDB = try await Song.find(song.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        songFromDB.title = song.title
        try await songFromDB.update(on: req.db)
        return .ok
    }
    
    // DELETE Request /songs/id route
    func delete(req: Request) async throws -> HTTPStatus {
//        Song.find(req.parameters.get("songID"), on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap { $0.delete(on: req.db) }
//            .transform(to: .ok)
        
        guard let song = try await Song.find(req.parameters.get("songID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await song.delete(on: req.db)
        return .ok
    }
}

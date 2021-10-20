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
    }
    
    
    // GET Request /songs route
    func index(req: Request) throws -> EventLoopFuture<[Song]> {
        return Song.query(on: req.db).all()
    }
    
    // POST Request /songs route
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)
        return song.save(on: req.db).transform(to: .ok)
    }
}

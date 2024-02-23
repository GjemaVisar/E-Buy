import Foundation
import SQLite3

class DataBaseManager {
    static let shared = DataBaseManager()
    
    private var db: OpaquePointer?
    
    private init() {
        openDatabase()
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    private func openDatabase() {
        if db != nil {
            return // Database already opened
        }
        
        if sqlite3_open(getDBPath(), &db) == SQLITE_OK {
            print("Database opened successfully")
        } else {
            print("Error opening database")
        }
    }
    
    private func getDBPath() -> String {
        let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbPath = URL(fileURLWithPath: documentsDir).appendingPathComponent("moviesDB.sqlite").path
        return dbPath
    }
    
//    private func createTable() {
//        let createTableQuery = """
//        CREATE TABLE IF NOT EXISTS Movies (
//            id INTEGER PRIMARY KEY AUTOINCREMENT,
//            title TEXT,
//            year TEXT,
//            imdbID TEXT,
//            type TEXT,
//            poster TEXT
//        );
//        """
//
//        if sqlite3_exec(db, createTableQuery, nil, nil, nil) == SQLITE_OK {
//            print("Table created successfully")
//        } else {
//            print("Error creating table")
//        }
//    }
    
//    func insertMovie(movie: Movie) -> Bool {
//        let insertQuery = """
//        INSERT INTO Movies (title, year, imdbID, type, poster)
//        VALUES (?, ?, ?, ?, ?);
//        """
//
//        var statement: OpaquePointer?
//
//        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
//            defer {
//                sqlite3_finalize(statement)
//            }
//
//            sqlite3_bind_text(statement, 1, (movie.Title as NSString).utf8String, -1, nil)
//            sqlite3_bind_text(statement, 2, (movie.Year as NSString).utf8String, -1, nil)
//            sqlite3_bind_text(statement, 3, (movie.imdbID as NSString).utf8String, -1, nil)
//            sqlite3_bind_text(statement, 4, (movie._Type as NSString).utf8String, -1, nil)
//            sqlite3_bind_text(statement, 5, (movie.Poster as NSString).utf8String, -1, nil)
//
//            if sqlite3_step(statement) == SQLITE_DONE {
//                print("Movie added to the database successfully.")
//                return true
//            } else {
//                print("Error inserting movie into the database")
//            }
//        } else {
//            print("Error preparing insert statement")
//        }
//
//        return false
//    }
//
//    func removeMovie(imdbID: String) -> Bool {
//        let deleteQuery = """
//        DELETE FROM Movies
//        WHERE imdbID = ?;
//        """
//
//        var statement: OpaquePointer?
//
//        if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
//            defer {
//                sqlite3_finalize(statement)
//            }
//
//            sqlite3_bind_text(statement, 1, (imdbID as NSString).utf8String, -1, nil)
//
//            if sqlite3_step(statement) == SQLITE_DONE {
//                print("Movie removed from the database successfully.")
//                return true
//            } else {
//                print("Error deleting movie from the database")
//            }
//        } else {
//            print("Error preparing delete statement")
//        }
//
//        return false
//    }
}

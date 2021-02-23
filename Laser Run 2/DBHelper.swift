//
//  DBHelper.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 30/06/2020.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "LaserRunDB.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS character(id INTEGER PRIMARY KEY,name TEXT,barrier INTEGER, progress INTEGER, unlockedtext TEXT, lockedtext TEXT, locked INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("character table created.")
            } else {
                print("character table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(id:Int, name:String, barrier:Int, progress:Int, unlocked: String, locked: String){
        
        let insertStatementString = "INSERT INTO character (id, name, barrier, progress, unlockedtext, lockedtext, locked) VALUES (NULL, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 2, Int32(barrier))
            sqlite3_bind_int(insertStatement, 3, Int32(progress))
            sqlite3_bind_text(insertStatement, 4, (unlocked as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (locked as NSString).utf8String, -1, nil)
            //0 is unlocked, 1 is locked
            if progress>=barrier{
                sqlite3_bind_int(insertStatement, 6, Int32(0))
            }
            else{
                sqlite3_bind_int(insertStatement, 6, Int32(1))
            }

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read(queryStatementString: String) -> [Character] {
        var queryStatement: OpaquePointer? = nil
        var characters : [Character] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let barrier = sqlite3_column_int(queryStatement, 2)
                let progress = sqlite3_column_int(queryStatement, 3)
                let unlocked = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let locked = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))

                
                characters.append(Character(locked: progress<barrier, imageNamed: name, unlockDescription: unlocked, lockedDescription: locked, barrier: Int32(barrier), progress: Int32(progress), id: id))
                
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return characters
    }
    
    func update(updateStatementString: String) {
      var updateStatement: OpaquePointer?
      if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
          SQLITE_OK {
        if sqlite3_step(updateStatement) == SQLITE_DONE {
          print("\nSuccessfully updated row.")
        } else {
          print("\nCould not update row.")
        }
      } else {
        print("\nUPDATE statement is not prepared")
      }
      sqlite3_finalize(updateStatement)
    }
    
}

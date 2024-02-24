import Foundation
import SQLite3

class DataBaseManager {
    static let shared = DataBaseManager()
    
    private var db: OpaquePointer?
    
    private let productTable = "product"
    
    private let nameColumn = "name"
    private let priceColumn = "price"
    private let imageColumn = "image"
    private let descriptionColumn = "description"
    private let quantityColumn = "quantity"

    private init() {
        openDatabase()
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    private func openDatabase() {
        if db != nil {
            print("Database already opened")
            createTable()
            return // Database already opened
        }
        
        if sqlite3_open(getDBPath(), &db) == SQLITE_OK {
            createTable()
            print("Database opened successfully")
        } else {
            print("Error opening database")
        }
    }
    
    private func getDBPath() -> String {
        let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbPath = URL(fileURLWithPath: documentsDir).appendingPathComponent("shopDB.sqlite").path
        return dbPath
    }
    
    private func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS \(productTable) (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            \(nameColumn) TEXT NOT NULL,
            \(priceColumn) REAL NOT NULL,
            \(imageColumn) TEXT NOT NULL,
            \(descriptionColumn) TEXT NOT NULL,
            \(quantityColumn) INTEGER NOT NULL
        );
        """

        if sqlite3_exec(db, createTableQuery, nil, nil, nil) == SQLITE_OK {
            print("Table created successfully")
        } else {
            print("Error creating table")
        }
    }
    
    func insertProduct(name: String, price: Double, image: String?, description: String?, quantity: Int?) {
        let insertQuery = """
            INSERT INTO \(productTable) (\(nameColumn), \(priceColumn), \(imageColumn), \(descriptionColumn), \(quantityColumn))
            VALUES (?, ?, ?, ?, ?);
        """

        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            defer {
                sqlite3_finalize(statement)
            }

            sqlite3_bind_text(statement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_double(statement, 2, price)

            if let image = image {
                sqlite3_bind_text(statement, 3, (image as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(statement, 3)
            }

            if let description = description {
                sqlite3_bind_text(statement, 4, (description as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(statement, 4)
            }

            if let quantity = quantity {
                sqlite3_bind_int(statement, 5, Int32(quantity))
            } else {
                sqlite3_bind_null(statement, 5)
            }

            if sqlite3_step(statement) == SQLITE_DONE {
                print("Product inserted successfully.")
            } else {
                print("Error inserting product into the database")
            }
        } else {
            print("Error preparing insert statement")
        }
    }

    public func insertDummieData() {
        insertProduct(name: "Product1", price: 19.99, image: "product1.jpg", description: "Description of Product1", quantity: 10)
        insertProduct(name: "Product2", price: 29.99, image: nil, description: nil, quantity: nil)
        insertProduct(name: "Product3", price: 39.99, image: nil, description: nil, quantity: 5)
        print("Data inserted succesfully")
        // Add more dummy data as needed
    }
    
    func printAllProducts() {
          let query = "SELECT * FROM \(productTable);"

          var statement: OpaquePointer?

          if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
              defer {
                  sqlite3_finalize(statement)
              }

              while sqlite3_step(statement) == SQLITE_ROW {
                  let id = sqlite3_column_int(statement, 0)
                  let name = String(cString: sqlite3_column_text(statement, 1))
                  let price = sqlite3_column_double(statement, 2)
                  let image = String(cString: sqlite3_column_text(statement, 3))
                  let description = String(cString: sqlite3_column_text(statement, 4))
                  let quantity = sqlite3_column_int(statement, 5)

                  print("ID: \(id), Name: \(name), Price: \(price), Image: \(image), Description: \(description), Quantity: \(quantity)")
              }
          } else {
              print("Error preparing SELECT statement")
          }
      }
  }


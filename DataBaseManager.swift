import Foundation
import SQLite3

class DataBaseManager {
    static let shared = DataBaseManager()
    
    private var db: OpaquePointer?
    
    // Database table attributes
    
    private let productTable = "product"
    private let productTableCart = "cart"
    private let idColumn = "id"
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
            return // Database already opened
        }
        
        if sqlite3_open(getDBPath(), &db) == SQLITE_OK {
            createTable(tableName: productTable)
            createTable(tableName: productTableCart)
            print("Database opened successfully")
        } else {
            print("Error opening database")
        }
    }
    
    private func getDBPath() -> String {
        let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbPath = URL(fileURLWithPath: documentsDir).appendingPathComponent("shopDB.sqlite").path
        print(dbPath)
        return dbPath
    }
    
    private func createTable(tableName: String) {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS \(tableName) (
            \(idColumn) INTEGER PRIMARY KEY AUTOINCREMENT,
            \(nameColumn) TEXT NOT NULL,
            \(priceColumn) REAL NOT NULL,
            \(imageColumn) TEXT NOT NULL,
            \(descriptionColumn) TEXT NOT NULL,
            \(quantityColumn) INTEGER NOT NULL
        );
        """
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) == SQLITE_OK {
            print("Table \(tableName) created successfully")
        } else {
            print("Error creating table \(tableName)")
        }
    }
    
    // Insert product in DB
    func insertProduct(name: String, price: Double, image: String?, description: String?, quantity: Int?, intoTable tableName: String = "product") -> Bool {
        let insertQuery = """
            INSERT INTO \(tableName) (\(nameColumn), \(priceColumn), \(imageColumn), \(descriptionColumn), \(quantityColumn))
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
                print("Product inserted successfully into table \(tableName).")
                return true // Return true for successful insertion
            } else {
                print("Error inserting product into the database")
            }
        } else {
            print("Error preparing insert statement")
        }
        
        return false // Return false if insertion fails
    }

    
    func dropTable(tableName: String) {
        let dropTableQuery = "DROP TABLE IF EXISTS \(tableName);"
        
        if sqlite3_exec(db, dropTableQuery, nil, nil, nil) == SQLITE_OK {
            print("Table \(tableName) dropped successfully")
        } else {
            print("Error dropping table \(tableName)")
        }
    }
    
    func printAllProducts() {
        printProducts(fromTable: productTable)
    }
    
    private func printProducts(fromTable tableName: String) {
        let query = "SELECT * FROM \(tableName);"
        
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
                
                let product = Product(
                    id: Int(id),
                    title: name,
                    price: price,
                    description: description,
                    image: image,
                    category: "unknown", // You might adjust this based on your data model
                    quantity: Int(quantity)
                )
                
                print("ID: \(product.id), Name: \(product.title), Price: \(product.price), Image: \(product.image), Description: \(product.description), Quantity: \(product.quantity)")
            }
        } else {
            print("Error preparing SELECT statement")
        }
    }
    
  
    // Get products from API insert them in JSON file
    func fetchAndInsertDataFromAPI() {
        guard let url = URL(string: "https://fakestoreapi.com/products?limit=10") else {
            print("Invalid API URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data from API: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                
                // Save JSON data to a file
                saveJSONToFile(data)
                
                for product in products {
                   _ = self.insertProduct(
                        name: product.title,
                        price: product.price,
                        image: product.image,
                        description: product.description,
                        quantity: 5, // You might adjust this based on your data model
                        intoTable: productTable
                    )
                }
                
                print("Data fetched from API, inserted into the database, and saved to a JSON file successfully.")
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func saveJSONToFile(_ data: Data) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("apiData.json")
        
        do {
            try data.write(to: fileURL)
            print("JSON data saved to: \(fileURL.path)")
        } catch {
            print("Error saving JSON data to file: \(error.localizedDescription)")
        }
    }
    
    func getAllProducts() -> [Product] {
        return fetchProducts(fromTable: productTable)
    }
    
    func getAllCartProducts() -> [Product] {
        return fetchProducts(fromTable: productTableCart)
    }
    
    private func fetchProducts(fromTable tableName: String) -> [Product] {
        var products: [Product] = []
        
        let query = "SELECT * FROM \(tableName);"
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
                
                let product = Product(
                    id: Int(id),
                    title: name,
                    price: price,
                    description: description,
                    image: image,
                    category: "unknown", // You might adjust this based on your data model
                    quantity: Int(quantity)
                )
                
                products.append(product)
            }
        } else {
            print("Error preparing SELECT statement")
        }
        
        return products
    }
    
    func insertProductIntoCart(product: Product) -> Bool {
        return insertProduct(
            name: product.title,
            price: product.price,
            image: product.image,
            description: product.description,
            quantity: 5, // You might adjust this based on your data model
            intoTable: productTableCart
        )
    }
    
    func deleteProductFromCart(productId: Int) -> Bool {
        return deleteProduct(productId: productId, fromTable: productTableCart)
    }
    
    private func deleteProduct(productId: Int, fromTable tableName: String) -> Bool {
        let deleteQuery = "DELETE FROM \(tableName) WHERE \(idColumn) = ?;"
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
            defer {
                sqlite3_finalize(statement)
            }
            
            sqlite3_bind_int(statement, 1, Int32(productId))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Product deleted successfully.")
                return true
            } else {
                print("Error deleting product")
            }
        } else {
            print("Error preparing delete statement")
        }
        
        return false
    }
    
    func decrementProductQuantity(productName: String) {
        let updateQuery = "UPDATE \(productTableCart) SET \(quantityColumn) = \(quantityColumn) - 1 WHERE \(nameColumn) = ? AND \(quantityColumn) > 0;"
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateQuery, -1, &statement, nil) == SQLITE_OK {
            defer {
                sqlite3_finalize(statement)
            }
            
            sqlite3_bind_text(statement, 1, (productName as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Product quantity decremented successfully.")
            } else {
                print("Error decrementing product quantity")
            }
        } else {
            print("Error preparing update statement for quantity")
        }
    }
}

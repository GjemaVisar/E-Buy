import Foundation
import SQLite3

class DataBaseManager {
    static let shared = DataBaseManager()
    
    private var db: OpaquePointer?
    
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
            \(idColumn) INTEGER PRIMARY KEY AUTOINCREMENT,
            \(nameColumn) TEXT NOT NULL,
            \(priceColumn) REAL NOT NULL,
            \(imageColumn) TEXT NOT NULL,
            \(descriptionColumn) TEXT NOT NULL,
            \(quantityColumn) INTEGER NOT NULL
        );
        """

        if sqlite3_exec(db, createTableQuery, nil, nil, nil) == SQLITE_OK {
            print("Table products created successfully")
        } else {
            print("Error creating table products")
        }
        let createTableCart = """
        CREATE TABLE IF NOT EXISTS \(productTableCart) (
            \(idColumn) INTEGER PRIMARY KEY AUTOINCREMENT,
            \(nameColumn) TEXT NOT NULL,
            \(priceColumn) REAL NOT NULL,
            \(imageColumn) TEXT NOT NULL,
            \(descriptionColumn) TEXT NOT NULL,
            \(quantityColumn) INTEGER NOT NULL
        );
        """

        if sqlite3_exec(db, createTableCart, nil, nil, nil) == SQLITE_OK {
            print("Table cart created successfully")
        } else {
            print("Error creating table cart")
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
    func dropProductTable() {
        let dropTableQuery = "DROP TABLE IF EXISTS \(productTable);"

        if sqlite3_exec(db, dropTableQuery, nil, nil, nil) == SQLITE_OK {
            print("Table dropped successfully")
        } else {
            print("Error dropping table")
        }
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
    struct Product: Codable {
        let id: Int
        let title: String
        let price: Double
        let description: String
        let image: String
        let category: String
    }

    
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
                    self.insertProduct(
                        name: product.title,
                        price: product.price,
                        image: product.image,
                        description: product.description,
                        quantity: 5 // You might adjust this based on your data model
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
    
    public func getAllProducts() -> [Product] {
        var products: [Product] = []

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

                let product = Product(
                    id: Int(id),
                    title: name,
                    price: price,
                    description: description,
                    image: image,
                    category: "unknown" // You might adjust this based on your data model
                )

                products.append(product)
            }
        } else {
            print("Error preparing SELECT statement")
        }

        return products
    }
    
    public func getAllCartProducts() -> [Product] {
        var products: [Product] = []

        let query = "SELECT * FROM \(productTableCart);"
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
                    category: "unknown" // You might adjust this based on your data model
                )

                products.append(product)
            }
        } else {
            print("Error preparing SELECT statement")
        }

        return products
    }
    func insertProductIntoCart(product: Product) -> Bool {
        let insertQuery = """
            INSERT INTO \(productTableCart) (\(nameColumn), \(priceColumn), \(imageColumn), \(descriptionColumn), \(quantityColumn))
            VALUES (?, ?, ?, ?, ?);
        """
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            defer {
                sqlite3_finalize(statement)
            }

            sqlite3_bind_text(statement, 1, (product.title as NSString).utf8String, -1, nil)
            sqlite3_bind_double(statement, 2, product.price)

            if let image = product.image as NSString? {
                sqlite3_bind_text(statement, 3, image.utf8String, -1, nil)
            } else {
                sqlite3_bind_null(statement, 3)
            }

            if let description = product.description as NSString? {
                sqlite3_bind_text(statement, 4, description.utf8String, -1, nil)
            } else {
                sqlite3_bind_null(statement, 4)
            }

            // Assuming you want to insert a default quantity, adjust as needed
            let defaultQuantity = 1
            sqlite3_bind_int(statement, 5, Int32(defaultQuantity))

            if sqlite3_step(statement) == SQLITE_DONE {
                print("Product inserted into cart successfully.")
                return true
            } else {
                print("Error inserting product into the cart table")
            }
        } else {
            print("Error preparing insert statement for cart")
        }
        
        return false
    }
    
    func deleteProductFromCart(productId: Int) -> Bool {
            let deleteQuery = "DELETE FROM \(productTableCart) WHERE \(idColumn) = ?;"

            var statement: OpaquePointer?

            if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
                defer {
                    sqlite3_finalize(statement)
                }

                sqlite3_bind_int(statement, 1, Int32(productId))

                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Product deleted from cart successfully.")
                    return true
                } else {
                    print("Error deleting product from cart table")
                }
            } else {
                print("Error preparing delete statement for cart")
            }

            return false
        }
}

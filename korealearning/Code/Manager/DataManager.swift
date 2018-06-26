//
//  DataManager.swift
//  korealearning
//
//  Created by Hien Nguyen on 6/24/18.
//  Copyright © 2018 Hien Nguyen. All rights reserved.
//

import UIKit
import GRDB
import PromiseKit

class DataManager {
    static let shared = DataManager()

    static let defaultDB = "learnkorean.sqlite"

    fileprivate var dbQueue: DatabaseQueue!

    init() {}


    func setup() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        let path = documentsPath.appendingPathComponent(DataManager.defaultDB)
        if !FileManager.default.fileExists(atPath: path), let dbFile = Bundle.main.path(forResource: "learnkorean", ofType: "sqlite") {
            do {
                try FileManager.default.copyItem(atPath: dbFile, toPath: path)
            } catch {
                print("copy file db error: \(error)")
            }
        }
        do {
            self.dbQueue = try DatabaseQueue(path: path)
            self.dbQueue.setupMemoryManagement(in: UIApplication.shared)
        } catch {
            print("\(error)")
        }
    }
}

extension DataManager {
    func getAllCategory() -> [Category] {
        var list: [Category] = []
        dbQueue.inDatabase { db in
            let sql = "SELECT * FROM category"
            do {
                let rows = try Row.fetchAll(db, sql)
                let decoder = JSONDecoder()
                list = rows.compactMap { row in
                    do {
                        let data = try JSONSerialization.data(withJSONObject: row.json, options: .prettyPrinted)
                        return try decoder.decode(Category.self, from: data)
                    } catch {
                        print("create Category failed: \(error)")
                        return nil
                    }
                }
            } catch {
                print("\(#function) failed: \(error)")
            }
        }

        return list
    }

    func getAllPhrases(categoryId: Int) -> [Phrase] {
        var list = [Phrase]()
        dbQueue.inDatabase { db in
            let sql = "SELECT * FROM phrase WHERE category_id = ?"
            do {
                let rows = try Row.fetchAll(db, sql, arguments: [categoryId])
                let decoder = JSONDecoder()
                list = rows.compactMap { row in
                    do {
                        let data = try JSONSerialization.data(withJSONObject: row.json, options: .prettyPrinted)
                        return try decoder.decode(Phrase.self, from: data)
                    } catch {
                        print("create Phrase failed: \(error)")
                        return nil
                    }
                }
            } catch {
                print("\(#function) failed: \(error)")
            }
        }
        return list
    }

    func searchPhrase(_ key: String) -> Promise<[Phrase]> {
        return Promise { p in
            var list = [Phrase]()
            dbQueue.inDatabase { db in
                let trimKey = key.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%")

                let sql = "SELECT * FROM phrase WHERE korean like %\(trimKey)% OR english like %\(trimKey)% OR chinese like %\(trimKey)% OR vietnamese like %\(trimKey)%"
                do {
                    let rows = try Row.fetchAll(db, sql)
                    let decoder = JSONDecoder()
                    list = rows.compactMap { row in
                        do {
                            let data = try JSONSerialization.data(withJSONObject: row.json, options: .prettyPrinted)
                            return try decoder.decode(Phrase.self, from: data)
                        } catch {
                            print("create Phrase failed: \(error)")
                            return nil
                        }
                    }
                } catch {
                    print("\(#function) failed: \(error)")
                    p.reject(error)
                }
            }
            p.resolve(list, nil)
        }
    }

    func getFavoriteList() -> Promise<[Phrase]> {
        return Promise { p in
            var list = [Phrase]()
            dbQueue.inDatabase { db in
                let sql = "SELECT * FROM phrase WHERE favorite = 1"
                do {
                    let rows = try Row.fetchAll(db, sql)
                    let decoder = JSONDecoder()
                    list = rows.compactMap { row in
                        do {
                            let data = try JSONSerialization.data(withJSONObject: row.json, options: .prettyPrinted)
                            return try decoder.decode(Phrase.self, from: data)
                        } catch {
                            print("create Phrase failed: \(error)")
                            return nil
                        }
                    }
                } catch {
                    print("\(#function) failed: \(error)")
                    p.reject(error)
                }
            }
            p.resolve(list, nil)
        }
    }

    func setFavorite(_ favorite: Bool, for phrase: Phrase) {
        let value = favorite ? 1 : 0
        dbQueue.write({ db in
            let sql = "UPDATE phrase SET (favorite) = (\(value)) WHERE _id = \(phrase._id)"
            do {
                let update = try db.makeUpdateStatement(sql)
                try update.execute()
            } catch {
                print("\(#function) update failed: \(error)")
            }
        })

    }


}

extension Row {
    var json: [String: Any] {
        get {
            var dict: [String: Any] = [:]
            for k in self.columnNames {
                dict[k] = self[k]
            }
            return dict
        }
    }
}

//
//  RepositoryManager.swift
//  VKProfile
//
//  Created by Тимур Шафигуллин on 27.11.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit
import FMDB
import CoreData

fileprivate enum ObjectType {
    case user
    case news
}



class BaseRepository: Repository {
    
    static let field_user_id = "user_id"
    static let field_user_name = "name"
    static let field_user_surname = "surname"
    static let field_user_email = "email"
    static let field_user_phone_number = "phoneNumber"
    static let field_user_age = "age"
    static let field_user_city = "city"
    static let field_user_password = "password"
    
    static let field_news_id = "news_id"
    static let field_news_text = "text"
    static let field_news_image = "image"
    static let field_news_like_count = "likeCount"
    static let field_news_comment_count = "commentCount"
    static let field_news_repost_count = "repostCount"
    
    var databaseManager: DatabaseManager!
    
    private let createUsersTableSQL = "CREATE TABLE users (\(field_user_id) INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, \(field_user_name) TEXT NOT NULL, \(field_user_surname) TEXT NOT NULL, \(field_user_email) TEXT NOT NULL, \(field_user_phone_number) TEXT NOT NULL, \(field_user_age) INTEGER NOT NULL, \(field_user_city) TEXT NOT NULL, \(field_user_password) TEXT NOT NULL, CONSTRAINT email_unique UNIQUE (\(field_user_email)), CONSTRAINT fk_user_id FOREIGN KEY (\(field_user_id)) REFERENCES users (\(field_user_id)) ON DELETE CASCADE);"
    private let createNewsTableSQL = "CREATE TABLE news (\(field_news_id) INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, \(field_news_text) TEXT NOT NULL, \(field_news_image) BLOB, \(field_news_like_count) INTEGER NOT NULL, \(field_news_comment_count) INTEGER NOT NULL, \(field_news_repost_count) INTEGER NOT NULL, \(field_user_id) INTEGER NOT NULL);"
    private let selectAllNewsSQL = "SELECT * FROM news;"
    private let selectAllUsersSQL = "SELECT * FROM users;"
    private let searchNewsSQL = "SELECT * FROM news WHERE \(field_news_id) = ?;"
    private let searchUserSQL = "SELECT * FROM users WHERE \(field_user_id) = ?;"
    
    init() {
        databaseManager = DatabaseManager()
        databaseManager.createDatabase(sql: [createUsersTableSQL, createNewsTableSQL])
    }
    
    func syncSave<T>(with object: T) -> Bool where T : Storable {
        let objectManaged = object.toManagedObject(in: CoreDataManager.instance.viewContext)
        if (T.self == News.self) {
            UserRepository.currentUser?.addToNews(objectManaged as! NewsManaged)
        }
        CoreDataManager.instance.saveContext()
        return true
    }
    
    func asyncSave<T>(with object: T, completionBlock: @escaping (Bool) -> ()) where T : Storable {
        CoreDataManager.instance.persistentContainer.performBackgroundTask { (context) in
            let _ = object.toManagedObject(in: context)
            do {
                try context.save()
                completionBlock(true)
            } catch {
                print(error.localizedDescription)
                completionBlock(false)
            }
        }
    }
    
    func syncGetAll<T>() -> [T]? where T : Storable {
        if UserVK.self == T.self {
            let fetch: NSFetchRequest<UserManaged> = UserManaged.fetchRequest()
            do {
                return try fetch.execute() as? [T]
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
    
    func asyncGetAll<T>(completionBlock: @escaping ([T]?) -> ()) where T : Storable {
        OperationQueue().addOperation { [weak self] in
            guard let strongSelf = self else { return }
            completionBlock(strongSelf.syncGetAll())
        }
    }
    
    func syncSearch<T>(id: Int, type: T.Type) -> T? where T : Storable {
        if type == UserVK.self {
            
        }
        return nil
    }
    
    func asyncSearch<T>(id: Int, type: T.Type, completionBlock: @escaping (T?) -> ()) where T : Storable {
        OperationQueue().addOperation { [weak self] in
            guard let strongSelf = self else { return }
            completionBlock(strongSelf.syncSearch(id: id, type: type))
        }
    }
    
    private func saveData<T: Storable>(array: [T], key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: array)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    private func getData<T>(key: String) -> [T]? where T: Storable {
        if let data = UserDefaults.standard.data(forKey: key) {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [T]
        }
        return nil
    }
    
    //MARK: - Get methods
    
    private func getAllNews() -> [News]? {
        return nil
    }
    
    private func getAllUsers() -> [UserVK]? {
        guard databaseManager.openDatabase() else { return nil }
        
        do {
            let results = try databaseManager.database.executeQuery(selectAllUsersSQL, values: nil)
            databaseManager.close()
            return getUsers(from: results)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    private func getUser(with ID: Int) -> UserVK? {
        guard databaseManager.openDatabase() else { return nil }
        
        do {
            let result = try databaseManager.database.executeQuery(searchUserSQL, values: [ID])
            databaseManager.close()
            return getUsers(from: result)?.first
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    //MARK: - Helpers methods
    
    func getUsers(from result: FMResultSet) -> [UserVK]? {
        var users = [UserVK]()
        while result.next() {
            let id = Int(result.int(forColumn: BaseRepository.field_user_id))
            let age = Int(result.int(forColumn: BaseRepository.field_user_age))
            guard let name = result.string(forColumn: BaseRepository.field_user_name),
                let surname = result.string(forColumn: BaseRepository.field_user_surname),
                let email = result.string(forColumn: BaseRepository.field_user_email),
                let phoneNumber = result.string(forColumn: BaseRepository.field_user_phone_number),
                let city = result.string(forColumn: BaseRepository.field_user_city),
                let password = result.string(forColumn: BaseRepository.field_user_password) else { return nil }
            
            users.append(UserVK(id: id, name: name, surname: surname, email: email, phoneNumber: phoneNumber, age: age, city: city, password: password))
        }
        return users.isEmpty ? nil : users
    }
    
    private func genericName<T: AnyObject>(_ type: T.Type) -> String {
        let fullName = NSStringFromClass(T.self)
        let range = fullName.range(of: ".")
        if let range = range {
            return String(fullName[range.upperBound..<fullName.endIndex])
        }
        return fullName
    }
}


//
//  Realm+Operator.swift
//  RealmIO
//
//  Created by ukitaka on 2017/04/24.
//  Copyright © 2017年 waft. All rights reserved.
//

import RealmSwift

// MARK: - IO

public extension Realm {
    struct IO { }
}

// MARK: - Write

public extension Realm.IO {

    /// Adds object into the Realm.
    ///
    /// - Parameter object: The object to be added to this Realm.
    /// - Returns: `Write` operation
    public static func add(_ object: Object) -> RealmWrite<Void> {
        return RealmWrite<Void> { realm in realm.add(object) }
    }

    /// Adds or updates an existing object into the Realm.
    ///
    /// - Warning: This method is not thread safe for now. It is not better to pass object directly.
    ///  If you want to use this method safely, you should call `realm.run(io:)` in a same thread, or 
    ///  use with `flatMap`.
    /// - Parameter object: The object to be added to this Realm.
    /// - Parameter update: If `true`, the Realm will try to find an existing copy of the object
    ///     (with the same primary key), and update it. Otherwise, the object will be added.
    /// - Returns: `Write` operation
    public static func add(_ object: Object, update: Bool) -> RealmWrite<Void> {
        return RealmWrite<Void> { realm in realm.add(object, update: update) }
    }

    /// Adds all the objects in a collection into the Realm.
    ///
    /// - Warning: This method is not thread safe for now. It is not better to pass object directly.
    ///  If you want to use this method safely, you should call `realm.run(io:)` in a same thread, or
    ///  use with `flatMap`.
    /// - Parameter objects: A sequence which contains objects to be added to the Realm.
    /// - Returns: `Write` operation
    public static func add<S>(_ objects: S) -> RealmWrite<Void> where S: Sequence, S.Iterator.Element: Object {
        return RealmWrite<Void> { realm in realm.add(objects) }
    }

    /// Adds or updates all the objects in a collection into the Realm.
    ///
    /// - Warning: This method is not thread safe for now. It is not better to pass object directly.
    ///  If you want to use this method safely, you should call `realm.run(io:)` in a same thread, or 
    ///  use with `flatMap`.
    /// - Parameter objects: A sequence which contains objects to be added to the Realm.
    /// - Parameter update: If `true`, objects that are already in the Realm will be updated instead of added anew.
    /// - Returns: `Write` operation
    public static func add<S>(_ objects: S, update: Bool = false) -> RealmWrite<Void> where S: Sequence, S.Iterator.Element: Object {
        return RealmWrite<Void> { realm in realm.add(objects, update: update) }
    }

    /// Creates or updates a Realm object with a given value, adding it to the Realm and returning it.
    ///
    /// - Parameter type:   The type of the object to create.
    /// - Parameter value:  The value used to populate the object.
    /// - Parameter update: If `true`, the Realm will try to find an existing copy of the object (with the same primary
    /// key), and update it. Otherwise, the object will be added.
    /// - Returns: `Write` operation
    public static func create<T>(_ type: T.Type, value: Any = [:], update: Bool = false) -> RealmWrite<T> where T: Object {
        return RealmWrite<T> { realm in
            return realm.create(type, value: value, update: update)
        }
    }

    /// This method is useful only in specialized circumstances, for example, when building
    /// components that integrate with Realm. If you are simply building an app on Realm, it is
    /// recommended to use the typed method `create(_:value:update:)`.
    ///
    /// - Parameter className:  The class name of the object to create.
    /// - Parameter value:      The value used to populate the object.
    /// - Parameter update:     If true will try to update existing objects with the same primary key.
    /// - Returns: `Write` operation
    public static func dynamicCreate(_ typeName: String, value: Any = [:], update: Bool = false) -> RealmWrite<DynamicObject> {
        return RealmWrite<DynamicObject> { realm in
            return realm.dynamicCreate(typeName, value: value, update: update)
        }
    }

    /// Deletes an object from the Realm. Once the object is deleted it is considered invalidated.
    ///
    /// - Warning: This method is not thread safe for now. It is not better to pass object directly.
    ///  If you want to use this method safely, you should call `realm.run(io:)` in a same thread, or 
    ///  use with `flatMap`.
    /// - Parameter object: The object to be deleted.
    /// - Returns: `Write` operation
    public static func delete(_ object: Object) -> RealmWrite<Void> {
        return RealmWrite<Void> { realm in return realm.delete(object) }
    }

    /// Deletes zero or more objects from the Realm.
    ///
    /// - Warning: This method is not thread safe for now. It is not better to pass object directly.
    ///  If you want to use this method safely, you should call `realm.run(io:)` in a same thread, or 
    ///  use with `flatMap`.
    /// - Parameter objects: The objects to be deleted. This can be a `List<Object>`,
    ///     `Results<Object>`, or any other Swift `Sequence` whose
    ///     elements are `Object`s (subject to the caveats above).
    /// - Returns: `Write` operation
    public static func delete<S: Sequence>(_ objects: S) -> RealmWrite<Void> where S.Iterator.Element: Object {
        return RealmWrite<Void> { realm in return realm.delete(objects) }
    }

    /// Deletes zero or more objects from the Realm.
    ///
    /// - Warning: This method is not thread safe for now. It is not better to pass object directly.
    ///  If you want to use this method safely, you should call `realm.run(io:)` in a same thread, or 
    ///  use with `flatMap`.
    /// - Parameter objects: A list of objects to delete.
    /// - Returns: `Write` operation
    public static func delete<T: Object>(_ objects: List<T>) -> RealmWrite<Void> {
        return RealmWrite<Void> { realm in realm.delete(objects) }
    }

    /// Deletes zero or more objects from the Realm.
    ///
    /// - Warning: This method is not thread safe for now. It is not better to pass object directly.
    ///  If you want to use this method safely, you should call `realm.run(io:)` in a same thread, or 
    ///  use with `flatMap`.
    /// - Parameter objects: A `Results` containing the objects to be deleted.
    /// - Returns: `Write` operation
    public static func delete<T: Object>(_ objects: Results<T>) -> RealmWrite<Void> {
        return RealmWrite<Void> { realm in return realm.delete(objects) }
    }

    /// Deletes all objects from the Realm.
    ///
    /// - Returns: `Write` operation
    public static func deleteAll() -> RealmWrite<Void> {
        return RealmWrite<Void> { realm in return realm.deleteAll() }
    }
}

// MARK: - Read

public extension Realm.IO {

    /// Returns all objects of the given type stored in the Realm.
    ///
    /// - Parameter type: The type of the objects to be returned.
    /// - Returns: `Read` operation
    public static func objects<T: Object>(_ type: T.Type) -> RealmRead<Results<T>> {
        return RealmRead<Results<T>> { realm in
            return realm.objects(type)
        }
    }

    /// Returns all objects for a given class name in the Realm.
    ///
    /// - Parameter typeName: The class name of the objects to be returned.
    /// - Returns: `Read` operation
    public static func dynamicObjects(_ typeName: String) -> RealmRead<Results<DynamicObject>> {
        return RealmRead<Results<DynamicObject>> { realm in
            return realm.dynamicObjects(typeName)
        }
    }

    /// Retrieves the single instance of a given object type with the given primary key from the Realm.
    ///
    /// - Parameter type: The type of the object to be returned.
    /// - Parameter key:  The primary key of the desired object.
    /// - Returns: `Read` operation
    public static func object<T: Object, K>(ofType type: T.Type, forPrimaryKey key: K) -> RealmRead<T?> {
        return RealmRead<T?> { realm in
            return realm.object(ofType: type, forPrimaryKey: key)
        }
    }
}

// MARK: - utils

public extension Realm.IO {

    /// Just instantiate object on RealmIO way.
    ///
    /// - Parameter type: The type of the object to be returned.
    /// - Returns: `Write` operation
    public static func unmanaged<T: Object>(_ type: T.Type) -> RealmWrite<T> {
        return RealmWrite<T> { _ in
            T()
        }
    }

    /// Just instantiate object with primary key on RealmIO way.
    ///
    /// - Parameter type: The type of the object to be returned.
    /// - Parameter primaryKey: primary key for object
    /// - Returns: `Write` operation
    public static func unmanaged<T: Object, S>(_ type: T.Type, primaryKey: S) -> RealmWrite<T> {
        return RealmWrite<T> { _ in
            guard let primaryKeyName = T.primaryKey() else {
                return T()
            }
            let object = T()
            object.setValue(primaryKey, forKey: primaryKeyName)
            return object
        }
    }
}

public extension RealmIO where T: Object {

    /// Retrieves the single instance of a given object type with the given primary key from the Realm.
    ///
    /// - Parameter key:  The primary key of the desired object.
    /// - Returns: `Read` operation
    public static func object<K>(forPrimaryKey key: K) -> RealmRead<T?> {
        return RealmRead<T?> { realm in
            realm.object(ofType: T.self, forPrimaryKey: key)
        }
    }

    /// Creates or updates a Realm object with a given value, adding it to the Realm and returning it.
    ///
    /// - Parameter value:  The value used to populate the object.
    /// - Parameter update: If `true`, the Realm will try to find an existing copy of the object (with the same primary
    /// key), and update it. Otherwise, the object will be added.
    /// - Returns: `Write` operation
    public static func create(value: Any = [:], update: Bool = false) -> RealmWrite<T> {
        return RealmWrite<T> { realm in
            return realm.create(T.self, value: value, update: update)
        }
    }
}

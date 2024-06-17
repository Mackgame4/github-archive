const mongodb = require("mongodb");
const utils = require("./server/db_utils");
const { v4: uuidv4 } = require('uuid');

let gameDb;
let authDb;

let Database = null;

global.exports('GenerateUUID', () => {
	return uuidv4();
});

const DATABASE = {
    _protected: true,
    _required: [ 'Game', 'Auth' ],
    _name: 'base',
    Game: {
        isConnected: () => {
            return !!Methods.isConnected(gameDb);
        },
        insert: (t, params, callback) => {
            return Methods.insert(gameDb, params, callback);
        },
        insertOne: (t, params, callback) => {
            return Methods.insertOne(gameDb, params, callback);
        },
        find: (t, params, callback) => {
            return Methods.find(gameDb, params, callback);
        },
        findOne: (t, params, callback) => {
            return Methods.findOne(gameDb, params, callback);
        },
        update: (t, params, callback, isUpdateOne) => {
            return Methods.update(gameDb, params, callback, isUpdateOne);
        },
        updateOne: (t, params, callback) => {
            return Methods.updateOne(gameDb, params, callback);
        },
        delete: (t, params, callback, isDeleteOne) => {
            return Methods.delete(gameDb, params, callback, isDeleteOne);
        },
        deleteOne: (t, params, callback) => {
            return Methods.deleteOne(gameDb, params, callback);
        },
        aggregateCollection: (t, params, callback) => {
            return Methods.aggregateCollection(gameDb, params, callback);
        },
        count: (t, params, callback) => {
            return Methods.count(gameDb, params, callback);
        }
    },
    Auth: {
        isConnected: () => {
            return !!Methods.isConnected(authDb);
        },
        insert: (t, params, callback) => {
            return Methods.insert(authDb, params, callback);
        },
        insertOne: (t, params, callback) => {
            return Methods.insertOne(authDb, params, callback);
        },
        find: (t, params, callback) => {
            return Methods.find(authDb, params, callback);
        },
        findOne: (t, params, callback) => {
            return Methods.findOne(authDb, params, callback);
        },
        update: (t, params, callback, isUpdateOne) => {
            return Methods.update(authDb, params, callback, isUpdateOne);
        },
        updateOne: (t, params, callback) => {
            return Methods.updateOne(authDb, params, callback);
        },
        delete: (t, params, callback, isDeleteOne) => {
            return Methods.delete(authDb, params, callback, isDeleteOne);
        },
        deleteOne: (t, params, callback) => {
            return Methods.deleteOne(authDb, params, callback);
        },
        aggregateCollection: (t, params, callback) => {
            return Methods.aggregateCollection(authDb, params, callback);
        },
        count: (t, params, callback) => {
            return Methods.count(authDb, params, callback);
        }
    }
};

AddEventHandler('onResourceStop', function(resource) {
    if (resource === GetCurrentResourceName()) {
        gameDb = null;
        authDb = null;
    }
});

AddEventHandler('Database:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents() {
    Database = exports[GetCurrentResourceName()].FetchModule('Database');
}

AddEventHandler('Core:Shared:Ready', () => {
    exports[GetCurrentResourceName()].RequestDependencies('Database', [
        'Database',
    ], (error) => {
        if (error.length > 0) return;
        RetrieveComponents();
    });
});

AddEventHandler('Database:Server:Initialize', function() {
    let DBSettings = { Auth: { Address: GetConvar('mongo_auth_address', 'mongodb://localhost'), Database: GetConvar('mongo_auth_db', 'auth') }, Game: { Address: GetConvar('mongo_game_address', 'mongodb://localhost'), Database: GetConvar('mongo_game_db', (GetConvar('gamename', 'gta5') == "rdr3" ? "redm" : "fivem")) } }
    if (Database == null || !Database.Game.isConnected() || !Database.Auth.isConnected()) {
        mongodb.MongoClient.connect(DBSettings.Auth.Address, { useNewUrlParser: true, useUnifiedTopology: true }, function (err, client) {
            if (err) return Log("Error: " + err.message);
            authDb = client.db(DBSettings.Auth.Database);
            LogTrace(`[^51^7/^52^7] Connecting to authentication database "^2${DBSettings.Auth.Database}^7".`);
            mongodb.MongoClient.connect(DBSettings.Game.Address, { useNewUrlParser: true, useUnifiedTopology: true }, function (err, client) {
                if (err) return Log("Error: " + err.message);
                gameDb = client.db(DBSettings.Game.Database);
                LogTrace(`[^52^7/^52^7] Connecting to game database "^2${DBSettings.Game.Database}^7".`);
                emit('Database:Server:Ready', DATABASE);
            });
        });
    } else {
        emit('Database:Server:Ready');
    }
});

function LogTrace(log) {
    emit(`Logger:Info`, 'Database', log, { console: true });
}

function Log(log, flagOverride = null) {
    emit(`Logger:Error`, 'Database', log, flagOverride == null ? { console: true, database: true, file: true, discord: { style: 'error' } } : flagOverride);
}

function checkDatabaseReady() {
    if (!gameDb || !authDb) {
        Log(`Database is not connected.`, { console: true });
        return false;
    }
    return true;
}

function checkParams(params) {
    return params !== null && typeof params === 'object';
}

function getParamsCollection(db, params) {
    if (!params.collection) return;
    return db.collection(params.collection)
}

const Methods = {
    isConnected: (db) => {
        return !!db;
    },
    insert: (db, params, callback) => {
        if (!checkDatabaseReady()) return;
        if (!checkParams(params)) return Log(`insert: Invalid params object.`);

        let collection = getParamsCollection(db, params);
        if (!collection) return Log(`insert: Invalid collection "${params.collection}"`);

        let documents = params.documents;
        if (!documents || !Array.isArray(documents))
            return Log(`insert: Invalid 'params.documents' value. Expected object or array of objects.`);

        const options = utils.safeObjectArgument(params.options);

        collection.insertMany(documents, options, (err, result) => {
            if (err) {
                Log(`insert: Error "${err.message}".`);
                utils.safeCallback(callback, false, err.message);
                return;
            }
            let arrayOfIds = [];
            // Convert object to an array
            for (let key in result.insertedIds) {
                if (result.insertedIds.hasOwnProperty(key)) {
                    arrayOfIds[parseInt(key)] = result.insertedIds[key].toString();
                }
            }

            utils.safeCallback(callback, true, result.insertedCount, arrayOfIds);
        });
        process._tickCallback();
    },
    insertOne: (db, params, callback) => {
        if (checkParams(params)) {
            params.documents = [params.document];
            params.document = null;
        }
        return Methods.insert(db, params, callback)
    },
    find: (db, params, callback) => {
        if (!checkDatabaseReady()) return;
        if (!checkParams(params)) return Log(`find: Invalid params object.`);

        let collection = getParamsCollection(db, params);
        if (!collection) return Log(`insert: Invalid collection "${params.collection}"`);

        const query = utils.safeObjectArgument(params.query);
        const options = utils.safeObjectArgument(params.options);

        let cursor = collection.find(query, options);
        if (params.limit) cursor = cursor.limit(params.limit);
        cursor.toArray((err, documents) => {
            if (err) {
                Log(`find: Error "${err.message}".`);
                utils.safeCallback(callback, false, err.message);
                return;
            };
            utils.safeCallback(callback, true, utils.exportDocuments(documents));
        });
        process._tickCallback();
    },
    findOne: (db, params, callback) => {
        if (checkParams(params)) params.limit = 1;
        return Methods.find(db, params, callback);
    },
    update: (db, params, callback, isUpdateOne) => {
        if (!checkDatabaseReady()) return;
        if (!checkParams(params)) return Log(`update: Invalid params object.`);

        let collection = getParamsCollection(db, params);
        if (!collection) return Log(`insert: Invalid collection "${params.collection}"`);

        query = utils.safeObjectArgument(params.query);
        update = utils.safeObjectArgument(params.update);
        options = utils.safeObjectArgument(params.options);

        const cb = (err, res) => {
            if (err) {
                Log(`update: Error "${err.message}".`);
                utils.safeCallback(callback, false, err.message);
                return;
            }
            utils.safeCallback(callback, true, res.result.nModified);
        };
        isUpdateOne ? collection.updateOne(query, update, options, cb) : collection.updateMany(query, update, options, cb);
        process._tickCallback();
    },
    updateOne: (db, params, callback) => {
        return Methods.update(db, params, callback, true);
    },
    delete: (db, params, callback, isDeleteOne) => {
        if (!checkDatabaseReady()) return;
        if (!checkParams(params)) return Log(`delete: Invalid params object.`);

        let collection = getParamsCollection(db, params);
        if (!collection) return Log(`insert: Invalid collection "${params.collection}"`);

        const query = utils.safeObjectArgument(params.query);
        const options = utils.safeObjectArgument(params.options);

        const cb = (err, res) => {
            if (err) {
                Log(`delete: Error "${err.message}".`);
                utils.safeCallback(callback, false, err.message);
                return;
            }
            utils.safeCallback(callback, true, res.result.n);
        };
        isDeleteOne ? collection.deleteOne(query, options, cb) : collection.deleteMany(query, options, cb);
        process._tickCallback();
    },
    deleteOne: (db, params, callback) => {
        return Methods.delete(db, params, callback, true);
    },
    aggregateCollection: (db, params, callback) => {
        if (!checkDatabaseReady()) return;
        if (!checkParams(params)) return Log(`aggregateCollection: Invalid params object.`);

        let collection = getParamsCollection(params);
        if (!collection) return Log(`aggregateCollection: Invalid collection "${params.collection}"`);

        const aggregation = utils.safeAggregateArray(params.steps)

        try {
            const cursor = collection.aggregate(aggregation)
            const documents = await cursor.toArray();
            return callbackOrElse(callback, true, utils.exportDocuments(documents))
        } catch (err) {
            Log(`aggregateCollection: Error "${err.message}".`);
            return callbackOrElse(callback, false, err.message)
        }
    },
    count: (db, params, callback) => {
        if (!checkDatabaseReady()) return;
        if (!checkParams(params)) return Log(`count: Invalid params object.`);

        let collection = getParamsCollection(db, params);
        if (!collection) return Log(`insert: Invalid collection "${params.collection}"`);

        const query = utils.safeObjectArgument(params.query);
        const options = utils.safeObjectArgument(params.options);

        collection.countDocuments(query, options, (err, count) => {
            if (err) {
                Log(`count: Error "${err.message}".`);
                utils.safeCallback(callback, false, err.message);
                return;
            }
            utils.safeCallback(callback, true, count);
        });
        process._tickCallback();
    }
}
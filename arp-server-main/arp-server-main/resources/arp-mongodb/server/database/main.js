const { NMongo } = require('./server/database/mongo');

const mainURL = GetConvar('arp_db', 'mongodb://localhost:27017');
const mainName = GetConvar('arp_dbName', 'fivem');

const db = new NMongo(mainURL, mainName, (success) => {
    if (success) {
        console.log(`^2Succeeded Connection to Game Database [${mainName}]^7`);
    } else {
        console.log(`^1Failed Connection to Game Database [${mainName}]^7`);
    }
});

exports('isConnected', () => {
    return db.isConnected();
})

exports('find', (collection, query, options, limit, cb) => {
    if (Array.isArray(query)) {
        query = {}
    }
    if (Array.isArray(options)) {
        options = {}
    }
    DBFind(collection, query, options, limit, (data) => {
        cb(data);
    });
});  

exports('findOne', (collection, query, options, cb) => {
    if (Array.isArray(query)) {
        query = {}
    }
    if (Array.isArray(options)) {
        options = {}
    }
    DBFindOne(collection, query, options, (data) => {
        cb(data);
    });
});  

exports('insert', (collection, documents, options, cb) => {
    if (Array.isArray(options)) {
        options = {}
    }
    DBInsert(collection, documents, options, (data) => {
        cb(data);
    });
}); 

exports('insertOne', (collection, documents, options, cb) => {
    if (Array.isArray(options)) {
        options = {}
    }
    DBInsertOne(collection, documents, options, (data) => {
        cb(data);
    });
}); 

exports('update', (collection, query, update, options, cb) => {
    if (Array.isArray(query)) {
        query = {}
    }
    if (Array.isArray(update)) {
        update = {}
    }
    if (Array.isArray(options)) {
        options = {}
    }
    DBUpdate(collection, query, update, options, (data) => {
        cb(data);
    });
}); 

exports('updateOne', (collection, query, update, options, cb) => {
    if (Array.isArray(query)) {
        query = {}
    }
    if (Array.isArray(update)) {
        update = {}
    }
    if (Array.isArray(options)) {
        options = {}
    }
    DBUpdateOne(collection, query, update, options, (data) => {
        cb(data);
    });
}); 

exports('count', (collection, query, options, cb) => {
    if (Array.isArray(query)) {
        query = {}
    }
    if (Array.isArray(options)) {
        options = {}
    }
    DBCount(collection, query, options, (data) => {
        cb(data);
    });
}); 

exports('delete', (collection, query, options, cb) => {
    if (Array.isArray(query)) {
        query = {}
    }
    if (Array.isArray(options)) {
        options = {}
    }
    DBDelete(collection, query, options, (data) => {
        cb(data);
    });
}); 

exports('deleteOne', (collection, query, options, cb) => {
    if (Array.isArray(query)) {
        query = {}
    }
    if (Array.isArray(options)) {
        options = {}
    }
    DBDeleteOne(collection, query, options, (data) => {
        cb(data);
    });
}); 

exports('aggregate', (collection, query, options, cb) => {
    if (Array.isArray(options)) {
        options = {}
    }
    DBAggregate(collection, query, options, (data) => {
        cb(data);
    });
}); 

async function DBFind(collection, query, options, limit, callback) {
    if (db.isConnected()) {
        const results = await db.find(collection, query, options, limit);
        callback(results);
    } else {
        callback(false);
    }
}

async function DBFindOne(collection, query, options, callback) {
    if (db.isConnected()) {
        const results = await db.findOne(collection, query, options);
        callback(results);
    } else {
        callback(false);
    }
}

async function DBInsert(collection, documents, options, callback) {
    if (db.isConnected()) {
        const results = await db.insert(collection, documents, options);
        callback(results);
    } else {
        callback(false);
    }
}

async function DBInsertOne(collection, document, options, callback) {
    if (db.isConnected()) {
        const results = await db.insertOne(collection, document, options);
        callback(results);
    } else {
        callback(false);
    }
}

async function DBUpdate(collection, query, update, options, callback) {
    if (db.isConnected()) {
        const results = await db.update(collection, query, update, options);
        callback(results);
    } else {
        callback(false);
    }
}

async function DBUpdateOne(collection, query, update, options, callback) {
    if (db.isConnected()) {
        const results = await db.updateOne(collection, query, update, options);
        callback(results);
    } else {
        callback(false);
    }
}

async function DBCount(collection, query, options, callback) {
    if (db.isConnected()) {
        const results = await db.count(collection, query, options);
        callback(results);
    } else {
        callback(false);
    }
}

async function DBDelete(collection, query, options, callback) {
    if (db.isConnected()) {
        const results = await db.delete(collection, query, options);
        callback(results);
    } else {
        callback(false);
    }
}

async function DBDeleteOne(collection, query, options, callback) {
    if (db.isConnected()) {
        const results = await db.deleteOne(collection, query, options);
        callback(results);
    } else {
        callback(false);
    }
}

async function DBAggregate(collection, query, options, callback) {
    if (db.isConnected()) {
        const results = await db.aggregate(collection, query, options);
        callback(results);
    } else {
        callback(false);
    }
}
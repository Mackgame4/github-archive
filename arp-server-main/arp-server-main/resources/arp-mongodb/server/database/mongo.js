const mongodb = require("mongodb");

const NMongo = class {
    constructor(url, dbName, callback) {
        this.dataBaseUrl = url;
        this.dataBaseName = dbName;
        this.connected = false;
        mongodb.MongoClient.connect(this.dataBaseUrl, { useNewUrlParser: true, useUnifiedTopology: true }, (err, client) => {
            if (err) {
                callback(false);
            } else {
                this.db = client.db(this.dataBaseName);
                this.connected = true;
                callback(true);
            }
        });
    }
    isConnected() {
        return this.connected;
    }
    /**
     * MongoDB Find Documents
     * @param {String} collection 
     * @param {Object} query 
     * @param {Object} options 
     * @param {Number} limit 
     */
    find(collection, query = {}, options = {}, limit = 0) {
        return new Promise(res => {
            if (this.connected && this.db) {
                const collect = this.db.collection(collection);
                if (collect) {
                    let result = collect.find(query, options);
                    if (limit && !isNaN(limit)) {
                        result = result.limit(limit);
                    }
                    result.toArray((err, documents) => {
                        if (!err) {
                            res({
                                success: true,
                                docs: exportDocuments(documents),
                            });
                        } else {
                            res({
                                success: false,
                                docs: false,
                            });
                        }
                    });
                }
            } else {
                res({ success: false, docs: false });
            }
        });
    }
    /**
     * MongoDB Find One Document
     * @param {String} collection 
     * @param {Object} query 
     * @param {Object} options 
     */
    findOne(collection, query = {}, options = {}) {
        return this.find(collection, query, options, 1);
    }
    /**
     * MongoDB Insert Documents
     * @param {String} collection 
     * @param {Object} query 
     * @param {Object} options 
     */
    insert(collection, documents, options = {}) {
        return new Promise(res => {
            if (this.connected && this.db) {
                const collect = this.db.collection(collection);
                if (collect && documents) {
                    collect.insertMany(documents, options, (err, result) => {
                        if (!err && result) {
                            res({
                                success: true,
                                inserted: exportDocuments(result.ops)
                            })
                        } else {
                            res({
                                success: false,
                                docs: false,
                            });
                        }
                    });
                }
            } else {
                res({ success: false, inserted: false });
            }
        });
    }
    /**
     * MongoDB Insert One Document
     * @param {String} collection 
     * @param {Object} query 
     * @param {Object} options 
     */
    insertOne(collection, document, options = {}) {
        const documents = [ document ];
        return this.insert(collection, documents, options);
    }
    /**
     * MongoDB Update Documents
     * @param {String} collection 
     * @param {Object} query 
     * @param {Object} update 
     * @param {Object} options 
     */
    update(collection, query = {}, update = {}, options = {}, one = false) {
        return new Promise(res => {
            if (this.connected && this.db) {
                const collect = this.db.collection(collection);
                if (collect) {
                    if (one) {
                        collect.updateOne(query, update, options, (err, result) => {
                            if (!err) {
                                res({ success: true, updated: result.result.nModified });
                            } else {
                                res({ success: false, updated: false });
                            }
                        });
                    } else {
                        collect.updateMany(query, update, options, (err, result) => {
                            if (!err) {
                                res({ success: true, updated: result.result.nModified });
                            } else {
                                res({ success: false, updated: false });
                            }
                        });
                    }
                }
            } else {
                res({ success: false, updated: false });
            }
        });
    }
    /**
     * MongoDB Update One Document
     * @param {String} collection 
     * @param {Object} query 
     * @param {Object} update 
     * @param {Object} options 
     */
    updateOne(collection, query = {}, update = {}, options = {}) {
        return this.update(collection, query, update, options, true);
    }
    /**
     * MongoDB Count Documents
     * @param {String} collection 
     * @param {Object} query 
     * @param {Object} options 
     */
    count(collection, query = {}, options = {}) {
        return new Promise(res => {
            if (this.connected && this.db) {
                const collect = this.db.collection(collection);
                if (collect) {
                    collect.countDocuments(query, options, (err, count) => {
                        if (!err) {
                            res({ success: true, count: count });
                        } else {
                            res({ success: false, count: false });
                        }
                    });
                }
            } else {
                res({ success: false, count: false });
            }
        });
    }
    /**
     * MongoDB Delete Documents
     * @param {String} collection 
     * @param {Object} query 
     * @param {Object} options 
     */
    delete(collection, query = {}, options = {}, one = false) {
        return new Promise(res => {
            if (this.connected && this.db) {
                const collect = this.db.collection(collection);
                if (collect) {
                    if (one) {
                        collect.deleteOne(query, options, (err, result) => {
                            if (!err) {
                                res({ success: true, deleted: result.result.n });
                            } else {
                                res({ success: false, deleted: false });
                            }
                        });
                    } else {
                        collect.deleteMany(query, options, (err, result) => {
                            if (!err) {
                                res({ success: true, deleted: result.result.n });
                            } else {
                                res({ success: false, deleted: false });
                            }
                        });
                    }
                }
            } else {
                res({ success: false, deleted: false });
            }
        });
    }
    /**
     * MongoDB Delete One Document
     * @param {String} collection 
     * @param {Object} query 
     * @param {Object} options 
     */
    deleteOne(collection, query = {}, options = {}) {
        return this.delete(collection, query, options, true);
    }
    aggregate(collection, query = {}, options = {}) {
        return new Promise(res => {
            if (this.connected && this.db) {
                const collect = this.db.collection(collection);
                if (collect) {
                    let result = collect.aggregate(query, options)
                    result.toArray((err, documents) => {
                        if (!err) {
                            res({ success: true, docs: documents })
                        } else {
                            res({ success: false, docs: false })
                        }
                    });
                }
            } else {
                res({ success: false, docs: false });
            }
        });
    }
}

function exportDocument(document) {
    if (!document) return;
    if (document._id && typeof document._id !== "string") {
        document._id = document._id.toString();
    }
    return document;
};

function exportDocuments(documents) {
    if (!Array.isArray(documents)) return;
    return documents.map((document => exportDocument(document)));
}

module.exports = {
    NMongo
}
# ARP MongoDB functions

All of these functions are part of the `DB` Component

### Connection

```lua
DB:IsConnected() -- returns boolean if the database is connected
```
### Finding Documents

```lua
-- Finding Multiple

local res = DB:Find(collection, query, options, limit)
-- res.success -- if the operation was successful or not (boolean)
-- res.docs -- all of the found docs in a tbl
```
```lua
-- Finding One

local res = DB:FindOne(collection, query, options)
-- res.success -- if the operation was successful or not (boolean)
-- res.docs -- all of the found docs in a tbl
```
### Inserting Documents
```lua
-- Insert Multiple

local res = DB:Insert(collection, documents, options) -- Insert Multiple
-- res.success -- if the operation was successful or not (boolean)
-- res.inserted -- all of the inserted docs in a tbl
```
```lua
-- Insert One

local res = DB:InsertOne(collection, document, options) -- Insert One
-- res.success -- if the operation was successful or not (boolean)
-- res.inserted -- all of the inserted docs in a tbl
```
### Document Updating

```lua
-- Update Multiple

local res = DB:Update(collection, query, update, options)
-- res.success -- if the operation was successful or not (boolean)
-- res.updated -- the amount of docs updated (number)
```
```lua
-- Update One

local res = DB:UpdateOne(collection, query, update, options)
-- res.success -- if the operation was successful or not (boolean)
-- res.updated -- the amount of docs updated (number)
```
### Document Counting
```lua
-- Count (Multiple Obviously)

local res = DB:Count(collection, query, options)
-- res.success -- if the operation was successful or not (boolean)
-- res.count -- the amount counted (number)
```
### Document Deleting
```lua
-- Delete Multiple

local res = DB:Delete(collection, query, options)
-- res.success -- if the operation was successful or not (boolean)
-- res.deleted -- the amount deleted (number)
```
```lua
-- Delete One

local res = DB:DeleteOne(collection, query, options)
-- res.success -- if the operation was successful or not (boolean)
-- res.deleted -- the amount deleted (number)
```

### Aggregation
```lua
-- Aggregate - You basically need a PhD for using this

local res = DB:Aggregate(collection, query, options)
-- res.success -- if the operation was successful or not (boolean)
-- res.docs -- document results
```

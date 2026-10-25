CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    reference TEXT NOT NULL UNIQUE CHECK (length(trim(reference)) > 0),
    name TEXT NOT NULL CHECK (length(trim(name)) > 0),
    stock INTEGER NOT NULL CHECK (stock >= 0)
);


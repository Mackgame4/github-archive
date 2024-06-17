# Shared Utils - Functions

## Table Related Functions
```lua
-- Printing Tables for easy reading :)
ARP.PrintTable({ something = true })

-- Get the length of a table (that is non array-like)
ARP.GetTableLength(table)

-- Get all keys from a table
ARP.GetTableKeys(table)

-- Check a table if a value is within it
ARP.DoesTableHaveValue(table, elem)

-- Also get the position of a value in an array-like/ordered table
ARP.GetPositionInOrderedTable(table, elem)
-- There is also the same function for non ordered/object-like tables
ARP.GetPositionInTable(table, elem)

-- Get a random element from an ordered (array-like) table
ARP.RandomFromArrayTable(table)
```

## String Related Functions

```lua
-- String Splitting - this is added to the normal string lua class
string.split(string, delimiter)
-- Convert string to a table
ARP.StringToTable(string)

-- Get a random value from a given string where the length is the amount of random characters
ARP.RandomFromString(length, string)

-- Check if a string starts with a value
ARP.StringStartsWith(string, startsWith)
```

## Math Related Functions

```lua
-- Round a number to a certain amount of decimals
ARP.Round(number, decimalPlaces)

-- Round all values of a vector to a certain amount of decimals
ARP.RoundVector3(vector, decimalPlaces)

-- Get Decent Random Numbers
ARP.RandomNumber(min, max)

-- Round a number to the closest even
ARP.RoundEven(number)
```

ItemData = {
    ['popcorn'] = {
        item = 'popcorn',
        name = 'Popcorn',
        weight = 1.0,
        max = 1,
        image = 'popcorn.png',
        description = 'A bucket of delicious popcorn.',
        degradation = true, --
        degradeOnUse = 25,
        usable = true,
        removeOnUse = false,
        metaToDisplay = false,
        canMerge = false -- for meta purposes - if you want REALLY persistent data like on a gun then well this should be fault, that wouldn't be possible probably since the gun would have a max of one and would not be able to stack
                -- this is for very ODD use cases...
    },
    ['cheese'] = {
        item = 'cheese',
        name = 'Cheese Sandwich',
        weight = 1.0,
        max = 2,
        image = 'cheesesandwich.png',
        description = 'A cheese sandwich',
        usable = true,
        removeOnUse = true,
        metaToDisplay = false,
        canMerge = true,
    }
}
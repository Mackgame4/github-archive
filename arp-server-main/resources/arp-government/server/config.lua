--[[
    ? Types
    1 - Police
    2 - Medical
    3 - Law/Justice

    * The highest rank is 0 - 0 is always the highest level, lowest being the highest number
]]

_govTypes = {
    [1] = 'police',
    [2] = 'police',
    [4] = 'medical',
    [5] = 'medical',
    [6] = 'law',
    [7] = 'law',
}

_departments = {
    [1] = {
        type = 1,
        name = 'Los Santos Police Department',
        abbr = 'LSPD',
        ranks = {
            [0] = { name = 'Chief', abbr = 'Chf.' },
            [1] = { name = 'Deputy Chief', abbr = 'Dep. Chf.' },
            [2] = { name = 'Captain', abbr = 'Capt.' },
            [3] = { name = 'Lieutenant', abbr = 'Lt.' },
            [4] = { name = 'Sergeant', abbr = 'Sgt.' },
            [5] = { name = 'Senior Officer', abbr = 'Senior Off.' },
            [6] = { name = 'Officer', abbr = 'Off.' },
            [7] = { name = 'Cadet', abbr = 'Cdt.' }
        }
    },
    [2] = {
        type = 1,
        name = 'Los Santos County Sheriff\'s Department',
        abbr = 'LSSD',
        ranks = {
            [0] = { name = 'Sheriff' },
            [1] = { name = 'Undersheriff' },
            [2] = { name = 'Captain', abbr = 'Capt.' },
            [3] = { name = 'Lieutenant', abbr = 'Lt.' },
            [4] = { name = 'Sergeant', abbr = 'Sgt.' },
            [5] = { name = 'Senior Deputy', abbr = 'Senior Dep.' },
            [6] = { name = 'Deputy', abbr = 'Dep.' },
            [7] = { name = 'Cadet', abbr = 'Cdt.' }
        }
    },

    -- [4] = {
    --     type = 2,
    --     name = 'Los Santos Fire Department',
    --     abbr = 'LSFD',
    -- },
    -- [5] = {
    --     type = 2,
    --     name = 'San Andreas Hospital Services',
    --     abbr = 'SAHS',
    -- },
    -- [6] = {
    --     type = 3,
    --     name = 'Department of Justice',
    --     abbr = 'DOJ',
    -- },
    -- [7] = {
    --     type = 3,
    --     name = 'Los Santos County District Attorney\'s Office',
    --     abbr = 'LSCDA',
    -- }
}
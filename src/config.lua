--!strict

local types = require(script.Parent.types)

local config: types.Config =  {
    --[=[
        silences errors during a value change method
    ]=]
    SILENCE_ERRORS = false,

    --[=[
        checks if the new value equals the last value before firing the changed\
        signal (consider changing to false if a state is a large table)
    ]=]
    CHECK_IS_EQUAL_BEFORE_UPDATE = true,

    --[=[
        max number of indices in value history, must be greater than or equal\
        to 1
    ]=]
    MAX_HISTORY_LENGTH = 5000,

    --[=[
        the max size of value history after being json encoded, ignored if\
        value history has 1 or less index
    ]=]
    MAX_HISTORY_SIZE = 1000
}

return config
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
        clones the value to last value before running the value change method\
        (consider changing to false if a state is a large table)
    ]=]
    CLONE_VALUE_TO_LAST_VALUE = true
}

return config
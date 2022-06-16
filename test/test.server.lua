

local replicatedStorage = game:GetService("ReplicatedStorage")

local testEz = require(replicatedStorage.modules.TestEZ)

local result = testEz.TestBootstrap:run(
    {replicatedStorage.accord},
    testEz.Reporters.TextReporter
)

local accord = require(replicatedStorage.accord)
print("accord after tests: ", accord)
accord:DestroyAll()
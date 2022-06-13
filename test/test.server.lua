

local replicatedStorage = game:GetService("ReplicatedStorage")

local testEz = require(replicatedStorage.Packages.testez)

local result = testEz.TestBootstrap:run(
    {replicatedStorage.accord},
    testEz.Reporters.TextReporter
)

print(result)

local accord = require(replicatedStorage.accord)
print("accord: ", accord)
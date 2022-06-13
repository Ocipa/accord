return function()
    local accord = require(script.Parent)

    local random = Random.new()

    it("new state", function()
        local name = tostring(random:NextNumber())
        accord:NewState(name, 0)
        expect(accord[name]).to.be.ok()
    end)

    it("new state with default value", function()
        local name = tostring(random:NextNumber())
        local value = random:NextNumber()
        accord:NewState(name, value)
        expect(accord[name].value).to.equal(value)
    end)

    describe("value change method", function()
        it("create", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            local worked = false

            accord[name].test = function(self)
                worked = true
            end
            accord[name]:test()

            expect(worked).to.be.ok()
        end)

        it("changing value", function()
            local name = tostring(random:NextNumber())
            local value = random:NextNumber()
            accord:NewState(name, 0)
            
            accord[name].test = function(self, number: number)
                self.value += number
            end
            accord[name]:test(value)

            expect(accord[name]._lastValue).to.equal(0)
            expect(accord[name].value).to.equal(value)
        end)
    end)

    describe("connections", function()
        it("connect", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            local connection = accord[name]:Connect(function()
            end)

            expect(connection and connection.Connected).to.be.ok()
        end)

        it("connect once", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            local num = 0
            accord[name]:ConnectOnce(function()
                num += 1
            end)

            expect(num).to.equal(0)
            accord[name]._signal:Fire()
            expect(num).to.equal(1)
            accord[name]._signal:Fire()
            expect(num).to.equal(1)
        end)
    end)
end
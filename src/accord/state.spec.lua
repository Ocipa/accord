return function()
    local accord = require(script.Parent)

    describe("state", function()
        it("new state", function()
            local name = tostring(math.random())
            accord:newState(name, 0)
            expect(accord[name]).to.be.ok()
        end)

        it("new state with default value", function()
            local name = tostring(math.random())
            local value = math.random(1, 999999)
            accord:newState(name, value)
            expect(accord[name].value).to.equal(value)
        end)

        it("create value change method", function()
            local name = tostring(math.random())
            accord:newState(name, 0)

            local worked = false

            accord[name].test = function(self)
                worked = true
            end
            accord[name]:test()

            expect(worked).to.be.ok()
        end)

        it("value change method, changing value", function()
            local name = tostring(math.random())
            local value = math.random(1, 999999)
            accord:newState(name, 0)
            
            accord[name].test = function(self, number: number)
                self.value += number
            end
            accord[name]:test(value)

            expect(accord[name]._lastValue).to.equal(0)
            expect(accord[name].value).to.equal(value)
        end)

        it("connect to a state", function()
            local name = tostring(math.random())
            accord:newState(name, 0)

            local connection = accord[name]:Connect(function()
            end)

            expect(connection and connection.Connected).to.be.ok()
        end)
    end)
end
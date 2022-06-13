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

        it("disconnect all", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            expect(accord[name]._signal._head).never.to.be.ok()

            local connection = accord[name]:Connect(function()
            end)

            expect(accord[name]._signal._head).to.be.ok()

            accord[name]:DisconnectAll()
            expect(accord[name]._signal._head).never.to.be.ok()
            expect(connection and connection.Connected).never.to.be.equal(true)
        end)
    end)

    it("destroy", function()
        local name1 = tostring(random:NextNumber())
        local name2 = tostring(random:NextNumber())
        accord:NewState(name1, 0)
        accord:NewState(name2, 0)

        expect(accord[name1]).to.be.ok()
        expect(accord[name2]).to.be.ok()

        accord[name1]:Destroy()

        expect(accord[name1]).never.to.be.ok()
        expect(accord[name2]).to.be.ok()
    end)
end
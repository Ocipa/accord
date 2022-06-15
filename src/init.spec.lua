return function()
    local accord = require(script.Parent)

    local random = Random.new()

    it("nonexistent store", function()
        expect(accord[tostring(random:NextNumber())]).never.to.be.ok()
    end)

    describe("connections", function()
        it("connect", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            accord[name].imp = function(self)
                self.value += 1
            end

            accord:Connect(function(stateName, value, lastValue)
                if stateName == name then
                    expect(value).to.equal(1)
                    expect(lastValue).to.equal(0)
                end
            end)

            accord[name]:imp()
        end)

        it("connect once", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            accord[name].imp = function(self)
                self.value += 1
            end

            accord:ConnectOnce(function(stateName, value, lastValue)
                if stateName == name then
                    expect(value).to.equal(1)
                    expect(lastValue).to.equal(0)
                end
            end)

            accord[name]:imp()
            accord[name]:imp()
        end)

        it("disconnect all", function()
            local connection = accord:Connect(function(...)
            end)

            expect(connection.Connected).to.equal(true)

            accord:DisconnectAll()

            expect(connection.Connected).never.equal(true)
        end)
    end)

    it("destroy state", function()
        local name1 = tostring(random:NextNumber())
        local name2 = tostring(random:NextNumber())
        accord:NewState(name1, 0)
        accord:NewState(name2, 0)

        expect(accord[name1]).to.be.ok()
        expect(accord[name2]).to.be.ok()

        accord:DestroyState(name1)

        expect(accord[name1]).never.to.be.ok()
        expect(accord[name2]).to.be.ok()
    end)
end
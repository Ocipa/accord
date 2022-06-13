return function()
    local accord = require(script.Parent)

    local random = Random.new()

    it("nonexistent store", function()
        expect(accord[tostring(random:NextNumber())]).never.to.be.ok()
    end)

    describe("connections", function()
        it("connect", function()
            local name = tostring(random:NextNumber())
            accord:newState(name, 0)

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
            accord:newState(name, 0)

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
    end)
end
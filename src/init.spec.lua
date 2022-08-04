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

            accord:Connect(function(stateName, value)
                if stateName == name then
                    expect(value).to.equal(1)
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

            accord:ConnectOnce(function(stateName, value)
                if stateName == name then
                    expect(value).to.equal(1)
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

    describe("destroy", function()
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

        it("destroy all", function()
            local name1 = tostring(random:NextNumber())
            local name2 = tostring(random:NextNumber())
            accord:NewState(name1, 0)
            accord:NewState(name2, 0)
    
            expect(accord[name1]).to.be.ok()
            expect(accord[name2]).to.be.ok()
    
            accord:DestroyAll()
    
            expect(accord[name1]).never.to.be.ok()
            expect(accord[name2]).never.to.be.ok()
        end)
    end)

    describe("local state config", function()

        --[[
            can't test config["SILENCE_ERRORS"] since the errors are caught
            before TestEz expect() can catch them
        --]]

        it("CHECK_IS_EQUAL_BEFORE_UPDATE is true", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0, {["CHECK_IS_EQUAL_BEFORE_UPDATE"] = true})

            accord[name].inc = function(self, num)
                self.value += num
            end

            local num = 0
            accord[name]:Connect(function(value)
                num += 1
            end)

            accord[name]:inc(1)
            expect(num).to.equal(1)
            accord[name]:inc(0)
            expect(num).to.equal(1)
            expect(accord[name]:GetValue()).to.equal(1)
        end)

        it("CHECK_IS_EQUAL_BEFORE_UPDATE is false", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0, {["CHECK_IS_EQUAL_BEFORE_UPDATE"] = false})

            accord[name].inc = function(self, num)
                self.value += num
            end

            local num = 0
            accord[name]:Connect(function(value)
                num += 1
            end)

            accord[name]:inc(1)
            expect(num).to.equal(1)
            accord[name]:inc(0)
            expect(num).to.equal(2)
            expect(accord[name]:GetValue()).to.equal(1)
        end)

        it("MAX_HISTORY_LENGTH", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0, {["MAX_HISTORY_LENGTH"] = 0})

            accord[name].inc = function(self)
                self.value += 1
            end

            accord[name]:inc()
            accord[name]:inc()
            accord[name]:RelativeRescind(-2)
            expect(accord[name]:GetValue()).to.equal(1)
        end)

        it("MAX_HISTORY_SIZE", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0, {["MAX_HISTORY_SIZE"] = 0})

            accord[name].inc = function(self)
                self.value += 1
            end

            accord[name]:inc()
            accord[name]:inc()
            accord[name]:RelativeRescind(-2)
            expect(accord[name]:GetValue()).to.equal(1)
        end)
    end)
end
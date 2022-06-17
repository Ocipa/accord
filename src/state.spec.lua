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
        expect(accord[name]:GetValue()).to.equal(value)
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

            expect(accord[name]:GetLastValue()).to.equal(0)
            expect(accord[name]:GetValue()).to.equal(value)
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
            expect(connection and connection.Connected).never.to.equal(true)
        end)
    end)

    describe("get value", function()
        it("GetValue", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            accord[name].inc = function(self)
                self.value += 1
            end

            expect(accord[name]:GetValue()).to.equal(0)
            accord[name]:inc()
            expect(accord[name]:GetValue()).to.equal(1)
        end)

        it("GetLastValue", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            accord[name].inc = function(self)
                self.value += 1
            end

            expect(accord[name]:GetLastValue()).to.equal(0)
            accord[name]:inc()
            expect(accord[name]:GetLastValue()).to.equal(0)
            accord[name]:inc()
            expect(accord[name]:GetLastValue()).to.equal(1)
        end)
    end)

    describe("isEqual", function()
        it("nil", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            accord[name].set = function(self, num: number?)
                self.value = num
            end

            local num = 0
            local connection = accord[name]:Connect(function()
                num += 1
            end)

            expect(num).to.equal(0)
            accord[name]:set(nil)
            expect(num).to.equal(1)
            accord[name]:set(nil)
            expect(num).to.equal(1)
        end)

        it("string", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, "a")

            accord[name].con = function(self, str: string)
                self.value = self.value .. str
            end

            local num = 0
            local connection = accord[name]:Connect(function()
                num += 1
            end)

            expect(num).to.equal(0)
            accord[name]:con("b")
            expect(num).to.equal(1)
            accord[name]:con("")
            expect(num).to.equal(1)
        end)

        it("number", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            accord[name].imp = function(self, number: number)
                self.value += number
            end

            local num = 0
            local connection = accord[name]:Connect(function()
                num += 1
            end)

            expect(num).to.equal(0)
            accord[name]:imp(1)
            expect(num).to.equal(1)
            accord[name]:imp(0)
            expect(num).to.equal(1)
        end)

        it("boolean", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, true)

            accord[name].set = function(self, bool: boolean)
                self.value = bool
            end

            local num = 0
            local connection = accord[name]:Connect(function()
                num += 1
            end)

            expect(num).to.equal(0)
            accord[name]:set(false)
            expect(num).to.equal(1)
            accord[name]:set(false)
            expect(num).to.equal(1)
        end)

        it("table", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, {0, {"a", "b"}, false})

            accord[name].set = function(self, tble)
                self.value = tble
            end

            local num = 0
            local connection = accord[name]:Connect(function()
                num += 1
            end)

            expect(num).to.equal(0)
            accord[name]:set({0, {"c", {"b"}}, true})
            expect(num).to.equal(1)
            accord[name]:set({0, {"c", {"b"}}, true})
            expect(num).to.equal(1)
        end)

        it("table and empty table", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, {})

            accord[name].set = function(self, tble)
                self.value = tble
            end

            local num = 0
            local connection = accord[name]:Connect(function()
                num += 1
            end)

            expect(num).to.equal(0)
            accord[name]:set({{"a"}, {"b"}})
            expect(num).to.equal(1)
            accord[name]:set({{"a"}, {"b"}})
            expect(num).to.equal(1)
        end)

        it("function", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, function() end)

            accord[name].set = function(self, fnc)
                self.value = fnc
            end

            local num = 0
            local connection = accord[name]:Connect(function()
                num += 1
            end)

            expect(num).to.equal(0)
            accord[name]:set(function() end)
            expect(num).to.equal(1)
            accord[name]:set(accord[name]:GetValue())
            expect(num).to.equal(1)
        end)

        it("thread", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, coroutine.create(function() end))

            accord[name].set = function(self, thread)
                self.value = thread
            end

            local num = 0
            local connection = accord[name]:Connect(function()
                num += 1
            end)

            expect(num).to.equal(0)
            accord[name]:set(coroutine.create(function() end))
            expect(num).to.equal(1)
            accord[name]:set(accord[name]:GetValue())
            expect(num).to.equal(1)
        end)

        it("userdata", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, newproxy(false))

            accord[name].set = function(self, uData)
                self.value = uData
            end

            local num = 0
            local connection = accord[name]:Connect(function()
                num += 1
            end)

            expect(num).to.equal(0)
            accord[name]:set(newproxy(false))
            expect(num).to.equal(1)
            accord[name]:set(accord[name]:GetValue())
            expect(num).to.equal(1)
        end)
    end)

    describe("relative rescind", function()
        it("go back in history", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            accord[name].inc = function(self)
                self.value += 1
            end

            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            expect(accord[name]:GetValue()).to.equal(5)

            accord[name]:RelativeRescind(-3)
            expect(accord[name]:GetValue()).to.equal(2)
        end)

        it("go forward in history", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            accord[name].inc = function(self)
                self.value += 1
            end

            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            expect(accord[name]:GetValue()).to.equal(5)

            accord[name]:RelativeRescind(-3)
            expect(accord[name]:GetValue()).to.equal(2)

            accord[name]:RelativeRescind(2)
            expect(accord[name]:GetValue()).to.equal(4)
        end)

        it("go back to value", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            accord[name].inc = function(self)
                self.value += 1
            end

            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            expect(accord[name]:GetValue()).to.equal(5)

            accord[name]:RelativeRescind(-3)
            expect(accord[name]:GetValue()).to.equal(2)

            accord[name]:RelativeRescind()
            expect(accord[name]:GetValue()).to.equal(5)
        end)

        it("go -999 into the history", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            accord[name].inc = function(self)
                self.value += 1
            end

            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            expect(accord[name]:GetValue()).to.equal(5)

            accord[name]:RelativeRescind(-999)
            expect(accord[name]:GetValue()).to.equal(0)
        end)

        it("go 999 into the history", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            accord[name].inc = function(self)
                self.value += 1
            end

            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            expect(accord[name]:GetValue()).to.equal(5)

            accord[name]:RelativeRescind(-3)
            expect(accord[name]:GetValue()).to.equal(2)

            accord[name]:RelativeRescind(999)
            expect(accord[name]:GetValue()).to.equal(5)
        end)

        it("get value in the middle of history", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            accord[name].inc = function(self)
                self.value += 1
            end

            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            expect(accord[name]:GetValue()).to.equal(5)

            accord[name]:RelativeRescind(-3)
            expect(accord[name]:GetValue()).to.equal(2)
        end)

        it("get last value in the middle of history", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            accord[name].inc = function(self)
                self.value += 1
            end

            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            expect(accord[name]:GetValue()).to.equal(5)

            accord[name]:RelativeRescind(-3)
            expect(accord[name]:GetLastValue()).to.equal(1)
        end)

        it("override history", function()
            local name = tostring(random:NextNumber())
            accord:NewState(name, 0)

            accord[name].inc = function(self)
                self.value += 1
            end

            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            accord[name]:inc()
            expect(accord[name]:GetValue()).to.equal(5)

            accord[name]:RelativeRescind(-3)
            expect(accord[name]:GetValue()).to.equal(2)

            accord[name]:inc()
            accord[name]:RelativeRescind()
            expect(accord[name]:GetValue()).to.equal(3)
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
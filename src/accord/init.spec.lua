return function()
    local accord = require(script.Parent)

    describe("accord", function()
        it("nonexistent store", function()
            expect(accord[tostring(math.random())]).never.to.be.ok()
        end)
    end)
end
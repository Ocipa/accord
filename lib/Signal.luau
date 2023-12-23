-- TODO: add documentation
-- -----------------------------------------------------------------------------
--               Batched Yield-Safe Signal Implementation                     --
-- This is a Signal class which has effectively identical behavior to a       --
-- normal RBXScriptSignal, with the only difference being a couple extra      --
-- stack frames at the bottom of the stack trace when an error is thrown.     --
-- This implementation caches runner coroutines, so the ability to yield in   --
-- the signal handlers comes at minimal extra cost over a naive signal        --
-- implementation that either always or never spawns a thread.                --
--                                                                            --
-- License:                                                                   --
--   Licensed under the MIT license.                                          --
--                                                                            --
-- Authors:                                                                   --
--   stravant - July 31st, 2021 - Created the file.                           --
--   sleitnick - August 3rd, 2021 - Modified for Knit.                        --
--           - November 3rd, 2023 - Modified for Accord.                      --
-- -----------------------------------------------------------------------------

-- The currently idle thread to run the next handler on
local freeRunnerThread: thread? = nil

-- Function which acquires the currently idle handler runner thread, runs the
-- function fn on it, and then releases the thread, returning it to being the
-- currently idle one.
-- If there was a currently idle runner thread already, that's okay, that old
-- one will just get thrown and eventually GCed.
local function acquireRunnerThreadAndCallEventHandler(fn, ...)
	local acquiredRunnerThread = freeRunnerThread
	freeRunnerThread = nil
	fn(...)
	-- The handler finished running, this runner thread is free again.
	freeRunnerThread = acquiredRunnerThread
end

-- Coroutine runner that we create coroutines of. The coroutine can be
-- repeatedly resumed with functions to run followed by the argument to run
-- them with.
local function runEventHandlerInFreeThread(...)
	acquireRunnerThreadAndCallEventHandler(...)
	while true do
		acquireRunnerThreadAndCallEventHandler(coroutine.yield())
	end
end

-- TODO: figure out a better name for this.
type SignalMain<T...> = {
	_connectionsHead: Connection<T...>?,
}

type SignalImpl<T...> = {
	connect: (self: Signal<T...>, fn: (T...) -> ()) -> Connection<T...>,
	once: (self: Signal<T...>, fn: (T...) -> ()) -> Connection<T...>,
	getConnections: (self: Signal<T...>) -> { Connection<T...> },
	disconnectAll: (self: Signal<T...>) -> (),
	fire: (self: Signal<T...>, T...) -> (),
}

export type Signal<T...> = typeof(setmetatable({} :: SignalMain<T...>, {} :: { __index: SignalImpl<T...> }))

-- TODO: figure out a better name for this.
type ConnectionMain<T...> = {
	connected: boolean,

	_signal: Signal<T...>,
	_fn: (T...) -> (),
	_next: Connection<T...>?,
}

type ConnectionImpl<T...> = {
	disconnect: (self: Connection<T...>) -> (),
}

export type Connection<T...> = typeof(setmetatable({} :: ConnectionMain<T...>, {} :: { __index: ConnectionImpl<T...> }))

local connectionModule: ConnectionImpl<> = {} :: ConnectionImpl<>

function connectionModule:disconnect()
	if not self.connected then
		return
	end
	self.connected = false

	-- Unhook the node, but DON'T clear it. That way any fire calls that are
	-- currently sitting on this node will be able to iterate forwards off of
	-- it, but any subsequent fire calls will not hit it, and it will be GCed
	-- when no more fire calls are sitting on it.
	if self._signal._connectionsHead == self then
		self._signal._connectionsHead = self._next
	else
		local prev = self._signal._connectionsHead
		while prev and prev._next ~= self do
			prev = prev._next
		end
		if prev then
			prev._next = self._next
		end
	end
end

-- alias
(connectionModule :: any).destroy = connectionModule.disconnect;
(connectionModule :: any).Destroy = connectionModule.disconnect

local signalModule: SignalImpl<unknown> = {} :: SignalImpl<unknown>

function signalModule:connect(fn)
	local connection = setmetatable({
		connected = true,

		_signal = self,
		_fn = fn,
		_next = self._connectionsHead,
	}, { __index = connectionModule })

	self._connectionsHead = connection

	return connection
end

function signalModule:once(fn)
	local connection
	local done = false

	connection = self:connect(function(...)
		if done then
			return
		end

		done = true
		connection:disconnect()
		fn(...)
	end)

	return connection
end

function signalModule:getConnections()
	local items = {}

	local item = self._connectionsHead

	while item do
		table.insert(items, item)
		item = item._next
	end

	return items
end

function signalModule:disconnectAll()
	local item = self._connectionsHead

	while item do
		item.connected = false
		item = item._next
	end

	self._connectionsHead = nil
end

-- alias
(signalModule :: any).destroy = signalModule.disconnectAll;
(signalModule :: any).Destroy = signalModule.disconnectAll

function signalModule:fire(...)
	local item = self._connectionsHead

	while item do
		if item.connected then
			if not freeRunnerThread then
				freeRunnerThread = coroutine.create(runEventHandlerInFreeThread)
			end

			task.spawn(freeRunnerThread :: thread, item._fn, ...)
		end

		item = item._next
	end
end

local constructors = {
	new = function<T...>(): Signal<T...>
		local self = {}

		return setmetatable(self, { __index = signalModule }) :: any
	end,
}

return constructors

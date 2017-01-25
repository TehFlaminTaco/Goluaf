local func = {}debug.setmetatable(function()end,func)
local numb = {}debug.setmetatable(0,numb)
local bool = {}debug.setmetatable(false,bool)
local nilm = {}debug.setmetatable(nil,nilm)
local stri = getmetatable("")

-- GLOBAL
local toN = tonumber
function tonumber(...)
	local out = {}
	for k,v in pairs({...}) do
		if mt and mt.__tonumber then
			out[k] = mt.__tonumber(v)
		else
			out[k] = toN(v)
		end
	end
	return table.unpack(out)
end

-- Functions
function func.__add(a,b)
	if(type(a)=='function' and type(b)=='function')then
		return function(...)
			local o = table.add({a(...)},{b(...)})
			return table.unpack(o)
		end
	else
		if(type(b)=='function')then
			return function(...)
				return a, b(...)
			end
		else
			return function(...)
				local t = {a(...)}
				t[#t+1] = b
				return table.unpack(t)
			end
		end

	end
end

function func.__mul(a,b)
	if(type(a)=='string')then
		a = a()
	end
	if(type(b)=='string')then
		b = b()
	end
	if(type(a)=='function' and type(b)=='function')then
		return function(...)
			local outs = {}
			local t = {b()}
			while #t>0 do
				outs = table.add(outs,{a(table.unpack(table.add(t,{...})))})
				t = {b()}
			end
			return table.unpack(outs)
		end
	end
	if(type(a)=='function'and type(b)=='table')then
		return function(...)
			local outs = {}
			local i = 1
			local t = {next(b)}
			while #t>0 do
				a(table.unpack(t))
				i = t[1]
				t = {next(b,i)}
			end
			return table.unpack(outs)
		end
	end
	if(type(a)=='function'and type(b)=='number')then
		return function(...)
			for i=1, b do
				a(...)
			end
		end
	end
	if(type(b)=='function'and type(a)=='number')then
		return function(...)
			for i=1, a do
				b(...)
			end
		end
	end
end

function func.__pow(a,b)
	if(type(a)=='function' and type(b)=='function') then
		return function(...)
			return a(table.unpack(table.add({...},{b()})))
		end
	elseif type(a)=='function' then
		return function(...)
			return a(table.unpack(table.add({...},{b})))
		end
	else
		return function(...)
			return b(table.unpack(table.add({a},{...})))
		end
	end
end

function func.__mod(a,b)
	if type(a)=='function' then
		if type(b)=='function' then
			return function(...)
				return a(b(...))
			end
		elseif type(b) == 'table' then
			return function(...)
				local vals = {}
				for k,v in pairs(b) do
					vals[k] = v(...)
				end
				return a(table.unpack(vals))
			end
		else
			return function()
				return a(b)
			end
		end
	end
end

function func.__concat(a,b)
	if(type(a)=='function' and type(b)=='function') then
		return function(...)
			return a(table.unpack(table.add({b()},{...})))
		end
	elseif type(a)=='function' then
		return function(...)
			return a(table.unpack(table.add({...},{b})))
		end
	else
		return function(...)
			return b(table.unpack(table.add({a},{...})))
		end
	end
end

function func.__len(a)
	return function(...) return #a(...) end
end

-- Strings
function stri.__index(str,key)
	if type(key)=='number' then
		return str:sub(key,key)
	else
		return string[key] or str:find(key)
	end
end

function stri.__call(str,match,b)
	if b then
		return str:sub(match,b)
	else
		return str:gmatch(match or ".")
	end
end

function stri.__add(a,b)
	return a..b
end

function stri.__mul(a,b)
	if type(a)=='string' and type(b)=='string' then
		return a .. b
	elseif type(a)=='string' then
		return a:rep(b)
	else
		return b:rep(a)
	end
end

-- Numbers
numb.__index = numb
function numb.__call(n,b)

	local i = (b or 1)-1

	return function()
		i = i + 1
		return (i<=n and i) or nil
	end

end

-- Booleans
bool.__index = bool

function bool.int(a)
	return a and 1 or 0
end

function bool.__tonumber(a)
	return a:int()
end
function bool.__mul(a,b)
	a=tonumber(a)
	b=tonumber(b)
	return a * b
end

function bool.__add(a,b)
	a=tonumber(a)
	b=tonumber(b)
	return a + b
end

function bool.__div(a,b)
	a=tonumber(a)
	b=tonumber(b)
	return a / b
end

function bool.__pow(a,b)
	a=tonumber(a)
	b=tonumber(b)
	return a ^ b
end

function bool.__unm(a)
	return -(a:int())
end

-- Nils
nilm.__index = nilm

function nilm.int(a)
	return 0
end

function nilm.__tonumber(a)
	return 0
end
function nilm.__mul(a,b)
	a=(a==nil and 0 or a)
	b=(b==nil and 0 or b)
	return a * b
end

function nilm.__add(a,b)
	a=(a==nil and 0 or a)
	b=(b==nil and 0 or b)
	return a + b
end

function nilm.__div(a,b)
	a=(a==nil and 0 or a)
	b=(b==nil and 0 or b)
	return a / b
end

function nilm.__pow(a,b)
	a=(a==nil and 0 or a)
	b=(b==nil and 0 or b)
	return a ^ b
end

function nilm.__unm(a)
	return 0
end
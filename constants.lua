-- Bunch of fun constants to play with.

l = load;

H = "Hello, World!"
h = "hello world"

p = print
w = function(...)io.write(...)end -- I want to point out that the fact this was returning a File was REALLY ANNOYING.

M = math.max
m = math.min

a = "abcdefghijklmnopqrstuvwxyz"
A = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

n = '\n'
q = '"'
Q = "'"

u = function(t) return function() return table.unpack(t) end end
r = function(...) return ... end

N = function() end

f = function(a,b,c,d)
	local val = tonumber(a)
	if val == 0 then
		return b
	elseif val > 0 then
		return c
	elseif val < 0 then
		return d
	end
end
pth = arg[0]:match("(.*\\).*.lua")
local rqr = require
function require(tar)
	if not pth then
		return rqr(tar)
	end
	local b,e = loadfile(pth..tar:gsub("%.","\\")..".lua")
	if b then
		return b()
	else
		error(e)
	end
end
-- ENUMS

DEBUG_BASIC = 1
DEBUG_ERROR = 2
DEBUG_SYSTEM = 4

DEBUG_ALL = DEBUG_BASIC +
			DEBUG_ERROR +
			DEBUG_SYSTEM
__DEBUG = 0

-- Function defs for GOLFER
function debug_message(str,debuglevel)
	if (__DEBUG & debuglevel)>0 then
		io.stderr:write(str.."\n")
	end
end

local err = error
function error(str,...)
	debug_message(str,DEBUG_ERROR)
	debug_message(debug.traceback(),DEBUG_ERROR)
	if(__DEBUG & DEBUG_ERROR)then
		os.exit()
	end
end

function import(table)
	for k,v in pairs(table) do
		if _G[k] then
			debug_message("Tried to reuse \""..k.."\" in import. Ignoring.",DEBUG_SYSTEM)
		else
			_G[k] = v
		end
	end
	return import
end

function table.add(a,b)
	local c = {}
	for k,v in pairs(a) do
		c[#c+1] = v
	end
	for k,v in pairs(b) do
		c[#c+1] = v
	end
	return c
end

-- Hook into metatables
require "meta"

-- Globals abuse
require "glbl"

-- Custom Constants
require "constants"

-- Import code

local t = {...}
local file = t[1]
local arguments = {}
local flags = {debug = true, debug_error = true, e = true}
for i=2, #t do
	if t[i]:sub(1,1)=='+' then
		flags[t[i]:sub(2):lower()]=(t[i]:sub(2)==t[i]:sub(2):lower())
	elseif t[i]:sub(1,1)=='-' then
		flags[t[i]:sub(2):lower()]=(t[i]:sub(2)~=t[i]:sub(2):lower())
	elseif t[i]:sub(1,2)=='s_' then
		arguments[#arguments+1] = t[i]:sub(3)
	elseif t[i]:sub(1,2)=='n_' then
		arguments[#arguments+1] = tonumber(t[i]:sub(3))
	end
end

if flags.debug then
	__DEBUG = __DEBUG + DEBUG_BASIC
end
if flags.debug_error then
	__DEBUG = __DEBUG + DEBUG_ERROR
end
if flags.debug_system then
	__DEBUG = __DEBUG + DEBUG_SYSTEM
end

import(math)(string)(table)(os)(io)(debug)(utf8);

if not file then
	error("Cannot load empty file...")
end

if not flags.e then
	local f = io.open(file);
	file = f:read("*a");
	f:close();
end


if flags.repl then
	local s = io.read()
	while s~="exit()" do
		_ = arguments
		local b,e
		b,e = load(s)
		if not b then
			local B, E = load("_={"..s.."}")
			if B then
				b, e = B, E
			end
		end
		if b then
			local B,E = pcall(b,table.unpack(arguments))
			if not B then
				error(E)
			else
				if type(_[1])=='function' then
					_ = {_[1]()}
				end
				for k,v in ipairs(_) do
					if k~=#_ then
						print(v)
					else
						io.write(tostring(v))
					end
				end
			end
		else
			print(e)
		end

		s = io.read()
	end
end
_ = arguments

local b,e
b,e = load(file)
if not b then
	local B, E = load("_={"..file.."}")
	if B then
		b, e = B, E
	end
end
if b then
	local B,E = pcall(b,table.unpack(arguments))
	if not B then
		error(E)
	else
		if type(_[1])=='function' then
			_ = {_[1]()}
		end
		for k,v in ipairs(_) do
			if k~=#_ then
				print(v)
			else
				io.write(tostring(v))
			end
		end
	end
else
	error(e)
end

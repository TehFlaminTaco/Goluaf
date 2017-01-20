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
local flags = {debug = true, debug_error = true}
for i=2, #t do
	if t[i]:sub(1,1)=='+' then
		flags[t[i]:sub(2):lower()]=(t[i]:sub(2)==t[i]:sub(2):lower())
	elseif t[i]:sub(1,1)=='-' then
		flags[t[i]:sub(2):lower()]=(t[i]:sub(2)~=t[i]:sub(2):lower())
	elseif t[i]:sub(1,1)=='_' then
		arguments[#arguments+1] = t:sub(2)
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

local b,e = flags.e and loadstring(file) or loadfile(file)
if b then
	local B,E = pcall(b,table.unpack(arguments))
	if not B then
		error(E)
	end
else
	error(e)
end

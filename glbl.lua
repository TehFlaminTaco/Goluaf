local glb = {}setmetatable(_G,glb)

function glb.__index(t,key)
	if key:sub(1,1)=="_" then
		if key:sub(2):match("^%d+$") then
			return _[tonumber(key:sub(2))]
		end
		local f = nil
		local b = false
		for k,v in pairs(t) do
			if k:sub(1,#key-1)==key:sub(2) then
				if f and not b then b=true debug_message("Multiple instances of "..key:sub(2).." exist in global table. This may cause unintented and non-deterministic functionality!",DEBUG_BASIC) end
				f = v
			end
		end
		return f
	end
end

function glb.__newindex(t,key,val)
	if key:sub(1,1)=="_" and key:sub(2):match("^%d+$") then
		_[tonumber(key:sub(2))] = val
	else
		rawset(t,key,val)
	end
end
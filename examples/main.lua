local skynet = require "skynet"
local sprotoloader = require "sprotoloader"

local max_client = 64

skynet.start(function()
	
	skynet.newservice("openmygateserver")
	skynet.exit()
end)

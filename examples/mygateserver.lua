local skynet = require "skynet"
local gateserver = require "snax.gateserver"
local netpack = require "skynet.netpack" --使用netpack

local handler = {}

--当一个客户端链接进来，gateserver自动处理链接，并且调用该函数
function handler.connect(fd, ipaddr)
	skynet.error("ipaddr:",ipaddr,"fd:",fd,"connect")
	gateserver.openclient(fd)
end

--当一个客户端断开链接后调用该函数
function handler.disconnect(fd)
	skynet.error("fd:", fd, "disconnect")
end

--接收消息
function handler.message(fd, msg, sz)
	skynet.error("recv message from fd:", fd)
	skynet.error(netpack.tostring(msg, sz)) --把 handler.message 方法收到的 msg,sz 转换成一个
end

gateserver.start(handler)
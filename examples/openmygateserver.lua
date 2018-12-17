local skynet = require "skynet"
	skynet.start(function()
	skynet.error("Server start")
	local gateserver = skynet.newservice("mygateserver") --启动刚才写的网关服务
	skynet.call(gateserver, "lua", "open", { --需要给网关服务发送open消息，来启动监听
		port = 8001, --监听的端口
		maxclient = 64, --客户端最大连接数
		nodelay = true, --是否延迟TCP
	})
	skynet.error("gate server setup on", 8001)
	skynet.exit()
end)
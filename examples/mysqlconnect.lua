local skynet = require "skynet"
local mysql = require "skynet.db.mysql"
require "skynet.manager"
require "skynet.harbor"

local CMD = {}
local db

function CMD.query(sql)
    return db:query(sql)
end

local function dump(res, tab)
    tab = tab or 0
    if(tab == 0) then
        skynet.error("............dump...........")
    end
            if type(res) == "table" then
        skynet.error(string.rep("\t", tab).."{")
        for k,v in pairs(res) do
            if type(v) == "table" then
                dump(v, tab + 1)
            else
                skynet.error(string.rep("\t", tab), k, "=", v, ",")
            end
        end
        skynet.error(string.rep("\t", tab).."}")
    else
        skynet.error(string.rep("\t", tab) , res)
    end
end

skynet.start(function()
    local function on_connect(db)
        skynet.error("on_connect")
    end
    db=mysql.connect({
        host="193.112.231.132",
        port=10028,
        database="skynet",
        user="root",
        password="13ybm2dyd",
        max_packet_size = 1024 * 1024,
        on_connect = on_connect
    })
    if not db then
        skynet.error("failed to connect")
    else
        skynet.error("success to connect to mysql server")
    end

    skynet.dispatch("lua", function (session, address, command, sql)
        local response = skynet.response(skynet.pack)
        skynet.fork(function()
            skynet.error("command",command)
            local f = CMD[command]
            if f then
                response(true, f(sql))
            else
                skynet.error(string.format("Uknown command %s", tostring(command)))
            end
        end)
    end)
    skynet.register(".DBOP")
end)
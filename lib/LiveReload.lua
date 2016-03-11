--
-- Created by IntelliJ IDEA.
-- User: Cyril
-- Date: 16/3/9
-- Time: 下午2:42
-- To change this template use File | Settings | File Templates.
--

local fs = require("fs")
local path = require("path")
local ws = require('weblit-websocket')
local App = require('weblit-app')
local url = require("url")
local uv = require("uv")
local JSON = require("json")

local Emitter = require("core").Emitter

local protocal_version = "1.6"
local defaultPort =  35729

local defaultExts = {
    "html", "css", "js", "png", "gif", "jpg", "jsx",
    "php", "php5", "py", "rb", "erb", "coffee", "lua"
}
local defaultExclusions = {".git", ".svn", ".hg"}

local Server = Emitter:extend()

function merge(option, default)
    default = default or {}
    for k, v in pairs(option) do
        if type(v) == "table" then
            default[k] = merge(v, default[k])
        else
            default[k] = v
        end
    end
    return default
end

function Server:initialize(config)
    local default = {
        version = protocal_version,
        port = defaultPort,
        exts = defaultExts,
        exclusion = defaultExclusions,
        applyJSLive = false,
        applyCSSLive = true,
        applyImgLive = true,
        originalPath = "",
        overrideURL = "",
        usePolling = false,
        debug = true
    }
    self.config = merge(config, default)
end

function Server:listen ()
    self:debug "LiveReload is waiting for browser to connect."
    self.clients = {}
    self.server = App.bind({
        host = "0.0.0.0",
        -- Allow the user to specify the port via environment variables
        port = self.config.port
    })
    .websocket({
            path = "/livereload"
        }, function(...)
        self.onConnection(self, ...)
    end)
    .start()

    self:watch(self.config.path)

    return self
end

function Server:onConnection(req, read, write)
    self:debug "Browser connected."
    write {
        opcode = 1,
        payload = "!!ver:" .. self.config.version
    }
    self:on("refresh", function(data)
        coroutine.wrap(function()  --- Wrap in Coroutine, or it will throw error like "lua attempt to yield across C-call boundary"
            write(data)
        end)()
    end)
end

function Server:watch(path)
    local fse = uv.new_fs_event()
    uv.fs_event_start(fse,path,{
        --"watch_entry"=true,"stat"=true,
        recursive = true
    },function (err,fname,status)
        if(err) then
            p("Error ", err)
        else
            self:filterRefresh(fname)
        end
    end)
end

function Server:filterRefresh(filepath)
    local exts = self.config.exts
    local fileext = path.extname(filepath):sub(2)
    local fullpath = path.resolve(self.config.path, filepath)
    for k, v in pairs(exts) do  -- if is allowed file extension, like css, js.
        if v == fileext then
            local excluded = false
            for i, exc in pairs(self.config.exclusion) do -- if is in excluded file path.
                local fullp = path.resolve(self.config.path, exc)
                if fullpath:find(fullp) == 1 then
                    p(fullpath, fullp)
                    self:debug("Changed file in exclusion \"" .. exc .. "\", and will not trigger reload event.")
                    excluded = true
                end
            end
            if not excluded then
                self:debug("Refreshing file -> " , filepath)
                self:refresh(filepath)
            end
        end
    end
end

function Server:refresh(filepath)
    self:debug("Refresh: " .. (filepath or ""))
    local data = JSON.stringify({
        "refresh",
        {
            path = filepath,
            apply_js_live  = self.config.applyJSLive,
            apply_css_live = self.config.applyCSSLive,
            apply_img_live = self.config.applyImgLive,
            original_path  = self.config.originalPath,
            override_url   = self.config.overrideURL
        }
    })
    self:debug("Trigger Event: Sending message....")
    self:emit( "refresh", {
        opcode = 1,
        payload = data
    })
end

function Server:debug(...)
    if self.config.debug then
        p(...)
    end
end

local createServer = function (config)
    return Server:new(config)
    :listen()
    .server
    .route({
        method = "GET",
        path = "/livereload.js"
    }, function (req, res, go)
        local jsfile = fs.readFileSync( module.dir .. '/../ext/livereload.js')
        res.headers["Content-Type"] = "text/javascript"
        res.headers["Content-Length"] = #jsfile
        res.code = 200
        res.body = jsfile
    end)
end

return createServer

--[[

--]]


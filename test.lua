--
-- Created by IntelliJ IDEA.
-- User: Cyril
-- Date: 16/3/10
-- Time: 下午1:30
-- To change this template use File | Settings | File Templates.
--

local liveReload = require("./init.lua")

liveReload({path = module.dir, debug = true, exclusion = {"deps"}})
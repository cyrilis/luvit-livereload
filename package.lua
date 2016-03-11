--
-- Created by IntelliJ IDEA.
-- User: Cyril
-- Date: 16/3/9
-- Time: 下午2:38
-- To change this template use File | Settings | File Templates.
--
return {
    name = "cyrilis/livereload",
    version = "0.0.1",
    description = "LiveReload server in Luvit",
    homepage = "https://github.com/cyrilis/luvit-livereload",
    tags = {"livereload", "live-reload"},
    license = "MIT",
    dependencies = {
        "creationix/weblit-websocket",
        "creationix/weblit-app",
        "creationix/weblit-logger",
        "creationix/weblit-auto-headers",
        "creationix/weblit-static",
        "luvit/json",
        "luvit/require",
        "luvit/pretty-print",
    },
    files = {
        "!deps/*",
        "**.readme",
        "*.lua",
    }
}


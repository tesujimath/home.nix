local fennel = require("fennel")
local hs_fennel_libdir = hs.configdir .. "/fnl"

local fennel_path = {
    hs.configdir,
    hs_fennel_libdir
}
table.insert(package.loaders or package.searchers, fennel.makeSearcher(table.concat(fennel_path, ";")))

fennel.dofile("init.fnl", {}, {
    hs = hs,
    fennel = fennel,
    hs_fennel_libdir = hs_fennel_libdir
}, "freddy")
-- , { allowedGlobals = {
--     _G = _G,
--     hs = hs,
--     fennel = fennel,
--     hs_fennel_libdir = hs_fennel_libdir
-- }})

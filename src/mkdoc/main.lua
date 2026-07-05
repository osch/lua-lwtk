os.setlocale("C")

local fs   = require("path.fs")  -- https://luarocks.org/modules/xavier-wang/lpath
local perf = require("perf")

---------------------------------------------------------------------------------------------------------------------------

local ARGS = { ... }
local TRACE = (ARGS[1] == "trace") or false

fs.removedirs("../doc/gen")
fs.makedirs("../doc/gen/lwtk")

---------------------------------------------------------------------------------------------------------------------------

local module_loader = require("mkdoc.module_loader")
local loaded = module_loader.loadModules()

local depOrderedModuleNames = loaded.depOrderedModuleNames
local moduleInfos           = loaded.moduleInfos
local modules               = loaded.modules
local packageInfos          = loaded.packageInfos
local reverseLookup         = loaded.reverseLookup

---------------------------------------------------------------------------------------------------------------------------

local module_scanner = require("mkdoc.module_scanner")
local scanned = module_scanner.scan(depOrderedModuleNames, moduleInfos, modules)

local classInfos      = scanned.classInfos
local classMixinInfos = scanned.classMixinInfos
local functionInfos   = scanned.functionInfos
local metaInfos       = scanned.metaInfos
local mixinInfos      = scanned.mixinInfos
local otherInfos      = scanned.otherInfos

---------------------------------------------------------------------------------------------------------------------------

local member_scanner = require("mkdoc.member_scanner")
member_scanner.scan(depOrderedModuleNames, moduleInfos, modules, classInfos, reverseLookup)

---------------------------------------------------------------------------------------------------------------------------

local source_parser = require("mkdoc.source_parser")
source_parser.parseAllModules(TRACE, depOrderedModuleNames, moduleInfos, modules,
                              classMixinInfos, mixinInfos)

---------------------------------------------------------------------------------------------------------------------------

local output = require("mkdoc.output")
output.generate(moduleInfos, modules, packageInfos,
                classInfos, mixinInfos, metaInfos, functionInfos, otherInfos)

---------------------------------------------------------------------------------------------------------------------------

local link_checker = require("mkdoc.link_checker")
link_checker.check("../doc/gen")

---------------------------------------------------------------------------------------------------------------------------

perf.finish()

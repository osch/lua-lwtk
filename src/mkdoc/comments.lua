local lpeg = require "lpeglabel" -- https://luarocks.org/modules/sergio-medeiros/lpeglabel
local re   = require "relabel"   -- https://luarocks.org/modules/sergio-medeiros/lpeglabel

local byte = string.byte

lpeg.locale(lpeg)

local P, S, V = lpeg.P, lpeg.S, lpeg.V
local C, Carg, Cb, Cc = lpeg.C, lpeg.Carg, lpeg.Cb, lpeg.Cc
local Cf, Cg, Cmt, Cp, Cs, Ct = lpeg.Cf, lpeg.Cg, lpeg.Cmt, lpeg.Cp, lpeg.Cs, lpeg.Ct
local Lc, T = lpeg.Lc, lpeg.T

local alpha, digit, alnum = lpeg.alpha, lpeg.digit, lpeg.alnum
local xdigit = lpeg.xdigit
local space = lpeg.space

local comments = {}
do
    local globalPrint = print
    local print = globalPrint
    local list
    local startPosMap
    local endPosMap
    local subject
    
    function comments.init(fileContent, myPrint)
        print = myPrint or globalPrint
        list = {}
        startPosMap = {}
        endPosMap = {}
        subject = fileContent
    end

    local LF = byte("\n")
    
    local function beginOfLine(pos)
        for i = pos-1, 2, -1 do
            if byte(subject, i) == LF then
                return i+1
            end
        end
        return 1
    end
    
    local function column(pos)
        return pos - beginOfLine(pos) + 1
    end
    
    function comments.add(pos1, pos2, end_pos1, end_pos2, comment)
        local entry = { pos1 = pos1, 
                        pos2 = pos2,
                        end_pos1 = end_pos1, 
                        end_pos2 = end_pos2, 
                        comment = comment }
        list[#list + 1] = entry
        assert(not startPosMap[pos1])
        assert(not endPosMap[end_pos2])
        startPosMap[pos1] = entry
        endPosMap[end_pos2] = entry
        print("PPP", pos1, pos2, end_pos1, end_pos2, comment)
    end
    
    function comments.sort()
        table.sort(list, function(a,b) return a.pos1 < b.pos1 end)
        for i = 1, #list do
            list[i].i = i
        end
    end
    
    local notLfSpace    = -P"\n" * space
    local singleCmt     = P"--" * -(P"[" * P"="^0 * P"[")
    local exclSingleCmt = (notLfSpace^0 * P"\n" * notLfSpace^0)^1 * singleCmt
    local exclCmt       = (notLfSpace^0 * P"\n" * notLfSpace^0)
    local blankLine     = (notLfSpace^0 * P"\n" * notLfSpace^0)^2
    
    local function isExclCmt(entry)
        if entry.pos1 == 1 then
            return true
        else
            local p = entry.pos1
            if entry.i > 1 then
                local pe = list[entry.i - 1]
                if pe.end_pos2 + 1 == p then
                    p = pe.end_pos1 + 1
                end
            end
            return lpeg.match(exclCmt, subject, p)
        end
    end
    
    local function isSingleLineCmt(entry)
        return lpeg.match(singleCmt, subject, entry.pos2)
    end
    local function isExclSingleLineCmt(entry)
        if entry.pos1 == 1 then
            return lpeg.match(singleCmt, subject, entry.pos2)
        else
            local p = entry.pos1
            if entry.i > 1 then
                local pe = list[entry.i - 1]
                if pe.end_pos2 + 1 == p then
                    p = pe.end_pos1 + 1
                end
            end
            return lpeg.match(exclSingleCmt, subject, p)
        end
    end
    
    local function isBlankLineBefore(entry)
        local p = entry.pos1
        local pe = list[entry.i - 1]
        if pe and pe.end_pos2 + 1 == p then
            p = pe.end_pos1 + 1
        end
        return lpeg.match(blankLine, subject, p)
    end
    
    local function isBlankLineAfter(entry)
        local rslt = lpeg.match(blankLine, subject, entry.end_pos1 + 1)
        return rslt
    end
    
    local singleLineCmtBegin = P"--" * P"-"^0 * C(P(1)^0)

    local function removeSingleLineCmtBegin(entry)
        return lpeg.match(singleLineCmtBegin, entry.comment)
    end
    
    local multiLineCmtBegin = P"--[" * C(P"="^0) * "[" * C(space^0) * Cp() * C(P(1)^0)

    local function removeMultiLineCmt(entry)
        local eq, beginSpace, pos, rest = lpeg.match(multiLineCmtBegin, entry.comment)
        local indent
        if beginSpace:match("\n") then
            indent = lpeg.match(((P"\n" * C(notLfSpace^0) * -P(1)) + P(1))^1,
                                beginSpace)
        else
            local col = column(entry.pos2 + pos - 1)
            print("###################", require"inspect"{entry, pos, col})
            indent = string.rep(" ", col - 1)
        end
        local rest2 = rest:gsub("\n"..indent, "\n")
                          
        print("#########", require"inspect"{rest, rest2, indent})
        local cmtEnd = space^0 * P("]"..eq.."]")
        return lpeg.match(C((-cmtEnd * P(1))^0) * cmtEnd * -P(1), rest2)
    end
    
    function comments.getBefore(p)
        local entry = endPosMap[p - 1]
        if entry and not isBlankLineAfter(entry) then
            if entry then
                if isSingleLineCmt(entry) then
                    if isExclSingleLineCmt(entry) then
                        local col = column(entry.pos2)
                        if col == column(p) then
                            local i = entry.i
                            local e = entry
                            while i-1 > 0 do
                                local pe = list[i-1]
                                if pe.end_pos2 + 1 == e.pos1 and isSingleLineCmt(pe) 
                                   and not isBlankLineBefore(e)  and column(pe.pos2) == col
                                then
                                    i = i - 1
                                    e = pe
                                else
                                    break
                                end
                            end
                            if isExclSingleLineCmt(list[i]) then
                                local b = {}
                                for j = i, entry.i do
                                    local m = removeSingleLineCmtBegin(list[j])
                                    if m then
                                        b[#b + 1] = m
                                    end
                                end
                                return table.concat(b, "\n")
                            else
                                --local l1 = re.calcline(subject, list[i].pos2)
                                --local l2 = re.calcline(subject, entry.end_pos1)
                                --lwtk.errorf("Ambiguous multiline comment from line %d to line %d", l1, l2)
                            end
                        end
                    end
                else
                    if isExclCmt(entry) then
                        return removeMultiLineCmt(entry)
                    end
                end
            end
        end
    end
    
    function comments.getAfter(p1, p2)
        local entry = startPosMap[p1+1]
        if not entry and p2 then
            for p = p1+2, p2-1 do
                entry = startPosMap[p]
                if entry then
                    break
                end
            end
        end
        if entry then 
            for i = p1+1, entry.pos2-1 do
                if byte(subject, i) == LF then
                   return
                end
            end
            if isSingleLineCmt(entry) then
                local col = column(entry.pos2)
                local i = entry.i
                local e = entry
                while i+1 <= #list do
                    local ne = list[i+1]
                    if e.end_pos2 + 1 == ne.pos1 and isExclSingleLineCmt(ne) and col == column(ne.pos2) then
                        i = i + 1
                        e = ne
                    else
                        break
                    end
                end
                local b = {}
                for j = entry.i, i do
                    local m = removeSingleLineCmtBegin(list[j])
                    if m then
                        b[#b + 1] = m
                    end
                end
                return table.concat(b, "\n")
            else
                return removeMultiLineCmt(entry)
            end
        end
    end
    
    local endSpace = space^0 * -P(1)
    local dotSpace = P"." * space
    local shortDocPattern = space^0 * C(((-dotSpace - blankLine - endSpace) * P(1))^0 * P"."^-1)
    
    function comments.getShortDoc(docString)
        if docString then
            return lpeg.match(shortDocPattern, docString):gsub("%s+", " ")
        end
    end
    
    local argListBeginPattern = Cp() * P"@function("
    local argListPattern = (-argListBeginPattern * P(1))^0 * argListBeginPattern * Cp() * (-P")" * P(1))^0 * Cp() * ")" * Cp()
    local argListPattern0 = P"\n" * Cp() * notLfSpace^0 * P(-1)
    local argListPattern1 =   (-argListPattern0 * P(1))^0 * argListPattern0
                            + Cp() * notLfSpace^0  * P(-1)
    local argListPattern2 = notLfSpace^0 * (P"\n" + P(-1)) * Cp()
    
    function comments.stripArgListDoc(docString)
        if docString then
            local p1, p2, p3, p4 = lpeg.match(argListPattern, docString)
            local rsltDoc
            local argListString
            if p1 then
                if p1 > 1 or p4 <= #docString then
                    local d1, d2 = docString:sub(1,p1-1), docString:sub(p4,-1)
                    local s1 = lpeg.match(argListPattern1, d1)
                    local s2 = lpeg.match(argListPattern2, d2)
                    if s1 and s2 then
                        d1 = d1:sub(1, s1-1)
                        d2 = d2:sub(s2,-1)
                    end
                    rsltDoc = (d1..d2):gsub("%s+$", "")
                end
                argListString = docString:sub(p2, p3-1):gsub("%s",""):gsub(",", ", ")
            else
                rsltDoc = docString
            end
            return rsltDoc, argListString
        end
    end
    
    function comments.argListDocToMethod(argListDoc)
        if argListDoc:match("^self,") then
            return argListDoc:gsub("^self,%s*",""), true
        elseif argListDoc:match("^self$") then
            return "", true
        else
            return argListDoc
        end
    end
end
return comments

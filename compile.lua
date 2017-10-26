local function parse(txt)
    if type(txt) ~= "string" then
        error("Not a string", 2)
    end
    local tree = {}
    local treePos = tree
    local i = 1
    local line = 1
    while i <= #txt do
        --in block?
        if not treePos.ty then
            local nextWord = txt:sub(i):match("[^%s%(]+")
            --block creation statements
            if nextWord == "if" or nextWord == "while" or nextWord == "elseif" then
                if nextWord == "elseif" then
                    treePos = treePos.back
                    if not (treePos[1] == "if" or treePos[1] == "elseif") then
                        return false, "[" .. line .. "] elseif has no matching if statement"
                    end
                    treePos = treePos.back
                end
                treePos[#treePos + 1] = {nextWord, {ty = "condition"}, {}, back = treePos}
                treePos = treePos[#treePos]
                treePos[2].back = treePos
                treePos[3].back = treePos
                treePos = treePos[2]
            elseif nextWord == "else" or nextWord == "do" or nextWord == "repeat" then
                if nextWord == "else" then
                    local treePos = treePos.back
                    if not (con[1] == "if" or con[1] == "elseif") then
                        return false, "[" .. line .. "] else has no matching if statement"
                    end
                    treePos = treePos.back
                end
                treePos[#treePos + 1] = {nextWord, {}, back = con}
                treePos = treePos[#treePos]
                treePos[2].back = treePos
                treePos = treePos[2]
            elseif nextWord == "until" then
                treePos[#treePos + 1] = {"until

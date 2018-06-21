-- ========= Importing the metadatatable ========

-- Should define:
--   blobSize (integer) (optional)
--   metadatatable (table of entries, see example)
require ".metadata_spec"

-- ========= String building code from lua.org ==========

local function newStack ()
    return {""}   -- starts with an empty string
end
  
local function addString (stack, s)
    table.insert(stack, s)    -- push 's' into the the stack
    for i=table.getn(stack)-1, 1, -1 do
        if string.len(stack[i]) > string.len(stack[i+1]) then
            break
        end
        stack[i] = stack[i] .. table.remove(stack)
    end
end

-- ======== Adding unknowns to fill in gaps ======== ---

function maybeFillGap(outputStack,baseAddr,prevOffset,newOffset)
    -- Assumes [.. prevOffset) filled, and [newOffset ..) to be filled.

    if fillGaps then
        -- Prevent recursive calls
        fillGaps = false

        -- Adds a blank entry of the desired size, if there is room
        -- Updates prevOffset
        local function addBlankEntryIfPoss(size)
            if prevOffset + size <= newOffset then
                local blankEntry = {["offset"] = prevOffset, 
                    ["size"] = size,
                    ["type"] = "hex",
                    ["name"] = "[UNKNOWN] 0x" .. string.format("%X",prevOffset)}
                addEntry(outputStack,baseAddr,blankEntry)
                prevOffset = prevOffset + size
            end
        end

        -- 'Clean up' to the highest power of 2 multiple that we can, up to 4.
        -- Add a 0x01 if possible and necessary
        if prevOffset % 2 == 1 then
            addBlankEntryIfPoss(0x01)
        end
        -- Add a 0x02 if possible and necessary
        if prevOffset % 4 == 2 then
            addBlankEntryIfPoss(0x02)
        end

        -- Add 0x04s while possible
        while prevOffset + 4 <= newOffset do
            addBlankEntryIfPoss(0x04)
        end

        -- Similarly 'clean up' the end. Notice 0x02 first:
        addBlankEntryIfPoss(0x02)
        addBlankEntryIfPoss(0x01)

        -- Reverse our change to filling gaps.
        fillGaps = true
    end
end

-- ========= Adding an entry to the watch list =========

-- Byte, Word, Dword
local sizeChar = {[0x1]="b", [0x2]="w", [0x4]="d"}
-- Types. Vectors we break into floats. Enum -> Unsigned.
-- Default will be hex if not in this list.
local typeChar = {["hex"] = "h",
        ["float"] = "f",
        ["unsigned"] = "u",
        ["enum"] = "u"}

-- The end address (exclusive) of our last entry
prevEndOffset = nil

function addEntry(outputStack,baseAddr,e)
    -- Maybe fill the gaps, and mark the extent of our contigious block.
    maybeFillGap(outputStack, baseAddr, prevEndOffset, e.offset)
    prevEndOffset = e.offset + e.size

    addr = string.format("%X",baseAddr+e.offset)
    size = sizeChar[e.size]
    type = typeChar[e.type]
    if type == nil then type = "h" end
    if size == nil then error(string.format("Invalid size: %s", e.size)) end
    -- big-endian is assumed
    bigEndian = 1

    addString(outputStack,addr .. "\t" .. size .. "\t" .. type .. "\t" .. bigEndian .. "\t" .. "RDRAM" .. "\t" .. e.name .. "\n")
end

-- ============== Main function ================

function main(baseAddr,fillGaps)
    -- Initialise the follower for filling gaps
    prevEndOffset = baseAddr

    -- Initialise our outputStack with the SystemID
    outputStack = newStack()
    addString(outputStack,"SystemID N64\n")

    -- Add all the entries from the metadata table
    for _,e in pairs(metadatatable) do
        if e.type == "vector" then
            -- If it's a vector, break into the consistuent floats
            -- Adapted from Wyster's data.lua
            local dimension_mnemonics = {"x", "y", "z", "w"}
            local dimensions = (e.size / 0x04)	
            for i = 1, dimensions, 1 do
                local componentEntry = {["offset"] = (e.offset + ((i - 1) * 0x04)),
                    ["size"] = 0x04,
                    ["type"] = "float",
                    ["name"] = e.name .. "." .. dimension_mnemonics[i]}
                addEntry(outputStack,baseAddr,componentEntry)
            end

        else
            -- Otherwise add the entry directly
            addEntry(outputStack,baseAddr,e)
        end
    end

    -- Add unknowns up to the declared size
    if blobSize ~= nil then
        maybeFillGap(outputStack,baseAddr,prevEndOffset,blobSize)
    end

    -- Add an extra newline it seems, then recover the constructed string
    addString(outputStack,"\n")
    output = table.concat(outputStack)

    -- Output to the file
    local file = io.open("metadata.wch", "w+")
    file:write(output)
    file:close()
end

-- =============== Form ======================

local formHandle = forms.newform(250,200,"Metadata watch")

local indent = 10 
forms.label(formHandle, "Addr (hex)",indent,5)
local tbxAddrHandle = forms.textbox(formHandle,000000,200,30,"HEX",indent + 10,30)
local cbxFillHandle = forms.checkbox(formHandle, "Fill gaps", indent + 2,60)

-- Our function for running on click: load and run.
local function onClick()
    baseAddr = tonumber(forms.gettext(tbxAddrHandle),16)
    fillGaps = forms.ischecked(cbxFillHandle)
    main(baseAddr,fillGaps)
end

forms.button(formHandle, "Generate!", onClick, indent, 100)

-- Need to move to shared folder?
function isDebugMode(requestDebug)
  --for i, arg in ipairs(os.args) do
  --  if arg == "-debug" then
  --    return true and requestDebug
  --  end
  --end
  return true
end


function dumpTable(o)
   if type(o) == 'table' then
      local s = '{ '
      --if next(o) ~= nil then
        for k,v in pairs(o) do
           if type(k) ~= 'number' then k = '"'..k..'"' end
           s = s .. '['..k..'] = ' .. dumpTable(v) .. ','
        end
      --end      
      return s .. '} '
   else
      return tostring(o)
   end
end
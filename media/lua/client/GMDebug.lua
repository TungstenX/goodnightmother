
-- Need to move to shared folder?
function isDebugMode(requestDebug)
  for i, arg in ipairs(os.args) do
    if arg == "-debug" then
      return true and requestDebug
    end
  end
  return false
end
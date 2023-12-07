-- @description Mute my local monitoring track anc unmute the roundtrip track to allow performer's real-time
-- @version 1.0
-- @author AtmanActive
-- @website https://forum.cockos.com/showthread.php?t=272880
-- @changelog
--   + init
  
for key in pairs( reaper ) do _G[ key ] = reaper[ key ]  end  
function find_reaconnectlocal()
  local idx
  for i = 1, reaper.CountTracks(0) do
    local track = reaper.GetTrack(0,i-1)
    local retval, name = reaper.GetTrackName( track )
    if name:lower():match('reaconnect%:%slocal') then
      return track
    end 
  end
end

function find_reaconnectremote()
  local idx
  for i = 1, reaper.CountTracks(0) do
    local track = reaper.GetTrack(0,i-1)
    local retval, name = reaper.GetTrackName( track )
    if name:lower():match('reaconnect%:%sremote') then
      return track
    end 
  end
end

function main()
  local reaconnectlocal = find_reaconnectlocal()
  if not reaconnectlocal then return end
  local reaconnectremote = find_reaconnectremote()
  if not reaconnectremote then return end
  reaper.SetMediaTrackInfo_Value(  reaconnectlocal, 'B_MUTE', 1 )
  reaper.SetMediaTrackInfo_Value( reaconnectremote, 'B_MUTE', 0 )
end

main()  

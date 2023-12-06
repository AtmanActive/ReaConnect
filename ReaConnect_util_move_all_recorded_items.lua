-- @description Move all of the items from track "ReaConnect: REC" to this newly created track.
-- @version 1.0
-- @author MPL
-- @website https://forum.cockos.com/showthread.php?t=272880
-- @changelog
--   + init

for key in pairs( reaper ) do _G[ key ] = reaper[ key ]  end  
function find_reaconnectrec()
  local idx
  for i = 1, reaper.CountTracks(0) do
    local track = reaper.GetTrack(0,i-1)
    local retval, name = reaper.GetTrackName( track )
    if name:lower():match('reaconnect%:%srec') then
      return track
    end 
  end
end
------------------------------------------- 
function main()
  local tr = find_reaconnectrec()
  if not tr then return end
  
  local seltr = reaper.GetSelectedTrack(0,0)
  if not seltr then return end
  
  local cnt = reaper.CountTrackMediaItems( tr )
  for itemidx = cnt, 1, -1 do
    local item = reaper.GetTrackMediaItem( tr, itemidx-1 )
    reaper.MoveMediaItemToTrack( item, seltr )
  end
  reaper.UpdateArrange()
end



Undo_BeginBlock()
main()  
Undo_EndBlock( 'ReaConnect: Move all of the items from track "ReaConnect: REC" to this newly created track', 0 )

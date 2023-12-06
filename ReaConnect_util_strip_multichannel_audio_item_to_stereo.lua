-- @description Set selected multi channel audio item to stereo
-- @version 1.0
-- @author AtmanActive
-- @website https://forum.cockos.com/showthread.php?t=272880
-- @changelog
--   + init



-- Function : Get real take channel number (depends on source and chanmode)
local function real_chans( take, source )
  local take_chanmode = reaper.GetMediaItemTakeInfo_Value( take, "I_CHANMODE" )
  local source_chan = reaper.GetMediaSourceNumChannels( source )
  local take_chan = 0
  if source_chan > 1 and take_chanmode < 2 then
    take_chan = source_chan
  elseif source_chan > 1 and take_chanmode > 66 then
    take_chan = 2
  else
    take_chan = 1
  end
  return take_chan, take_chanmode
end



for key in pairs( reaper ) do _G[ key ] = reaper[ key ]  end  
function main()
  local t = {}
  for i = 1, CountSelectedMediaItems( 0 ) do 
    t[#t+1] = GetSelectedMediaItem( 0, i - 1 )
  end
  for i = 1, #t do
    local item = t[i]--GetSelectedMediaItem(0,i-1)
    local take =  reaper.GetActiveTake( item )
    local source = reaper.GetMediaItemTake_Source( take )
    local take_chan, take_chanmode = real_chans( take, source )
    if take_chan > 2 then
      --reaper.ShowConsoleMsg( 3|64 )
      --reaper.ShowConsoleMsg( take_chan )
      reaper.SetMediaItemTakeInfo_Value( take, "I_CHANMODE", 67 )
    end

  end
  UpdateArrange()
end

Undo_BeginBlock()
main()
Undo_EndBlock( 'ReaConnect: Set selected multi channel audio item to stereo', 0 )

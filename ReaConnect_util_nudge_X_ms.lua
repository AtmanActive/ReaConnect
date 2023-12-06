-- @description Nudge selected items X ms left where X is in the track name in curly brackets like {50ms}
-- @version 1.0
-- @author AtmanActive
-- @website https://forum.cockos.com/showthread.php?t=272880
-- @changelog
--   + init
  
for key in pairs( reaper ) do _G[ key ] = reaper[ key ]  end  
function main()
  local t = {}
  for i = 1, CountSelectedMediaItems( 0 ) do 
    t[#t+1] = GetSelectedMediaItem( 0, i - 1 )
  end
  for i = 1, #t do
    local item = t[i]--GetSelectedMediaItem(0,i-1)
    local parent_tr = GetMediaItem_Track( item )
    local parent_tr_name = ( {GetSetMediaTrackInfo_String(parent_tr, 'P_NAME', '', false)} )[2]
    local matched_curly = parent_tr_name:match( '{([0-9]+)ms}' )

    if matched_curly then
        --reaper.ShowConsoleMsg( parent_tr_name )
        --reaper.ShowConsoleMsg( matched_curly )
        reaper.ApplyNudge( 0, 0, 0, 0, matched_curly, 1, 0 )
    end
    
  end
  UpdateArrange()
end

Undo_BeginBlock()
main()  
Undo_EndBlock( 'ReaConnect: Nudge selected items X ms left where X is in the track name in curly brackets like {50ms}', 0 )

-- @description Execute all of the util steps needed after remote item recording has ended
-- @version 1.0
-- @author AtmanActive
-- @website https://forum.cockos.com/showthread.php?t=272880
-- @changelog
--   + init
  
for key in pairs( reaper ) do _G[ key ] = reaper[ key ]  end  
function main()
  local dir = ({reaper.get_action_context()})[2]:match("^(.*[/\\])")
  dofile( reaper.GetResourcePath()..'/Scripts/ReaConnect/ReaConnect_util_align_item_position_by_smpte_code.lua' )
  dofile( reaper.GetResourcePath()..'/Scripts/ReaConnect/ReaConnect_util_nudge_X_ms.lua' )
  dofile( reaper.GetResourcePath()..'/Scripts/ReaConnect/ReaConnect_util_strip_multichannel_audio_item_to_stereo.lua' )
  dofile( reaper.GetResourcePath()..'/Scripts/ReaConnect/ReaConnect_util_create_new_after_record_track.lua' )
  dofile( reaper.GetResourcePath()..'/Scripts/ReaConnect/ReaConnect_util_move_all_recorded_items.lua' )
end

Undo_BeginBlock()
main()  
Undo_EndBlock( 'ReaConnect: on record stop, align and store', 0 )

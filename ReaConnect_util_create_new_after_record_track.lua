-- @description Create a new track, either default one or from a designated template, and put it in the folder "ReaConnect: Mix" as a last track.
-- @version 1.0
-- @author MPL
-- @website https://forum.cockos.com/showthread.php?t=272880
-- @changelog
--   + init

for key in pairs( reaper ) do _G[ key ] = reaper[ key ]  end  
function find_reaconnectmix()
  local idx
  for i = 1, reaper.CountTracks(0) do
    local track = reaper.GetTrack(0,i-1)
    local retval, name = reaper.GetTrackName( track )
    if name:lower():match('reaconnect%:%smix') then
      return i-1
    end 
  end
end
-------------------------------------------
function find_reaconnectrec_name()
  for i = 1, reaper.CountTracks(0) do
    local track = reaper.GetTrack(0,i-1)
    local retval, name = reaper.GetTrackName( track )
    if name:lower():match('reaconnect%:%srec') then
      return name:match('%((.-)%)')
    end 
  end
end
-------------------------------------------
function insert_at_foldend(parentid)
  local comdepth= 0
  local cnttracks = reaper.CountTracks(0)
  for i = parentid, cnttracks-1 do
    local track = reaper.GetTrack(0,i)
    depth = reaper.GetMediaTrackInfo_Value( track, 'I_FOLDERDEPTH' ) 
    comdepth = depth+comdepth
    if comdepth == 0 then
      reaper.InsertTrackAtIndex( i+1, false )
      local newtrack = reaper.GetTrack(0,i+1) 
      if i ~= parentid then reaper.SetMediaTrackInfo_Value( track, 'I_FOLDERDEPTH',0 ) else reaper.SetMediaTrackInfo_Value( track, 'I_FOLDERDEPTH',1 ) end
      reaper.SetMediaTrackInfo_Value( newtrack, 'I_FOLDERDEPTH',-1 ) 
      return newtrack
    end
  end 
end
-------------------------------------------

function main()
  local idx = find_reaconnectmix()
  if not idx then return end
  local newtrack = insert_at_foldend(idx)
  if not newtrack then return end 
  template_name = find_reaconnectrec_name()
  if template_name then
    local fp = reaper.GetResourcePath()..'/TrackTemplates/'..template_name..'.RTrackTemplate'
    if  reaper.file_exists( fp  )then  
      --reaper.Main_openProject( fp ) 
      local f = io.open(fp,'rb')
      if f then
        local content = f:read('a')
        f:close()
        local depth = reaper.GetMediaTrackInfo_Value( newtrack, 'I_FOLDERDEPTH' ) 
        reaper.SetTrackStateChunk( newtrack, content, false )
        reaper.SetMediaTrackInfo_Value( newtrack, 'I_FOLDERDEPTH',depth ) 
        
      end
    end
    
  end
  reaper.SetOnlyTrackSelected( newtrack )
end



Undo_BeginBlock()
main()  
Undo_EndBlock( 'ReaConnect: Create a new track, or from a template, and put it in the folder ReaConnect: Mix', 0 )

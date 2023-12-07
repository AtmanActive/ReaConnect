# ReaConnect
ReaConnect: VST Connect for Reaper

ReaConnect is a set of Reaper projects and scripts that include routing and track templates, that, together with Sonobus or Audiomovers enable long-distance internet music collaboration and recording between a composer and a performer in the VST Connect style.

![ReaConnect](https://github.com/AtmanActive/ReaConnect/assets/7526717/b1e2aa75-f06c-4465-8e88-1981ace4f7b8)

It is intended for long-distance composing and recording sessions between two parties. We'll call these two parties Composer and Performer.
Composer runs a special Reaper project with all of the tracks and arrangement, MIDI, audio, whatever.
Performer runs a special Reaper project with nothing in it, that is setup once, with clever routing, and is then left as is, without Performer having to click anything while the session lasts.
All recording is done on Composer's Reaper.


Since there is a substantial latency between two parties, then, Composer has two modes of monitoring: listen-my-time and listen-Performer-time. Performer always hears everything in perfect sync. When Composer wants to sing or play something in real-time, they then switch their Reaper to my-time. This is done by muting the roundtrip track that is returning from Performer and unmuting the local monitoring track (there is a script for easy switching). In this, my-time mode, both Composer and Performer can hear what is Composer singing or playing in real-time. But, if Performer tries to sing or play in real-time, then, Composer will hear it desynced, due to internet latency. So, when it's time for Performer to sing or play, Composer needs to switch to Performer's time which then mutes the Composer's local monitoring track and unmutes the roundtrip track from the Performer, effectively enabling the Composer to hear what Performer hears, and that is their real-time. Of course, there is a script for easy switching.

When recording, Composer records on the designated track titled ReaConnect: REC which records a 6-channel audio holding Performer's stereo audio as channels 1+2, roundtrip mix audio as channels 3+4 and SMTPE sync track as channels 5+6. Once recording is finished, Composer activates a special script ReaConnect_on_record_stop.lua which then analyses SMPTE, nudges the time to compensate for internet latency, nudges the time to compensate for Performer's ASIO latency, creates a new track, optionally from a template in the ReaConnect: MIX folder and moves the newly recorded item there, getting rid of extra 4 channels that were needed for processing and results in a clean stereo audio item.


How to install:
- Download the ReaConnectScripts.zip from the Releases section and unzip to your Reaper/Scripts folder.
- Download the ReaConnectProject.zip from the Releases section and unzip wherever you want.
- Start Reaper, open Actions->Show Actions list, then click on the button New action and choose Load Reascript..., now navigate to your Reaper/Scripts/ReaConnect folder and select all files whose names begin with ReaConnect. This will import all needed scripts into your Reaper.
- Create toolbar shortcuts for the following scripts: ReaConnect_listen_my_time.lua, ReaConnect_listen_performer_time.lua and ReaConnect_on_record_stop.lua. First two you will use to switch the mix monitoring latency and the third one you will use after any recording of the Performer
- Done


How to use:

- Composer loads the Reaper project Composer.rpp (obtained from ReaConnectProject.zip downloaded from this project's Releases section)
- Performer loads the Reaper project Performer.rpp (obtained from ReaConnectProject.zip downloaded from this project's Releases section)
- Performer notifies Composer about their ASIO latency, as shown by their Reaper (in+out latency), and Composer types in this value in their Reaper's ReaConnect: REC track name, like, for example: {40ms}, so now Composer's Reaper knows how to compensate for Performer's ASIO latency.
- Optionally, Composer prepares a template track in their Reaper, what they would like to use to listen to newly recorded tracks coming from Performer, and can then add this template track's name to their ReaConnect: REC track name, like, for example: (compressor-EQ-reverb). ReaConnect's on-record-stop script will then create a new track from the template track to save time for Composer.

There are three scripts of interest:
- ReaConnect_listen_my_time.lua - when invoked, it will mute the roundtrip track and unmute the local mix monitoring track effectively enabling the Composer to sing or play an instrument in real-time and for the Performer to also hear it in proper sync, but Performer can't sing or play in real-time now.
- ReaConnect_listen_performer_time.lua - when invoked, it will mute the local mix monitoring track and unmute the roundtrip track effectively enabling the Performer to sing or play an instrument in real-time and for the Composer to also hear it in proper sync, but Composer can't sing or play for Performer in real-time now.
- ReaConnect_on_record_stop.lua - activate this script every time you (Composer) finish recording the Performer on the track ReaConnect: REC. It is important that the last 6-channel-recorded-item is selected, which usually happens anyway when you hit stop after recording in Reaper. This script will then perform several steps in the following order: 1.) analyse the SMTP track in the recorded item and move the item in time to compensate for remote internet latency, 2.) analyse the ReaConnect: REC track's title and look for a number written in curly brackets with a 'ms' suffix, like, for example: {50ms} and, if found, will move the item in time to compensate for Performer's ASIO latency which Composer's Reaper can't figure out on it's own, but it needs to be written down in the track's name, 3.) remove all, now unnecessary audio channels from the recorded item leaving it as plain stereo, 4.) create a new track in the ReaConnect: MIX folder, either as a brand new blank track, or as a new track from a template, again designated in the name of ReaConnect: REC track, with a name inside parentheses, like so (blah), 5.) move the newly recorded and processed item to this newly created track inside the ReaConnect: MIX folder.

Links:
- Reaper Forums discussion and development thread: https://forum.cockos.com/showthread.php?t=272880
- Reaper Stash download section: https://stash.reaper.fm/v/45737

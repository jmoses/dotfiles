#!/bin/sh
lcmd='gnome-terminal --window-with-profile=LeftScroll --geometry'
rcmd='gnome-terminal --window-with-profile=Default --geometry'
$lcmd 80x24+1400+26 &
$rcmd 80x24+2139+26 &
$lcmd 80x24+1400+487 &
$rcmd 80x24+2139+487 &

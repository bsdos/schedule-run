

#cs ＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿

 AU3 版本: 
 脚本作者: 
	Email: 
	QQ/TM: 
 脚本版本: 
 脚本功能: 

#ce ＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿脚本开始＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿

#include <Date.au3>
#Include <File.au3>




$conf="booking_task_conf.ini"

While 1
	$sleep=IniRead($conf,"global-info","script_watch_interval","-1")
	IniWrite($conf,"global-info","script_state","running...")
	$sname=IniReadSectionNames($conf)
	For $i=1 To $sname[0]
		$isexec=StringLeft(IniRead($conf,$sname[$i],"execution","n"),1)
		If $isexec="y" Or $isexec="Y" Then
			$c_nexttime=IniRead($conf,$sname[$i],"nexttime","")
			If $c_nexttime="" Then $c_nexttime="1970/01/01 00:00:00"
			If _DateDiff('s',$c_nexttime,_NowCalc())>=0 Then;现在时间晚于预执行时间
				dorun($sname[$i])
			EndIf
		EndIf
	Next

	If $sleep="-1" Then
		$ms=minsleep()
		IniWrite($conf,"global-info","script_state","sleeping...")
		IniWrite($conf,"global-info","script_nexttime",_DateAdd( 's',$ms, _NowCalc()))
		Sleep($ms*1000)
	Else
		IniWrite($conf,"global-info","script_nexttime","sleep and run every "&$sleep&" seconds")
		Sleep($sleep*1000)
	EndIf
	
WEnd

Func minsleep()
	$minsleep=_DateAdd( 'w',10, _NowCalc())
	$sname=IniReadSectionNames($conf)
	For $i=1 To $sname[0]
	$isexec=StringLeft(IniRead($conf,$sname[$i],"execution","n"),1)
	If $isexec="y" Or $isexec="Y" Then
		$co_nexttime=IniRead($conf,$sname[$i],"nexttime","")
		If _DateDiff('s',$co_nexttime,$minsleep)>0 Then
			$minsleep=$co_nexttime
		EndIf
	EndIf
Next
Return _DateDiff('s',_NowCalc(),$minsleep)+1
EndFunc



Func dorun($runname)
	IniWrite($conf,$runname,"state","running...")
	$state=goto($runname)
	IniWrite($conf,$runname,"state","stop")
	If $state Then
		$jiange=IniRead($conf,$runname,"interval","0")
		$miaojg=miaojiange($jiange)
		$add_nexttime=_DateAdd( 's',$miaojg, _NowCalc())
		IniWrite($conf,$runname,"nexttime",$add_nexttime)
	EndIf
EndFunc


Func miaojiange($jiange)
	$tmp=StringSplit($jiange,",")
	$miao=0
	For $i=1 To $tmp[0]
		Switch $i
			Case 1
				$miao=$miao+$tmp[1]
			Case 2
				$miao=$miao+($tmp[2]*60)
			Case 3
				$miao=$miao+($tmp[3]*60*60)
			Case 4
				$miao=$miao+($tmp[4]*60*60*24)		
		EndSwitch	
	Next
	Return $miao
EndFunc

Func goto1($what)
	Sleep(10000)
	Return True
EndFunc


Func goto($what)
_FileWriteLog(@ScriptDir &"\"&@YEAR&"_"&@MON& ".log","start "&$what)
Local $hDownload = InetGet("http://bookingd.thi-group.com/tasks.php?ac=1&name="&$what, @TempDir & "\update.dat", 1, 1)
$a=0
Do
    Sleep(250)
	$a=$a+250
;~ 	ToolTip($a)
Until (InetGetInfo($hDownload, 2) Or $a>60000);检查下载是否完成
_FileWriteLog(@ScriptDir &"\"&@YEAR&"_"&@MON& ".log","stop "&$what)
$stat=InetGetInfo($hDownload, 2)
InetClose($hDownload);关闭句柄, 释放资源.

Return $stat
EndFunc

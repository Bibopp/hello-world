#Region Includes
#include <WinHttp.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <String.au3>
#EndRegion
#Region GUI
$form = GUICreate("DarkOrbit Login", 220, 202, 453, 228)
$name = GUICtrlCreateInput("", 80, 48, 121, 21)
$label1 = GUICtrlCreateLabel("Please Login here!", 32, 8, 153, 24)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
$label2 = GUICtrlCreateLabel("Name:", 16, 48, 35, 17)
$label3 = GUICtrlCreateLabel("Password:", 16, 88, 53, 17)
$pw = GUICtrlCreateInput("", 80, 88, 121, 21, BitOR($gui_ss_default_input, $es_password))
$serv = GUICtrlCreateInput("", 80, 120, 121, 21)
$login = GUICtrlCreateButton("LOGIN ^__^", 16, 152, 187, 41)
$label4 = GUICtrlCreateLabel("Server:", 16, 120, 38, 17)
GUISetState(@SW_SHOW)
#EndRegion
While 1
	$nmsg = GUIGetMsg()
	Switch $nmsg
		Case $gui_event_close
			Exit
		Case $login
			$login = GuiCtrlRead($serv) & ".darkorbit.bigpoint.com"
			$logined = "loginForm_default_username=" & decode(GuiCtrlRead($name)) & "&loginForm_default_password=" & decode(GUICtrlRead($pw)) & "&loginForm_default_login_submit=Login"
			TrayTip("", "Open Connection", 10)
			$hSession = _WinHttpOpen("Mozilla/5.0 (Windows NT 6.2; WOW64; rv:17.0) Gecko/20100101 Firefox/17.0") ;<====Opens a connection
			TrayTip("", "Connecting", 10)
			$hConnect = _WinHttpConnect($hSession, $login) ;<===Connecting to DO
			TrayTip("", "Get Serverlist", 10)
			$sHtml = _WinHttpSimpleRequest($hConnect, "GET", "")
			$sHtml = _WinHttpSimpleRequest($hConnect, "POST", "?locale=de&aid=2997&aip=", $login, $logined) ;<===Start Login in DO

			$aString = _StringBetween($sHtml,'class="serverSelection_ini ini_active" target="http://' & GUICtrlRead($serv),'" onclick="InstanceSelection.clickedIni(this);"') ;<====Get the serverselection number, to login to the right server
			$aString = "http://" & GUICtrlRead($serv) & $aString[0]
			TrayTip("", "Loging in", 10)
			$sHtml = _WinHttpSimpleRequest($hConnect, "GET", $aString, $login);<===Login
			TrayTip("", "Get Startpage", 10)
			$sHtml = _WinHttpSimpleRequest($hConnect, "GET", "indexInternal.es?action=internalStart", $login, "indexInternal.es?action=internalStart");<===Logined :)
	EndSwitch
WEnd

Func decode($string) ;<====Decode the name, to use Specialcharacters like ?
	$decoded = ""
	$temp = StringToBinary($string,4)
	$temp = StringTrimLeft($temp,2)
	for $i = 1 to StringLen($temp) Step 2
		$decoded = $decoded & "%" & StringMid($temp,$i,2)
	Next
	Return $decoded
EndFunc

#comments-start
Author
   Conrad R
-----
What the test should do
   Prints paperwork including siteminder and tries to assign the room.
   This script will still print out canceled booking, which is how the script is supposed to behave.
-----
#comments-end

#include <AutoItConstants.au3>
#include "PrintOutSiteminderPaperwork.au3"
#include "CopyBookingIDandCheckIfNotCancellation.au3"
#include "SearchByIdOnTheSkyware.au3"
#include "TryToAssignRoom.au3"
#include "SafelyCopyHighlightedToClipboard.au3"
#include "PostPaymentOnSkyware.au3"
#include "EmailDeclainedBookingToLen.au3"
#include "CheckBookingDate.au3"
#include "PrintoutRegCard.au3"
#include "QuantityOfRooms.au3"
#include "CheckBookingDate.au3"
#include "ReturnProjectedBalance.au3"
#include "ReturnRate.au3"
#include "CheckIfDeclinedOrPaid.au3"
#include "PrintOut.au3"
#include "AddPrepaidCommentOnSkyware.au3"
#include "HighlightAllAndCopy.au3"
#include "_WinWaitActivate.au3"
#include "Constants.au3"

#Region --- Global variables Start ---
Global $g_bIsItNecessaryToPrintOutSiteminder, $g_bWasItSiteminderBooking, $g_bIsItForToday, $g_bIsItADV = False
Global $g_sClipboardWithBookingNumber, $g_sSkywareArrivalRateNumberOfRooms = ""

If @UserName = "User" Then ;if YP PC
	Global Const $g_iCheckSumSkywareIcon = 3487089813
	Global Const $g_iSiteminderWaitCheck = 1712426405
	Global Const $g_iSkywareSuccessfulRoomAllocation = 1520580581
	Global Const $g_sPrintOutWindowCharacterics = "[CLASS:MozillaWindowClass; X:395\Y:90\W:666\H:760]" ;could be handled by sending alt+f4
	Global Const $g_sGreenColour = 0x39D77B
	Global Const $g_iCheckSumRegCard = 3474790438

ElseIf @UserName = "Ballantrae" Then ;if albany left PC
	Global Const $g_iCheckSumSkywareIcon = 2675949942
	Global Const $g_iSiteminderWaitCheck = 1251178366
	Global Const $g_iSkywareSuccessfulRoomAllocation = 1520580581
	Global Const $g_sPrintOutWindowCharacterics = "[CLASS:MozillaWindowClass; X:395\Y:90\W:666\H:732]"
	Global Const $g_sGreenColour = 0x38D878
	Global Const $g_iCheckSumRegCard = 1542064209
Else
	MsgBox(0, "", "" & @UserName & " is unsupported")
	Exit
EndIf

#Region --- Albany right PC variables ---
;~ Global Const $g_iCheckSumSkywareIcon = 1948833437 ;albany right PC
;~ Global Const $g_iSiteminderWaitCheck = 1948833437 ;albany right PC
;~ Global Const $g_iSkywareSuccessfulRoomAllocation = 1948833437 ;albany right PC
#EndRegion --- Albany right PC variables ---

Global Enum $firstParam, $secondParam, $thirdParam, $fourthParam
Global $g_aSkywareIconLocation[4] = [527, 9, 548, 18] ;to-do use multidimensional array with enum, one for PixelChecksum and another one for MouseClicks
#EndRegion --- Global variables Start ---

#Region --- Internal functions Au3Recorder Start ---
Func _Au3RecordSetup()

	;Opt('WinWaitDelay', 100) ;default is 250
	Opt('WinDetectHiddenText', 1)
	Opt('WinTitleMatchMode', 2)

EndFunc   ;==>_Au3RecordSetup
#EndRegion --- Internal functions Au3Recorder Start ---

_Au3RecordSetup()

_WinWaitActivate("Webmail - Mozilla Firefox", "")

Send("{SHIFTDOWN}O{SHIFTUP}") ;opens the pop up. This sortcut is set by website's JavaScript

_WinWaitActivate($g_sPrintOutWindowCharacterics, "")

CopyBookingIDandCheckIfNotCancellation()


#cs archive/change log

WinClose("[CLASS:MozillaWindowClass; REGEXPTITLE:^(?!.*Webmail).*$, "") ;regex works, but function doesn't

as of 21/7/2019 it takes 25 seconds to process a prepaid booking, mostly due to internet/system/internet speed delays

TO DO:
   -multidiamensional array with all the variables - but for what variables... for mouseclicks it doesn't make sense, and other pixelchecksum are very rare and doesn't make sense to make it as global variables
   -proper scr bin folder structure
		maybe add Include folder for functions
   -if multiroom, still suggest posting with entry field for the amount taken
   -make sure that it can handle not assigment of rooms too, have a way to check that somehow, then open skyware in the new tab and make script wait for key combination to continue
   -change mouse clicks to just sending tabs when possible
   -printing could happen in the background, further speeding up the script, although you would need to take necessry precautions -
		making sure the previous window is active. Speeding up the script is also not a priority right now

#ce archive/change log

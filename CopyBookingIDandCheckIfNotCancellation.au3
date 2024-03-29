#include-once

Func CopyBookingIDandCheckIfNotCancellation()

	Local $sBookingID = ""

	HighlightAllAndCopy()

	If StringRegExp($g_sClipboardWithBookingNumber, "(Cancellation Charge|Reservation Cancellation|THE FOLLOWING RESERVATION HAS BEEN CANCELLED)") Then

		PrintOut()

		WinClose($g_sPrintOutWindowCharacterics)

		Exit

	EndIf

	If StringRegExp($g_sClipboardWithBookingNumber, "(SiteMinder)") Then $g_bWasItSiteminderBooking = True
	If StringRegExp($g_sClipboardWithBookingNumber, "(Non-refundable|Advanced Purchase|non refundable|Non Refundable)") Then $g_bIsItADV = True

	If StringRegExp($g_sClipboardWithBookingNumber, "Agoda") = False And _
			StringRegExp($g_sClipboardWithBookingNumber, "(Expedia Collect Booking|virtual credit card)") = False Then

		PrintOut()

	EndIf

	WinClose($g_sPrintOutWindowCharacterics)

	$sBookingID = StringRegExp($g_sClipboardWithBookingNumber, "([0-9,B]{8,15})", 1)
	If @error Then Exit MsgBox(0, "Error", "StringRegExp returned error, if 1 then it wasn't able to find booking ID: " & @error)

	PrintOutSiteminderPaperwork()    ;logically if cancellation, then it won't print out the skyware, as the program won't get to this point if it was a cancellation
	If ClipPut($sBookingID[0]) = False Then MsgBox(0, "Error", "Clipboard didn't change")

	;Sleep($LOADING_TIME_SLOW_PC_RELATED) ;because it was too fast and ctrl5 was being set to the the wrong window
	SearchByIdOnTheSkyware()

EndFunc   ;==>CopyBookingIDandCheckIfNotCancellation

-- CommonDialog.applescript
-- testAS

--  Created by 内山 和也 on 11/03/26.
--  Copyright 2011 __MyCompanyName__. All rights reserved.
on run
	return me
end run

script KZAlertDLG
	-- メッセージダイアログ
	on msg_box(msg)
		display dialog msg attached to the front window
	end msg_box
	
end script


script KZOpenSaveDLG
	-- アクセサ
	on set_title(|title|)
		set my _title to |title|
	end set_title
	
	on set_defaultLocation(defaultLocation)
		set my _defaultLocation to defaultLocation
	end set_defaultLocation
	
	on set_isMultiple(isMultiple)
		set my _isMultiple to isMultiple
	end set_isMultiple
	
	-- フォルダ選択
	on open_folder()
		tell open panel
			set title to my _title
			set can choose directories to true
			set can choose files to false
			if my _isMultiple then
				set allows multiple selection to true
			else
				set allows multiple selection to false
			end if
		end tell
		set posixLocation to POSIX path of my _defaultLocation
		display open panel in directory posixLocation
		return (path names of open panel) as list
	end open_folder
	
	-- ファイル選択
	on open_file()
		tell open panel
			set title to my _title
			set can choose directories to false
			set can choose files to true
			if my _isMultiple then
				set allows multiple selection to true
			else
				set allows multiple selection to false
			end if
		end tell
		set posixLocation to POSIX path of my _defaultLocation
		display open panel in directory posixLocation
		return (path names of open panel) as list
	end open_file
	
	on make
		set a_class to me
		script Instance
			property parent : a_class
			property _title : ""
			property _defaultLocation : "/"
			property _isMultiple : false
		end script
	end make
end script

script KZOpenSaveSheetDlg
	property parent : KZOpenSaveDLG
	-- フォルダ選択(on panel ended にてコールバック処理)
	on open_folder()
		tell open panel
			set title to my _title
			set can choose directories to true
			set can choose files to false
			if my _isMultiple then
				set allows multiple selection to true
			else
				set allows multiple selection to false
			end if
		end tell
		set posixLocation to POSIX path of my _defaultLocation
		display open panel in directory posixLocation attached to the front window
	end open_folder
	
	-- ファイル選択(on panel ended にてコールバック処理)
	on open_file()
		tell open panel
			set title to my _title
			set can choose directories to false
			set can choose files to true
			if my _isMultiple then
				set allows multiple selection to true
			else
				set allows multiple selection to false
			end if
		end tell
		set posixLocation to POSIX path of my _defaultLocation
		display open panel in directory posixLocation attached to the front window
	end open_file
	
	on make
		set self to continue make
		script SubClassInstance
			property parent : self
		end script
	end make
end script
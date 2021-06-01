-- ??????.applescript
-- ??????

--  Created by UchiyamaKazuya on 11/07/03.
--  Copyright 2011 __MyCompanyName__. All rights reserved.
(*======================================*)
(* Load Scripts *)
(*======================================*)
on import(a_name)
	set pwd to system attribute "PWD"
	if pwd is "" or pwd is ((path to startup disk)'s POSIX path) then
		-- プロジェクトのフルパス
		set pwd to "/Users/uchiyamakazuya/Desktop/タイムぼかん/"
	else
		set pwd to pwd & "/"
	end if
	return run script POSIX file (pwd & a_name & ".applescript")
end import

(*======================================*)
(* Local Variable *)
(*======================================*)
property CommonDialog : import("CommonDialog")
property KZStrings : import("KZStrings")
property KZFileManager : import("KZFileManager")
property Ddlg : KZAlertDLG of CommonDialog

property b_Folder : ""
property a_Folder : ""

(*======================================*)
(* Drag&Drop Handler *)
(*======================================*)

on accept table drop theObject drag info dragInfo drop operation dropOperation row theRow
	set dataTypes to types of pasteboard of dragInfo
	set theDataSource to data source of theObject
	
	set update views of theDataSource to false
	
	-- Set up the target data row (where we'll be placing the dropped items)
	if theRow is greater than (count of data rows of theDataSource) then
		set targetDataRow to missing value
	else
		set targetDataRow to data row theRow of theDataSource
	end if
	
	if "file names" is in dataTypes then
		-- ファイルのドロップ時処理
		set theFiles to {}
		
		set preferred type of pasteboard of dragInfo to "file names"
		
		set theFiles to contents of pasteboard of dragInfo
		set kzFm to make KZFileManager of KZFileManager
		set kzPath to make KZPathString of KZStrings
		set isFolder to is_directory((item 1 of theFiles), 1) of kzFm
		
		if (isFolder = 1) then
			set arrfile to file_list_full((item 1 of theFiles), 1) of kzFm
			my setDataToTable(arrfile, theObject)
			set update views of theDataSource to true
			return true
			
		end if
		if (count of theFiles) > 0 then
			
			-- ドロップしたファイルをテーブルに設定
			my setDataToTable(theFiles, theObject)
			set update views of theDataSource to true
			return true
		end if
	end if
	set update views of theDataSource to true
	return false
	
end accept table drop


on prepare table drop theObject drag info dragInfo drop operation dropOperation row theRow
	-- By default we will set the drag operation to not be a drag operation
	set dragOperation to no drag operation
	
	-- Get the list of data types on the pasteboard
	set dataTypes to types of pasteboard of dragInfo
	
	if "rows" is in dataTypes then
		if dropOperation is 1 then
			-- 行のDrag&Drop時にドロップ実行
			if option key down of event 1 then
				set dragOperation to copy drag operation
			else
				set dragOperation to move drag operation
			end if
		end if
		
	else if "file names" is in dataTypes then
		if dropOperation is 1 then
			-- ファイルのDrag&Drop時にドロップ実行
			set dragOperation to copy drag operation
		end if
	end if
	return dragOperation
end prepare table drop

(*======================================*)
(* Functions *)
(*======================================*)
on setDataToTable(arrfile, theObject)
	set kzPath to make KZPathString of KZStrings
	set theDataSource to data source of theObject
	set cmpData to {}
	set sortDatas to {}
	
	repeat with theItem in arrfile
		--set filepath to kzPath's trim_last_item(theItem)
		--set fileName to kzPath's last_item(theItem)
		--set tFileName to kzPath's trim_ext(fileName)
		--set end of sortDatas to filepath & "," & fileName & (ASCII character 10)
		set end of sortDatas to theItem & (ASCII character 10)
	end repeat
	
	set workdir to (POSIX path of (path to me) as Unicode text)
	set workdir to workdir & "Contents/Resources/"
	
	set old_delims to AppleScript's text item delimiters
	set sortBase to sortDatas as string
	
	--ソート結果を一旦ファイルに書き出す
	set command to "echo " & quoted form of sortBase & " | sort -d > " & quoted form of workdir & "tmp.csv"
	do shell script command
	
	-- ソート済みデータ格納
	set tmpPath to workdir & "tmp.csv"
	set x to do shell script "cat " & quoted form of tmpPath & " | cut -f1 -d, "
	set sortedPath to (paragraphs of x)
	
	--set x to do shell script "cat " & quoted form of tmpPath & " | cut -f2 -d, "
	--set sortedFileNames to (paragraphs of x)
	
	do shell script "rm -f " & tmpPath
	set AppleScript's text item delimiters to old_delims
	
	repeat with i from 2 to (count of sortedPath)
		set rowData to {}
		set end of rowData to item i of sortedPath
		set end of cmpData to rowData
	end repeat
	append the theDataSource with cmpData
end setDataToTable

on awake from nib theObject
	set w to tab view item "gekiteki" of tab view "tab" of window "MainWin"
	if (name of theObject is "bef") then
		-- 台割データソース作成
		set theDataSource to make new data source at end of data sources with properties {name:"bef"}
		-- カラム作成
		make new data column at end of data columns of theDataSource with properties {name:"filePath"}
		
		-- テーブルにデータソースを設定
		set data source of theObject to theDataSource
		
		-- ドラッグタイプ設定
		tell theObject to register drag types {"file names"}
	else if (name of theObject is "aft") then
		-- 台割データソース作成
		
		set theDataSource to make new data source at end of data sources with properties {name:"aft"}
		-- カラム作成
		make new data column at end of data columns of theDataSource with properties {name:"filePath"}
		
		-- テーブルにデータソースを設定
		set data source of theObject to theDataSource
		
		-- ドラッグタイプ設定
		tell theObject to register drag types {"file names"}
	else if name of theObject is "savepath" then
		set x to my loadPlist("SavePath")
		if x is "" then
			tell application "Finder"
				set x to path to documents folder
			end tell
		end if
		set contents of text field "savepath" of w to x
		
	else if name of theObject is "kyoukai_num" then
		if my loadPlist("KyoukaiNum") is not "" then
			set contents of text field "kyoukai_num" of w to my loadPlist("KyoukaiNum")
		else
			set contents of text field "kyoukai_num" of w to 18
		end if
		
	else if name of theObject is "trans_rate" then
		if my loadPlist("TranceRate") is not "" then
			set contents of text field "trans_rate" of w to my loadPlist("TranceRate")
		else
			set contents of text field "trans_rate" of w to 85
		end if
		
	else if name of theObject is "raster_dpi" then
		if my loadPlist("DPI") is not "" then
			set contents of text field "raster_dpi" of w to my loadPlist("DPI")
		else
			set contents of text field "raster_dpi" of w to 150
		end if
	else if name of theObject is "isAnti" then
		if my loadPlist("isAnti") is not "" then
			set contents of button "isAnti" of w to my loadPlist("isAnti")
		else
			set contents of button "isAnti" of w to true
		end if
	else if name of theObject is "illust" then
		if my loadPlist("illust") is not "" then
			set contents of button "illust" of w to my loadPlist("illust")
		else
			set contents of button "illust" of w to true
		end if
	end if
	
end awake from nib

on keyboard down theObject event theEvent
	if (name of theObject is "bef") or (name of theObject is "aft") then
		set pressedKey to (key code of theEvent)
		set characterKey to (character of theEvent)
		set theDataSource to data source of theObject
		
		-- Delete or BackSpace キー押下時
		if (pressedKey is 51) or (pressedKey is 117) then
			(*
			if name of theObject is "cmp1" then
				set b_Folder to ""
			else if name of theObject is "cmp2" then
				set a_Folder to ""
			end if
			*)
			set selectRow to selected data rows of theObject
			repeat with i from 1 to (count of selectRow)
				delete item i of selectRow
			end repeat
		end if
	end if
end keyboard down

(*======================================*)
(* Main *)
(*======================================*)
on clicked theObject
	set w to tab view item "gekiteki" of tab view "tab" of window "MainWin"
	if name of theObject is "go" then
		set tv to table view "bef" of scroll view "bef" of w
		set tv2 to table view "aft" of scroll view "aft" of w
		set theDataSource to data source of tv
		set theDataSource2 to data source of tv2
		set BPath_List to contents of data cell 1 of every data row of theDataSource
		set APath_List to contents of data cell 1 of every data row of theDataSource2
		set workdir to (POSIX path of (path to me) as Unicode text)
		set workdir to workdir & "Contents/Resources/"
		set kzPath to make KZPathString of KZStrings
		
		set myFile to contents of text field "savePath" of w
		set kyoukai_num to contents of text field "kyoukai_num" of w
		set trans_rate to contents of text field "trans_rate" of w
		set raster_dpi to contents of text field "raster_dpi" of w
		set isAnti to contents of button "isAnti" of w
		set isCMYK to contents of button "isCMYK" of w
		set isNear to contents of button "isNear" of w
		set illust to contents of button "illust" of w
		set a to count of APath_List
		set b to count of BPath_List
		
		if a is not b then
			display dialog "数が合いません"
		end if
		set befFile to (item 1 of BPath_List) as text
		set aftFile to (item 1 of APath_List) as text
		
		if befFile is aftFile then
			display dialog "同じファイルです"
		end if
		
		with timeout of (1 * 60 * 60) seconds
			repeat with i from 1 to b
				tell application "Adobe Photoshop CS3"
					set display dialogs to never
					set bFile to (item i of BPath_List) as text
					set aFile to (item i of APath_List) as text
					set bexpitem to kzPath's path_ext(bFile)
					set aexpitem to kzPath's path_ext(aFile)
					set tif_on to false
					if ((aexpitem is "tif") or (aexpitem is "tiff")) and ((bexpitem is "tif") or (bexpitem is "tiff")) then
						open alias bFile as TIFF
						open alias aFile as TIFF
						set tif_on to true
					else if ((aexpitem is "pdf") and (bexpitem is "pdf")) then
						if (isCMYK) then
							open alias bFile with options {class:PDF open options, mode:CMYK, resolution:raster_dpi, use antialias:isAnti, page:1, constrain proportions:true, crop page:media box}
							open alias aFile with options {class:PDF open options, mode:CMYK, resolution:raster_dpi, use antialias:isAnti, page:1, constrain proportions:true, crop page:media box}
						else
							open alias bFile with options {class:PDF open options, mode:grayscale, resolution:raster_dpi, use antialias:isAnti, page:1, constrain proportions:true, crop page:media box}
							open alias aFile with options {class:PDF open options, mode:grayscale, resolution:raster_dpi, use antialias:isAnti, page:1, constrain proportions:true, crop page:media box}
						end if
					else if ((aexpitem is "eps") and (bexpitem is "eps")) then
						open alias bFile with options {class:EPS open options, mode:grayscale, resolution:raster_dpi, use antialias:isAnti, constrain proportions:true}
						open alias aFile with options {class:EPS open options, mode:grayscale, resolution:raster_dpi, use antialias:isAnti, constrain proportions:true}
					else if ((aexpitem is "psd") and (bexpitem is "psd")) then
						open alias bFile showing dialogs never
						open alias aFile showing dialogs never
					else if ((aexpitem is "png") and (bexpitem is "png")) then
						open alias bFile showing dialogs never
						open alias aFile showing dialogs never
					else
						display dialog "比較ファイルタイプが違います。"
					end if
					
					set chg to workdir & "chgGray.jsx"
					set currentDocument to (a reference to document 2)
					tell currentDocument
						--比較先データ
						-- アクティブ
						activate
						-- レイヤー統合
						flatten
						if tif_on then
							--解像度を落とす
							resize image resolution 600 resample method bicubic smoother
							--グレースケールに変換
							do javascript (file chg)
							--解像度を落とす
							resize image resolution raster_dpi resample method bicubic smoother
						end if
						-- すべてを選択
						select all
						-- コピー
						copy
						-- 閉じる
						close saving no
					end tell
					set currentDocument to (a reference to document 1)
					tell currentDocument
						-- アクティブ
						activate
						-- レイヤー統合
						flatten
						if tif_on then
							--解像度を落とす
							resize image resolution 600 resample method bicubic smoother
							--グレースケールに変換
							do javascript (file chg)
							--解像度を落とす
							resize image resolution raster_dpi resample method bicubic smoother
						end if
						-- ペースト
						paste
						
						-- 背景をレイヤーに
						set imglay1 to background layer
						set name of imglay1 to "比較元"
						set imglay2 to layer 1
						set name of imglay2 to "比較先"
						set d1 to duplicate imglay1
						set d2 to duplicate imglay2
						move 2nd layer to after 3rd layer
						
						-- 差の絶対値
						set blend mode of d2 to difference
						tell layer 1
							merge
						end tell
						set name of d2 to "比較結果"
						
						set visible of 3rd layer to true
						set visible of 2nd layer to false
					end tell
					
					-- 色域指定（シャドウ）
					activate
					if isCMYK then
						set siki to workdir & "sikiiki_action_ill.jsx"
						--display dialog siki
						do javascript (file siki)
					else if isNear then
						set siki to workdir & "sikiiki_action_near.jsx"
						--display dialog siki
						do javascript (file siki)
					else if illust is true then
						set siki to workdir & "sikiiki_action_ill.jsx"
						--display dialog siki
						do javascript (file siki)
					else
						set siki to workdir & "sikiiki_action.jsx"
						--display dialog siki
						do javascript (file siki)
					end if
					tell currentDocument
						activate
						set current layer to 1st layer
						fill selection with contents {class:gray color, gray value:0}
						invert selection
						
					end tell
					
					
					-- 境界線を描く
					set kyoukai to workdir & "kyoukai.jsx"
					do javascript (file kyoukai) with arguments {kyoukai_num, 100.0}
					tell currentDocument
						activate
						fill selection with contents {class:gray color, gray value:0}
						invert selection
						deselect
						tell layer 1
							set opacity to trans_rate
						end tell
					end tell
					
				end tell
				set lastItem to kzPath's last_item((item i of APath_List) as string)
				set myFileName to kzPath's trim_ext(lastItem)
				set saveFile to (myFile & "/比較_" & myFileName & ".psd") as string
				tell application "Adobe Photoshop CS3"
					tell current document
						activate
						set myOptions to {class:Photoshop save options, embed color profile:true, save spot colors:true, save alpha channels:true, save annotations:true, save layers:true}
						save in file saveFile as Photoshop format with options myOptions appending no extension with copying
						close without saving
					end tell
				end tell
				
			end repeat
			
		end timeout
		
		set tv to table view "bef" of scroll view "bef" of w
		set tv2 to table view "aft" of scroll view "aft" of w
		delete every data row of data source of tv2
		delete every data row of data source of tv
	else if name of theObject is "setSave" then
		
		set kzDlg to make KZOpenSaveDLG of CommonDialog
		kzDlg's set_title("ファイルの保存先を選んで下さい")
		set workPath to kzDlg's open_folder()
		set workPath to workPath as string
		set contents of text field "savePath" of w to workPath
		
	else if name of theObject is "setting" then
		my savePlist("KyoukaiNum", contents of text field "kyoukai_num" of w)
		my savePlist("TranceRate", contents of text field "trans_rate" of w)
		my savePlist("DPI", contents of text field "raster_dpi" of w)
		my savePlist("SavePath", contents of text field "savePath" of w)
		my savePlist("isAnti", contents of button "isAnti" of w)
		my savePlist("illust", contents of button "illust" of w)
		
	else if name of theObject is "del_sel" then
		set tv to table view "bef" of scroll view "bef" of w
		set tv2 to table view "aft" of scroll view "aft" of w
		set theDataSource to data source of tv
		set theDataSource2 to data source of tv2
		set selectRow1 to selected data rows of tv
		set selectRow2 to selected data rows of tv2
		if selectRow1 is not missing value then
			set selectRow to selected data rows of tv
			repeat with i from 1 to (count of selectRow)
				delete item i of selectRow
			end repeat
			if selectRow2 is not missing value then
				set selectRow to selected data rows of tv2
				repeat with i from 1 to (count of selectRow)
					delete item i of selectRow
				end repeat
			end if
		else if selectRow2 is not missing value then
			set selectRow to selected data rows of tv2
			repeat with i from 1 to (count of selectRow)
				delete item i of selectRow
			end repeat
		end if
	else if name of theObject is "clist" then
		set tv to table view "bef" of scroll view "bef" of w
		set tv2 to table view "aft" of scroll view "aft" of w
		delete every data row of data source of tv2
		delete every data row of data source of tv
	end if
end clicked

--初期設定ファイルに保存する
--savePlist(項目名,内容)
on savePlist(thisKey, thisContent)
	try
		--初期設定ファイルに保存
		set contents of default entry thisKey of user defaults to thisContent
	on error
		make new default entry at end of default entries of user defaults with properties {name:thisKey, contents:""}
		set contents of default entry thisKey of user defaults to thisContent
	end try
end savePlist

--初期設定ファイルから読み込む
--loadPlist(項目名)
on loadPlist(thisKey)
	try
		--初期設定ファイルから読み込み
		set thisCont to contents of default entry thisKey of user defaults
	on error
		set thisCont to ""
	end try
	return thisCont
end loadPlist

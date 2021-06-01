-- RenameTool.applescript
-- RenameTool

--  Created by 内山 和也 on 12/01/11.
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

property g_workdir : ""


(*======================================*)
(* Custum *)
(*======================================*)

on choose menu item theObject
	set cur_type to title of theObject
	set w to tab view item "rename" of tab view "tab" of window "MainWin"
	if name of theObject is "renprocess" then
		if cur_type is "PDFバラ→連番" then
			set enabled of text field "start_num" of w to true
			set enabled of text field "keta" of w to true
			set enabled of text field "searchName" of w to true
			set enabled of text field "top_name" of w to true
			set enabled of text field "tikan" of w to false
			set enabled of text field "tikan_targ" of w to false
			set enabled of button "savecsv" of w to true
			
		else if cur_type is "ファイル名→連番" then
			set enabled of text field "start_num" of w to false
			set enabled of text field "keta" of w to false
			set enabled of text field "searchName" of w to false
			set enabled of text field "top_name" of w to true
			set enabled of text field "tikan" of w to false
			set enabled of text field "tikan_targ" of w to false
			set enabled of button "savecsv" of w to false
		else if cur_type is "置換" then
			set enabled of text field "start_num" of w to false
			set enabled of text field "keta" of w to false
			set enabled of text field "searchName" of w to false
			set enabled of text field "top_name" of w to false
			set enabled of text field "tikan" of w to true
			set enabled of text field "tikan_targ" of w to true
			set enabled of button "savecsv" of w to false
		end if
		my repproc(false)
	end if
end choose menu item

(*======================================*)
(* Event Handler *)
(*======================================*)
on clicked theObject
	set w to tab view item "rename" of tab view "tab" of window "MainWin"
	if name of theObject is "tikan_go" then
		my repproc(true)
		set tv to table view "infile" of scroll view "infile" of w
		set tv_out to table view "outfile" of scroll view "outfile" of w
		delete every data row of data source of tv_out
		delete every data row of data source of tv
	else if name of theObject is "cllist" then
		set tv to table view "infile" of scroll view "infile" of w
		set tv_out to table view "outfile" of scroll view "outfile" of w
		delete every data row of data source of tv_out
		delete every data row of data source of tv
		
	else if name of theObject is "save" then
		set tv_out to table view "outfile" of scroll view "outfile" of w
		set datasource_out to data source of tv_out
		my saveCSV(datasource_out)
		
	end if
end clicked

on repproc(isRepStart)
	set w to tab view item "rename" of tab view "tab" of window "MainWin"
	set cur_proc to title of current menu item of popup button "renprocess" of w
	set tv to table view "infile" of scroll view "infile" of w
	set datasource to data source of tv
	set innameList to contents of data cell 1 of every data row of datasource
	set isCSV to contents of button "savecsv" of w
	if (count of innameList) is 0 then
		return
	end if
	
	set tv_out to table view "outfile" of scroll view "outfile" of w
	set datasource_out to data source of tv_out
	
	delete every data row of data source of tv_out
	
	if cur_proc is "PDFバラ→連番" then
		my pdfrep(innameList, datasource_out)
	else if cur_proc is "ファイル名→連番" then
		my reban(innameList, datasource_out)
	else if cur_proc is "置換" then
		my repName(innameList, datasource_out)
	end if
	
	--display dialog "リネームを続けますか？" buttons {"やめる", "続ける"} default button 2 with icon 2
	--if (button returned of result) is "やめる" then
	--	return
	--end if
	
	if isRepStart then
		my appendRep(innameList, datasource_out)
	end if
	
	if isCSV then
		my saveCSV(datasource_out)
	end if
end repproc

on appendRep(innameList, datasource_out)
	set outnameList to contents of data cell 1 of every data row of datasource_out
	set i to 1
	repeat with theItem in innameList
		set targetFilePath to g_workdir & "/" & theItem
		set targetFilePath to targetFilePath as POSIX file
		
		tell application "Finder"
			set al to targetFilePath as alias
			set name of al to (item i of outnameList)
			set i to i + 1
		end tell
	end repeat
	
end appendRep

on repName(innameList, datasource_out)
	-- 置換実行
	set w to tab view item "rename" of tab view "tab" of window "MainWin"
	set searchName to contents of text field "tikan_targ" of w
	set replaceName to contents of text field "tikan" of w
	set kzStr to make KZString of KZStrings
	set renamedStrs to {}
	
	repeat with theItem in innameList
		-- 置換実行
		set reped to kzStr's repstr(theItem, searchName, replaceName)
		set end of renamedStrs to reped
		
	end repeat
	append the datasource_out with renamedStrs
end repName

on reban(innameList, datasource_out)
	set w to tab view item "rename" of tab view "tab" of window "MainWin"
	set renamedStrs to {}
	set kzStr to make KZString of KZStrings
	set replaceName to contents of text field "top_name" of w
	set i to 1
	
	repeat with theItem in innameList
		-- 拡張子を取得
		set ppos to my search_period(theItem)
		set extname to text ppos thru (length of theItem) of theItem
		
		-- 拡張子の前を取得
		if replaceName is "" then
			set beforeName to text 1 thru (ppos - 1) of theItem
		else
			set beforeName to replaceName
		end if
		
		-- リネーム後のファイル名を作成
		set end of renamedStrs to beforeName & " " & (i as string) & extname
		
		set i to i + 1
	end repeat
	append the datasource_out with renamedStrs
end reban

on pdfrep(innameList, datasource_out)
	set w to tab view item "rename" of tab view "tab" of window "MainWin"
	set keta to contents of text field "keta" of w as integer
	set start_num to contents of text field "start_num" of w as integer
	set searchName to contents of text field "searchName" of w
	set replaceName to contents of text field "top_name" of w
	set kzStr to make KZString of KZStrings
	set renamedStrs to {}
	
	set kugiripos to my search_kugiri(item 1 of innameList)
	if kugiripos is not 0 then
		set ppos to my search_period(item 1 of innameList)
		set extname to text ppos thru (length of item 1 of innameList) of (item 1 of innameList)
		-- 先頭の数字が0だったらオフセットに1+
		set nameToNum to (text (kugiripos + 1) thru ((length of (item 1 of innameList)) - (length of extname)) of (item 1 of innameList)) as integer
		if nameToNum is 0 then
			set start_num to start_num + 1
		end if
		
		repeat with theItem in innameList
			-- 拡張子を取得
			set ppos to my search_period(theItem)
			set extname to text ppos thru (length of theItem) of theItem
			
			-- 置き換え対象の範囲を取得
			set t to kzStr's searchStr(theItem, searchName)
			set a to (item 1 of t) as integer
			set b to (item 2 of t) as integer
			set a to a + 1
			
			-- 見つからない場合
			if a is 0 and b is 0 then
				log "文字がみつからない"
				return false
			else
				-- 区切り文字の検索
				set kugiripos to my search_kugiri(theItem)
				set aname to ""
				set bname to ""
				if kugiripos is not 0 then
					--区切り文字がある場合は数字を作成
					-- 未変更部分の取得
					if (((b + 1) is kugiripos) or (b is kugiripos)) and (a is 1) then
						log "未変更部分なし"
					else
						if a is not 1 then
							set bname to text 1 thru (a - 1) of theItem
						end if
						if (b + 1) is not kugiripos then
							set aname to text (b + 1) thru (kugiripos - 1) of theItem
						end if
					end if
					
					-- 名前から数字を抜き出す
					set nameToNum to (text (kugiripos + 1) thru ((length of theItem) - (length of extname)) of theItem) as integer
					
					-- オフセットを足す
					set nameToNum to nameToNum + (start_num - 1)
					
					-- 桁数を調整
					set paddedNum to kzStr's padd_num(keta, nameToNum)
					
					-- リネーム後のファイル名を作成
					set end of renamedStrs to bname & aname & replaceName & paddedNum & extname
				end if
			end if
		end repeat
		append the datasource_out with renamedStrs
		set outnameList to contents of data cell 1 of every data row of datasource_out
		
	end if
end pdfrep

on saveCSV(datasource_out)
	set outnameList to contents of data cell 1 of every data row of datasource_out
	set savePath to (POSIX path of g_workdir) & "/Pages"
	set ret to "page" & "," & return
	repeat with theItem in outnameList
		set buf to ""
		set ppos to my search_period(theItem)
		if (text 1 thru 1 of theItem) is "P" then
			set buf to text 2 thru (ppos - 1) of theItem
		else
			set buf to text 1 thru (ppos - 1) of theItem
		end if
		set ret to ret & buf & "," & return
	end repeat
	do shell script "echo " & quoted form of ret & "> " & quoted form of (savePath & ".csv")
end saveCSV
(*======================================*)
(* init UI *)
(*======================================*)
on awake from nib theObject
	set w to tab view item "rename" of tab view "tab" of window "MainWin"
	
	if (name of theObject is "infile") then
		-- 処理対象データソース作成
		set theDataSource to make new data source at end of data sources with properties {name:"infile"}
		
		-- カラム作成
		make new data column at end of data columns of theDataSource with properties {name:"fileName"}
		
		-- テーブルにデータソースを設定
		set data source of theObject to theDataSource
		
		-- ドラッグタイプ設定
		tell theObject to register drag types {"file names"}
		
	else if (name of theObject is "outfile") then
		-- 処理対象データソース作成
		set theDataSource to make new data source at end of data sources with properties {name:"outfile"}
		
		-- カラム作成
		make new data column at end of data columns of theDataSource with properties {name:"fileName"}
		
		-- テーブルにデータソースを設定
		set data source of theObject to theDataSource
		
	else if (name of theObject is "searchName") then
		set contents of text field "searchName" of w to ""
		
	else if (name of theObject is "keta") then
		set contents of text field "keta" of w to 3
		
	else if (name of theObject is "start_num") then
		set contents of text field "start_num" of w to 1
		
	else if (name of theObject is "top_name") then
		set contents of text field "top_name" of w to ""
		
	else if (name of theObject is "renprocess") then
		set current menu item of theObject to menu item 1 of theObject
		
	else if (name of theObject is "tikan") then
		set enabled of text field "tikan" of w to false
		
	else if (name of theObject is "tikan_targ") then
		set enabled of text field "tikan_targ" of w to false
	end if
	
end awake from nib

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
			set arrfile to file_list((item 1 of theFiles), 1) of kzFm
			
			set curPath to (item 1 of theFiles)
			set g_workdir to curPath
			
			set ret to my setDataToTable(curPath, arrfile, theObject)
			
			if ret is false then
				set ret to my setDataToTableRenBan(curPath, arrfile, theObject)
				if ret is false then
					return false
				end if
			else
				set w to tab view item "rename" of tab view "tab" of window "MainWin"
				set datasource to data source of theObject
				set innameList to contents of data cell 1 of every data row of datasource
				set k to search_kugiri(item 1 of innameList)
				set str to text 1 thru (k - 1) of (item 1 of innameList)
				set contents of text field "searchName" of w to str
				set contents of text field "top_name" of w to "P"
			end if
			
		else if (count of theFiles) > 0 then
			set curPath to trim_last_item((item 1 of theFiles)) of kzPath
			set g_workdir to curPath
			
			-- ドロップしたファイルをテーブルに設定
			set ret to my setDataToTable(curPath, theFiles, theObject)
			
			if ret is false then
				set ret to my setDataToTableRenBan(curPath, theFiles, theObject)
				if ret is false then
					return false
				end if
			else
				set w to tab view item "rename" of tab view "tab" of window "MainWin"
				set datasource to data source of theObject
				set innameList to contents of data cell 1 of every data row of datasource
				set k to search_kugiri(item 1 of innameList)
				set str to text 1 thru (k - 1) of (item 1 of innameList)
				set contents of text field "searchName" of w to str
				set contents of text field "top_name" of w to "P"
			end if
		end if
		my repproc(false)
		set update views of theDataSource to true
		return true
	end if
	set update views of theDataSource to true
	return false
end accept table drop

on prepare table drag theObject drag rows dragRows pasteboard thePasteboard
	set preferred type of thePasteboard to "rows"
	-- ペーストボードにドラッグする行番号を設定
	set content of thePasteboard to dragRows
	return true
end prepare table drag

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

on end editing theObject
	my repproc(false)
end end editing



(*======================================*)
(* Functions *)
(*======================================*)
on setDataToTableRenBan(curPath, arrfile, theObject)
	set kzPath to make KZPathString of KZStrings
	set theDataSource to data source of theObject
	set cmpData to {}
	set sortDatas to {}
	
	repeat with theItem in arrfile
		set fileName to kzPath's last_item(theItem)
		set end of sortDatas to fileName & (ASCII character 10)
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
	set sortedFileNames to (paragraphs of x)
	
	do shell script "rm -f " & tmpPath
	set AppleScript's text item delimiters to old_delims
	
	repeat with i from 2 to (count of sortedFileNames)
		set rowData to {}
		set end of rowData to item i of sortedFileNames
		set end of cmpData to rowData
	end repeat
	append the theDataSource with cmpData
	
	if (count of cmpData) is not (count of arrfile) then
		return false
	end if
	return true
end setDataToTableRenBan

-- 数字の順に並べ替えたデータを返す
on setDataToTable(curPath, arrfile, theObject)
	
	set kzPath to make KZPathString of KZStrings
	set theDataSource to data source of theObject
	set cmpData to {}
	set sortDatas to {}
	set renameDatas to {}
	repeat with theItem in arrfile
		set fileName to kzPath's last_item(theItem)
		set fileName to kzPath's trim_ext(fileName)
		set end of renameDatas to fileName
	end repeat
	
	-- 0でうめた、ソート用の数字を作成
	set retarr to my padding_num(renameDatas)
	
	if ((count of retarr) is 0) or ((count of retarr) < (count of arrfile)) then
		return false
	end if
	
	set i to 1
	repeat with theItem in arrfile
		set paddedNum to (item i of retarr) as string
		set fileName to kzPath's last_item(theItem)
		set end of sortDatas to paddedNum & "," & fileName & (ASCII character 10)
		set i to i + 1
	end repeat
	
	-- 001, 陰陽頭 賀茂保憲 1.pdf の形のCSV作成
	set workdir to (POSIX path of (path to me) as Unicode text)
	set workdir to workdir & "Contents/Resources/"
	
	set old_delims to AppleScript's text item delimiters
	set sortBase to sortDatas as string
	
	--ソート結果を一旦ファイルに書き出す
	set command to "echo " & quoted form of sortBase & " | sort -d > " & quoted form of workdir & "tmp.csv"
	do shell script command
	
	
	-- ソート済みデータ格納
	set tmpPath to workdir & "tmp.csv"
	
	set x to do shell script "cat " & quoted form of tmpPath & " | cut -f2 -d, "
	set sortedFileNames to (paragraphs of x)
	
	do shell script "rm -f " & tmpPath
	set AppleScript's text item delimiters to old_delims
	
	repeat with i from 2 to (count of sortedFileNames)
		set end of cmpData to item i of sortedFileNames
	end repeat
	append the theDataSource with cmpData
	return true
end setDataToTable

on padding_num(fileNamearr)
	set kzStr to make KZString of KZStrings
	set retarr to {}
	repeat with theItem in fileNamearr
		-- 数字の区切りを探す
		set kugiripos to my search_kugiri(theItem)
		
		if kugiripos is not 0 then
			
			-- 名前から数字を抜き出す
			set nameToNum to (text kugiripos thru (length of theItem) of theItem) as integer
			
			-- 桁数を調整(4桁固定)
			set paddedNum to kzStr's padd_num(4, nameToNum)
			
			-- ファイル名の配置はそのままpaddした数字を返す
			set end of retarr to (paddedNum as string)
		end if
	end repeat
	return retarr
end padding_num

on search_kugiri(n)
	set ret to 0
	-- 名前の最後から検索
	repeat with i from (length of n) to 1 by -1
		set chk to text i thru i of n
		
		if chk is " " then
			-- Acrobatでバラした場合は" "が区切りとなる
			set ret to i as integer
			exit repeat
			
		else if chk is "-" then
			-- Automaterでバラした場合は"-pagexxx"が区切りとなる
			set ret to (i as integer) + 5
			exit repeat
		end if
	end repeat
	if ret is not 0 then
		-- 区切り文字以降が数字かどうか？
		set ppos to search_period(n)
		set str to text ret thru (ppos - 1) of n
		try
			set str to str as integer
		on error
			set str to 0
		end try
		if str is not 0 then
			return ret as integer
		else
			return 0
		end if
	end if
	return 0
end search_kugiri

on search_period(n)
	set ret to 0
	-- 名前の最後から検索
	repeat with i from (length of n) to 1 by -1
		set chk to text i thru i of n
		
		if chk is "." then
			set ret to i as integer
			exit repeat
		end if
	end repeat
	return ret
end search_period
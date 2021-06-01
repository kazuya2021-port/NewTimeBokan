-- ??????.applescript
-- ??????

--  Created by ????? on 12/01/10.
--  Copyright 2012 __MyCompanyName__. All rights reserved.

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
property g_cur_process : ""

(*======================================*)
(* Custum *)
(*======================================*)

on choose menu item theObject
	set g_cur_process to title of theObject
	if name of theObject is "patterns" then
		
	end if
end choose menu item

on clicked theObject
	set w to tab view item "gray" of tab view "tab" of window "MainWin"
	if name of theObject is "go" then
		set tv to table view "files" of scroll view "files" of w
		set datasource to data source of tv
		set filenameList to contents of data cell 1 of every data row of datasource
		set filepathList to contents of data cell 2 of every data row of datasource
		
		set kzPath to make KZPathString of KZStrings
		set kzStr to make KZString of KZStrings
		
		set workdir to (POSIX path of (path to me) as Unicode text)
		set workdir to workdir & "Contents/Resources/"
		
		-- 書類フォルダ検索
		tell application "Finder"
			set AsavePath to (path to documents folder)
			set strSavePath to (POSIX path of AsavePath) as string
			set newFolderName to kzPath's last_item(item 1 of filepathList) & "_処理済み"
			
			if not (exists folder newFolderName of AsavePath) then
				make folder at AsavePath with properties {name:newFolderName}
			end if
			set savePath to strSavePath & newFolderName & "/"
			
		end tell
		
		-- PhotoShopタイムアウト
		with timeout of (1 * 60 * 60) seconds
			set a to count of filenameList
			
			repeat with i from 1 to a
				set cur_path to (item i of filepathList)
				set cur_file to (item i of filenameList)
				set reportTxt to ""
				
				tell application "/Applications/Adobe Acrobat DC/Adobe Acrobat Pro.app"
					if g_cur_process is equal to "グレー変換" then
						do script ("
						var openFile = \"" & cur_path & "/" & cur_file & ".pdf\";
						var extPath = \"" & cur_path & "/N" & cur_file & ".pdf\";
						var theDoc = app.openDoc(openFile);
						var toGRAY = theDoc.getColorConvertAction();
						toGRAY.matchAttributesAny = -1;
						toGRAY.matchSpaceTypeAny = ~toGRAY.constants.spaceFlags.AlternateSpace;
						toGRAY.matchIntent = toGRAY.constants.renderingIntents.Any;
						toGRAY.convertProfile = \"Dot Gain 15%\";
						toGRAY.embed = false;
						toGRAY.convertIntent = toGRAY.constants.renderingIntents.Document;
						toGRAY.action = toGRAY.constants.actions.Convert;
						toGRAY.preserveBlack = true;
						toGRAY.useBlackPointCompensation = true;

						theDoc.colorConvertPage(theDoc.pageNum,[toGRAY],[]);
						theDoc.saveAs(extPath);
						theDoc.closeDoc(true);
						")
					else if g_cur_process is equal to "白ページチェック" then
						set whitePageArr to do script ("
						var openFile = \"" & cur_path & "/" & cur_file & ".pdf\";
						var extPath = \"" & savePath & "\";
						var arr = new Array();
						var cnt = 0;

						// filename is the base name of the file Acrobat is working on
						var filename = \"" & cur_file & "\";
						var theDoc;
						var theDoc = app.openDoc({cPath:openFile, bHidden:true});

						console.clear(); console.show();

						for (i=0; i<theDoc.numPages; i++)
						{
							wd = theDoc.getPageNumWords(i);
							if(wd == 0)
							{
								var extFilePath = extPath+filename+\"_\"+i+\".pdf\";
								var extHtmPath = extPath+filename+\"_\"+i+\".html\";
								try{
									theDoc.extractPages(
									{
									nStart:i,
									nEnd:i,
									cPath:extFilePath
									});
								}catch(e){ console.printIn(\"Aborted: \"+e); }
								var tmpDoc = app.openDoc(extPath+filename+\"_\"+i+\".pdf\");
								var sizeOfPage = tmpDoc.filesize;

								if(sizeOfPage < 7000)
								{
									arr[cnt] = (i+1) + \"ページ \" + sizeOfPage + \" byte\";
									cnt++;
								}
								tmpDoc.closeDoc(true);
							}
						}
						theDoc.closeDoc(true);
						arr;
						")
						set whitePageArr to whitePageArr as string
						
						set reportTxt to reportTxt & "◆" & fn & "の白ページ" & return
						repeat with j from 1 to (length of whitePageArr)
							set oneCharacter to text j thru j of whitePageArr
							if oneCharacter is equal to "," then
								set reportTxt to reportTxt & return
							else
								set reportTxt to reportTxt & oneCharacter
							end if
						end repeat
						set reportTxt to reportTxt & return
						do shell script "echo \"" & reportTxt & "\" > \"" & savePath & "log.txt\""
					end if
				end tell
			end repeat
			set tv to table view "files" of scroll view "files" of w
			delete every data row of data source of tv
		end timeout
	else if name of theObject is "clearlist" then
		set tv to table view "files" of scroll view "files" of w
		delete every data row of data source of tv
	end if
end clicked


(*======================================*)
(* Functions *)
(*======================================*)
on setDataToTable(arrfile, theObject)
	set kzPath to make KZPathString of KZStrings
	set theDataSource to data source of theObject
	set cmpData to {}
	set sortDatas to {}
	
	repeat with theItem in arrfile
		set fileName to kzPath's last_item(theItem)
		set tFileName to kzPath's trim_ext(fileName)
		set theFilePath to trim_last_item(theItem) of kzPath
		set end of sortDatas to theFilePath & "," & tFileName & (ASCII character 10)
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
	
	set x to do shell script "cat " & quoted form of tmpPath & " | cut -f2 -d, "
	set sortedFileNames to (paragraphs of x)
	
	do shell script "rm -f " & tmpPath
	set AppleScript's text item delimiters to old_delims
	
	repeat with i from 2 to (count of sortedFileNames)
		set rowData to {}
		set end of rowData to item i of sortedFileNames
		set end of rowData to item i of sortedPath
		set end of cmpData to rowData
	end repeat
	append the theDataSource with cmpData
end setDataToTable


(*======================================*)
(* init UI *)
(*======================================*)
on awake from nib theObject
	set w to tab view item "gray" of tab view "tab" of window "MainWin"
	
	if (name of theObject is "files") then
		-- 処理対象データソース作成
		set theDataSource to make new data source at end of data sources with properties {name:"files"}
		-- カラム作成
		make new data column at end of data columns of theDataSource with properties {name:"fileName"}
		make new data column at end of data columns of theDataSource with properties {name:"path"}
		
		-- テーブルにデータソースを設定
		set data source of theObject to theDataSource
		
		-- ドラッグタイプ設定
		tell theObject to register drag types {"file names"}
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
		log theFiles
		set kzFm to make KZFileManager of KZFileManager
		set kzPath to make KZPathString of KZStrings
		set isFolder to is_directory((item 1 of theFiles), 1) of kzFm
		
		
		if (isFolder = 1) then
			set arrfile to file_list((item 1 of theFiles), 1) of kzFm
			
			if name of theObject is "cmp2" then
				if a_Folder is "" then
					set a_Folder to item 1 of theFiles
				end if
			end if
			my setDataToTable(arrfile, theObject)
			set update views of theDataSource to true
			return true
			
		end if
		if (count of theFiles) > 0 then
			
			if name of theObject is "cmp2" then
				if a_Folder is "" then
					set a_Folder to kzPath's trim_last_item((item 1 of theFiles))
				end if
			end if
			
			-- ドロップしたファイルをテーブルに設定
			my setDataToTable(theFiles, theObject)
			set update views of theDataSource to true
			return true
		end if
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


on will close theObject
	quit
end will close

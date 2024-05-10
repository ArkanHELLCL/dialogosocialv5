<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<%
	
	if(session("ds5_usrperfil")>2) then	'Todos menos el adm
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if
	
	
	Set up = New FreeASPUpload
	up.Upload()			
	
	Response.Flush
	
	REL_Id				= up.form("REL_Id")
	REL_Rut				= up.form("REL_Rut")
	Rut					= replace(replace(REL_Rut,"-",""),".","")
	REL_Rut				= Rut
	Rut					= mid(Rut,1,len(Rut)-1)	
	REL_Paterno			= LimpiarUrl(up.form("REL_Paterno"))
	REL_Materno			= LimpiarUrl(up.form("REL_Materno"))
	REL_Nombres			= LimpiarUrl(up.form("REL_Nombres"))
	EDU_Id				= up.form("EDU_Id")
	REL_NombreCarrera	= LimpiarUrl(up.form("REL_NombreCarrera"))
	REL_Estado			= up.form("REL_Estado")
	REL_AdjuntoX		= up.form("REL_AdjuntoX")
	SEX_Id				= up.form("SEX_Id")
	
	if(REL_Estado="") then
		REL_Estado=0		
	else
		REL_Estado=1	'on		
	end if
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión 1:" & ErrMsg)
	   response.End() 			   
	end if		
		
	path="D:\DocumentosSistema\dialogosocial\relatores\" & REL_Rut & "\"
	delpath="D:\DocumentosSistema\dialogosocial\relatores\" & trim(REL_Rut)
	

	if(REL_AdjuntoX)<>"" then
		set f=nothing
		set fs=nothing						

		folders = Split(path, "\")
		currentFolder = ""
		set fs=Server.CreateObject("Scripting.FileSystemObject")
		fs.DeleteFolder delpath
		
		For i = 0 To UBound(folders)
			currentFolder = currentFolder & folders(i)
			'response.write("</br>" & currentFolder & "</br>")
			If fs.FolderExists(currentFolder) <> true Then
				Set f=fs.CreateFolder(currentFolder)
				Set f=nothing       
			End If      
			currentFolder = currentFolder & "\"
		Next		

		ruta=path		
		up.Save(ruta)	'Subiendo archivo
		Set arc = New UploadedFile
		arc.FileName = REL_AdjuntoX
		REL_AdjuntoX = arc.FileName
	end if
	
	datos =  REL_Id & ",'" & REL_Paterno & "','" & REL_Materno & "','" & REL_Nombres & "','" & REL_RUT & "','" & REL_AdjuntoX & "'," & EDU_Id & ",'" & REL_NombreCarrera  & "'," & REL_Estado & "," & SEX_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	
	
	sql="exec [spRelator_Modificar] " & datos 	
	
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503\\Error Conexión 3:" & ErrMsg & "-" & sql)
	    response.End()
	End If
	
	if not rs.eof then		
		response.write("200\\" & texto & "\\" & REL_Id)
	end if			
	
%>
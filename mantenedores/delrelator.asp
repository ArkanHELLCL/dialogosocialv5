<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	splitruta=split(ruta,"/")	
	xm=splitruta(5)
	if(xm="modificar") then
		modo=2
		mode="mod"
	end if
	if(xm="visualizar") then
		modo=4
		mode="vis"
	end if		
	
	REL_Id  = request("REL_Id")
	REL_Rut = replace(replace(request("REL_Rut"),"-",""),".","")
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if		
	
	dim fs,f
	
	path="D:\DocumentosSistema\dialogosocial\relatores\" & trim(REL_Rut)
	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	fs.DeleteFolder path

	
	sqy="[spRelator_Eliminar] " & REL_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set ry = cnn.Execute(sqy)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description%>
		{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "Relator asociado a un proyecto. Imposible eliminar"}<%
		cnn.close 		
		response.end
	End If%>
	{"state": 200, "message": "Relator eliminado exitosamente","data": null}<%
%>
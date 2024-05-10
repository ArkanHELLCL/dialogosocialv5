<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%
	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, Admisnitrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if
		
	
	PRY_Id				= request("PRY_Id")	
	PRY_Identificador	= request("PRY_Identificador")
	MEN_Id				= request("MEN_Id")
	MEN_Texto			= LimpiarUrl(request("MEN_Texto"))
	TIP_Id				= 3		'Respuesta a Consulta	
	MEN_Archivo			= ""
				
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if			
	
	sqx="exec [spMensaje_Responder] " & MEN_Id & ",'" & MEN_Texto & "'," & TIP_Id & "," & PRY_Id & ",'" & PRY_Identificador & "','" & MEN_Archivo & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rx = cnn.Execute(sqx)	
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqx%>"}<%
		rs.close
		cnn.close
		response.end()
	End If	
	%>	
	{"state": 200, "message": "Grabación de respuesta correcta","data": null}
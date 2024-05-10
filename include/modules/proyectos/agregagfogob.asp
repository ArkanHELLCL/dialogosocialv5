<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor, Admisnitrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if
		
	PRY_Id				= request("PRY_Id")
	GFG_Nombre 			= LimpiarUrl(request("GFG_Nombre"))	
	GFG_Cargo			= LimpiarUrl(request("GFG_Cargo"))
	SEX_Id				= request("SEX_Id")	
	SER_Id				= request("SER_Id")	
	JGS_Justificacion	= ""
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if	
	
	
	set rx=cnn.execute("spRepProyectoGobierno_Listar 1," & PRY_Id & "," & SER_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if		
	
			
	set ry=cnn.execute("exec spGrupoFocalGobierno_Agregar "& PRY_Id & ",'" & GFG_Nombre & "','" & GFG_Cargo & "'," & SEX_Id & "," & SER_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
	on error resume next
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if		
	
	set ry=nothing%>	
	{"state": 200, "message": "Grabación de integrante de gobierno correcta","data": null}
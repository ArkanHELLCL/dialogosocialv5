<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then	'Ejecutor, Auditor%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if
		
	PRY_Id				= request("PRY_Id")
	RPE_Nombre 			= LimpiarUrl(request("RPE_Nombre"))
	RPE_ApellidoPaterno	= LimpiarUrl(request("RPE_ApellidoPaterno"))
	RPE_ApellidoMaterno	= LimpiarUrl(request("RPE_ApellidoMaterno"))
	Rut					= request("Rut_RPE")
	RPE_Rut				= mid(Rut,1,Len(Rut)-1)
	RPE_Dv				= mid(Rut,Len(Rut),1)
	RPE_Cargo			= LimpiarUrl(request("RPE_Cargo"))
	SEX_Id				= request("SEX_Id")
	RPE_Mail			= request("RPE_Mail")
	RPE_Telefono		= request("RPE_Telefono")	
	EMP_Id				= request("EMP_Id")
	RPE_Compromiso		= LimpiarUrl(request("RPE_Compromiso"))
	RPE_VerificadorCumplimiento = LimpiarUrl(request("RPE_VerificadorCumplimiento"))
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if	
	
	sqx="exec spRepProyectoEmpresa_Agregar " & EMP_Id & "," & PRY_Id & ",'" & RPE_Nombre & "','" & RPE_ApellidoPaterno & "','" & RPE_ApellidoMaterno & "'," & SEX_Id & ",'" & RPE_Cargo & "'," & RPE_Rut & ",'" & RPE_Dv & "','" & RPE_Telefono & "','" & RPE_Mail & "','" & RPE_Compromiso & "','" & RPE_VerificadorCumplimiento & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rx = cnn.Execute(sqx)	
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqx%>"}<%
		rs.close
		cnn.close
		response.end()
	End If%>	
	{"state": 200, "message": "Grabación de representante de empresa correcta","data": null}
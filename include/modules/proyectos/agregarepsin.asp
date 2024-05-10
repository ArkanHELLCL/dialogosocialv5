<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then	'Ejecutor, Auditor%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if
		
	PRY_Id				= request("PRY_Id")
	RPS_Nombre 			= LimpiarUrl(request("RPS_Nombre"))
	RPS_ApellidoPaterno	= LimpiarUrl(request("RPS_ApellidoPaterno"))
	RPS_ApellidoMaterno	= LimpiarUrl(request("RPS_ApellidoMaterno"))
	Rut					= request("Rut_RPS")
	RPS_Rut				= mid(Rut,1,Len(Rut)-1)
	RPS_Dv				= mid(Rut,Len(Rut),1)
	RPS_Cargo			= LimpiarUrl(request("RPS_Cargo"))
	SEX_Id				= request("SEX_Id")
	RPS_Mail			= request("RPS_Mail")
	RPS_Telefono		= request("RPS_Telefono")	
	SIN_Id				= request("SIN_Id")
	RPS_Compromiso		= LimpiarUrl(request("RPS_Compromiso"))
	RPS_VerificadorCumplimiento = LimpiarUrl(request("RPS_VerificadorCumplimiento"))
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if	
	
	sqx="exec spRepProyectoSindicato_Agregar " & SIN_Id & "," & PRY_Id & ",'" & RPS_Nombre & "','" & RPS_ApellidoPaterno & "','" & RPS_ApellidoMaterno & "'," & SEX_Id & ",'" & RPS_Cargo & "'," & RPS_Rut & ",'" & RPS_Dv & "','" & RPS_Telefono & "','" & RPS_Mail & "','" & RPS_Compromiso & "','" & RPS_VerificadorCumplimiento & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rx = cnn.Execute(sqx)	
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqx%>"}<%
		rs.close
		cnn.close
		response.end()
	End If%>	
	{"state": 200, "message": "Grabación de representante de sindicato correcta","data": null}
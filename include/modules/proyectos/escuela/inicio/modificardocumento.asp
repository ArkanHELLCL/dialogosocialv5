<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	VPR_Corr			= request("VPR_Corr")
	VER_Corr			= request("VER_Corr")
	PRY_Id				= request("PRY_Id")
	PRY_Identificador	= request("PRY_Identificador")
	PRY_Hito			= request("PRY_Hito")
	VPR_Estado			= 1	'request("VPR_Estado")
	VPR_Descripcion		= "" 'request("VPR_Descripcion")
	VPR_EstadoSubido	= request("VPR_EstadoSubido")
	VPR_EstadoRevisado	= request("VPR_EstadoRevisado")
	VPR_EstadoAprobado	= request("VPR_EstadoAprobado")
	VPR_EstadoRechazado = request("VPR_EstadoRechazado")
	
	if(VPR_EstadoSubido="" or IsNull(VPR_EstadoSubido)) then
		VPR_EstadoSubido="NULL"		
	end if
	if(VPR_EstadoRevisado="" or IsNull(VPR_EstadoRevisado)) then
		VPR_EstadoRevisado="NULL"		
	end if
	if(VPR_EstadoAprobado="" or IsNull(VPR_EstadoAprobado)) then
		VPR_EstadoAprobado="NULL"		
	end if
	if(VPR_EstadoRechazado="" or IsNull(VPR_EstadoRechazado)) then
		VPR_EstadoRechazado="NULL"		
	end if

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if		
	sql="exec [spVerificadorProyecto_Modificar] " & VPR_Corr & "," & VER_Corr & "," & PRY_Id & ",'" & PRY_Identificador & "'," & VPR_Estado & ",'" & VPR_Descripcion & "'," & VPR_EstadoSubido & "," & VPR_EstadoRevisado & "," & VPR_EstadoAprobado & "," & VPR_EstadoRechazado & "," & PRY_Hito & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": <%=sql%>}<%
		rs.close
		cnn.close
		response.end()
	End If%>	
	{"state": 200, "message": "Ejecución exitosa","data": "null"}<%	
	
	cnn.close
	set cnn = nothing
%>
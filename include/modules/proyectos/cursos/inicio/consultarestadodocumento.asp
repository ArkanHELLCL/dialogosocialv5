<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	VPR_Corr			= request("VPR_Corr")	
	PRY_Id				= request("PRY_Id")
	PRY_Identificador	= request("PRY_Identificador")	

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if		
	sql="exec [spVerificadorProyecto_Consultar] " & VPR_Corr & "," & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": <%=sql%>}<%
		rs.close
		cnn.close
		response.end()
	End If
		
	if not rs.eof then
		VPR_EstadoRevisado=rs("VPR_EstadoRevisado")		
		VPR_EstadoAprobado=rs("VPR_EstadoAprobado")			
		VPR_EstadoRechazado=rs("VPR_EstadoRechazado")	
		
		'if(VPR_EstadoSubido="" or IsNull(VPR_EstadoSubido)) then
		''	VPR_EstadoSubido="NULL"		
		'end if
		if(VPR_EstadoRevisado="" or IsNull(VPR_EstadoRevisado) or VPR_EstadoRevisado=0) then
			VPR_EstadoRevisado=0		
		end if
		if(VPR_EstadoAprobado="" or IsNull(VPR_EstadoAprobado) or VPR_EstadoAprobado=0) then
			VPR_EstadoAprobado=0		
		end if
		if(VPR_EstadoRechazado="" or IsNull(VPR_EstadoRechazado) or VPR_EstadoRechazado=0) then
			VPR_EstadoRechazado=0		
		end if
	end if%>	
	{"state": 200, "message": "Ejecución exitosa","data":[{"VPR_EstadoRevisado":<%=VPR_EstadoRevisado%>},{"VPR_EstadoAprobado":<%=VPR_EstadoAprobado%>},{"VPR_EstadoRechazado":<%=VPR_EstadoRechazado%>}]}<%	
	
	cnn.close
	set cnn = nothing
%>
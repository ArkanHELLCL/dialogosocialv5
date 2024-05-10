<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	OES_Id				= request("OES_Id")	

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if		
	sql="exec [spObjetivoEspecifico_Consultar] " & OES_Id
			
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": <%=sql%>}<%
		rs.close
		cnn.close
		response.end()
	End If
		
	if not rs.eof then
		OES_EstadoRevisado=rs("OES_EstadoRevisado")		
		OES_EstadoAprobado=rs("OES_EstadoAprobado")			
		OES_EstadoRechazado=rs("OES_EstadoRechazado")	
		
		'if(VPR_EstadoSubido="" or IsNull(VPR_EstadoSubido)) then
		''	VPR_EstadoSubido="NULL"		
		'end if
		if(OES_EstadoRevisado="" or IsNull(OES_EstadoRevisado) or OES_EstadoRevisado=0) then
			OES_EstadoRevisado=0		
		end if
		if(OES_EstadoAprobado="" or IsNull(OES_EstadoAprobado) or OES_EstadoAprobado=0) then
			OES_EstadoAprobado=0		
		end if
		if(OES_EstadoRechazado="" or IsNull(OES_EstadoRechazado) or OES_EstadoRechazado=0) then
			OES_EstadoRechazado=0		
		end if
	end if%>	
	{"state": 200, "message": "Ejecución exitosa","OES_EstadoRevisado":<%=OES_EstadoRevisado%>,"OES_EstadoAprobado":<%=OES_EstadoAprobado%>,"OES_EstadoRechazado":<%=OES_EstadoRechazado%>}<%	
	
	cnn.close
	set cnn = nothing
%>
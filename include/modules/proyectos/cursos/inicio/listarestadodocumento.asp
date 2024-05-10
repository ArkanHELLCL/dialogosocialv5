<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
		
	PRY_Id				= request("PRY_Id")
	PRY_Identificador	= request("PRY_Identificador")	
	PRY_Hito			= request("PRY_Hito")

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if		
	
	sql="exec [spVerificadorProyecto_Listar] 1," & PRY_Id & "," & PRY_Hito & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": <%=sql%>}<%
		rs.close
		cnn.close
		response.end()
	End If
	
	VPR_EstadoSubidoTotal=0
	VPR_EstadoRevisadoTotal=0
	VPR_EstadoAprobadoTotal=0
	VPR_EstadoRechazadoTotal=0
	VPR_Total=0	
	do while not rs.eof				
		VPR_EstadoSubido=rs("VPR_EstadoSubido")
		VPR_EstadoRevisado=rs("VPR_EstadoRevisado")		
		VPR_EstadoAprobado=rs("VPR_EstadoAprobado")			
		VPR_EstadoRechazado=rs("VPR_EstadoRechazado")	

		if(VPR_EstadoSubido="" or IsNull(VPR_EstadoSubido) or VPR_EstadoSubido=0) then
			VPR_EstadoSubido=0
		else
			VPR_EstadoSubidoTotal=VPR_EstadoSubidoTotal+1
		end if
		if(VPR_EstadoRevisado="" or IsNull(VPR_EstadoRevisado) or VPR_EstadoRevisado=0) then
			VPR_EstadoRevisado=0		
		else
			VPR_EstadoRevisadoTotal=VPR_EstadoRevisadoTotal+1
		end if
		if(VPR_EstadoAprobado="" or IsNull(VPR_EstadoAprobado) or VPR_EstadoAprobado=0) then
			VPR_EstadoAprobado=0
		else
			VPR_EstadoAprobadoTotal=VPR_EstadoAprobadoTotal+1
		end if
		if(VPR_EstadoRechazado="" or IsNull(VPR_EstadoRechazado) or VPR_EstadoRechazado=0) then
			VPR_EstadoRechazado=0
		else
			VPR_EstadoRechazadoTotal=VPR_EstadoRechazadoTotal+1
		end if		
		VPR_Total=VPR_Total+1		
		rs.movenext
	loop%>
	{"state": 200, "message": "Ejecución exitosa","VPR_EstadoSubidoTotal":<%=VPR_EstadoSubidoTotal%>,"VPR_EstadoRevisadoTotal":<%=VPR_EstadoRevisadoTotal%>,"VPR_EstadoAprobadoTotal":<%=VPR_EstadoAprobadoTotal%>,"VPR_EstadoRechazadoTotal":<%=VPR_EstadoRechazadoTotal%>,"VPR_Total":<%=VPR_Total%>}<%	
	
	cnn.close
	set cnn = nothing
%>
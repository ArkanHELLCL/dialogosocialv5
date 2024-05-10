<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=2 and session("ds5_usrperfil")=4 and session("ds5_usrperfil")=5) then	'Revisor, Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	PRY_Id				= Request("PRY_Id")
	PRY_Identificador	= Request("PRY_Identificador")
	PRY_Hito			= Request("PRY_Hito")

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if		
	
	if PRY_Id>0 then
		TotalDocumentos=0
		sql="exec spDocumento_Listar " & PRY_Id & ",'" & PRY_Identificador & "'," & PRY_Hito
		set rs = cnn.Execute(sql)
		'response.write(sql)
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description			
			cnn.close%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
			response.End()
		End If
		do while not rs.EOF
			TotalDocumentos=TotalDocumentos+1				
			rs.movenext
		loop
		rs.Close
		cnn.close
		set cnn = nothing
		
		if TotalDocumentos>0 then%>
			{"state": 200, "message": "Ejecución exitosa","data": <%=TotalDocumentos%>}<%
		else%>
			{"state": 200, "message": "Ejecución exitosa","data": 0}<%
		end if
	End If  	

%>
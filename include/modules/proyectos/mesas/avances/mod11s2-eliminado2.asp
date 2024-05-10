<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor, administrativo
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id				= request("PRY_Id")
	PRY_Identificador	= request("PRY_Identificador")	
	CRT_Step			= request("Step")
	PRY_Hito			= request("PRY_Hito")

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
	sql="exec spProyectoStepForward_Agregar " & PRY_Id & ",'" & PRY_Identificador & "'," & CRT_Step & "," & PRY_Hito & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		response.Write("503\\Error Conexión:" & sql)
		rs.close
		cnn.close
		response.end()
	End If
	if not rs.eof then
		PRY_Step = rs("PRY_Step")
	else
		response.Write("2")
		rs.close
		cnn.close
		response.end()
	end if			
	response.write("200\\" & PRY_Step)		
	
	cnn.close
	set cnn = nothing
%>
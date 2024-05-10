<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%
	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id				= request("PRY_Id")
	PRY_Identificador	= request("PRY_Identificador")
	PRY_ObjetivoGeneral = LimpiarUrl(request("PRY_ObjetivoGeneral"))
	Step     		 	= CInt(request("Step"))

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if	
	
	xsql = "exec spProyecto_Consultar " & PRY_Id
	set rs = cnn.Execute(xsql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		response.Write("503\\Error Conexión 2:" & ErrMsg & "-" & xsql)
		rs.close
		cnn.close
		response.end()
	End If
	if not rs.eof then
		PRY_Step=rs("PRY_Step")
		LFO_Id = rs("LFO_Id")
				
		PRY_CreacionProyectoEstado=rs("PRY_CreacionProyectoEstado")
	else
		response.Write("2")
		rs.close
		cnn.close
		response.end()
	end if	
	
	if PRY_Step=Step and PRY_CreacionProyectoEstado=0 then
		PRY_Step = PRY_Step + 1	'Siguiente paso
	end if	
	
	sql="exec spProyecto_ObjetivoProyectoModificar " & PRY_Id & ",'" & PRY_Identificador & "','" & PRY_ObjetivoGeneral & "'," & PRY_Step & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
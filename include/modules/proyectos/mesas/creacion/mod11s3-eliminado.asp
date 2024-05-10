<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id							= request("PRY_Id")
	PRY_Identificador		        = request("PRY_Identificador")
	
	PRY_FechaTramitacionContrato    = request("PRY_FechaTramitacionContrato")
    PRY_FechaGruposFocales          = request("PRY_FechaGruposFocales")
    PRY_FechaReunionActoresMesa     = request("PRY_FechaReunionActoresMesa")
    PRY_FechaSeminarioResultados    = request("PRY_FechaSeminarioResultados")
	Step						    = CInt(request("Step"))	

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if	

    set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		response.Write("503\\Error Conexión:" & ErrMsg)
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
	
	datos =  PRY_Id & ",'" & PRY_Identificador & "','" & PRY_FechaTramitacionContrato & "','" & PRY_FechaGruposFocales & "','" & PRY_FechaReunionActoresMesa & "','" & PRY_FechaSeminarioResultados & "'," & PRY_Step & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	
	sql="exec [spProyectoFechasRelevantes_Modificar] " & datos 

	set rs=cnn.execute(sql)
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   'response.write ErrMsg & " strig= " & sql
	   response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)	   
	   rs.close
	   cnn.close
	   response.end()			
	end if	
	response.write("200\\")		
	
	cnn.close
	set cnn = nothing
%>
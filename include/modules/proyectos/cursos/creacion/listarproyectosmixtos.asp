<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	LIN_Id=request("LIN_Id")	
	EME_Id=request("EME_Id")
	REG_Id=request("REG_Id")
	PRY_CodigoAsociado=request("PRY_CodigoAsociado")
	PRY_Id=request("PRY_Id")
	mode=request("mode")
	if(PRY_CodigoAsociado="") then
		PRY_CodigoAsociado="NULL"
	end if
		
	sql="exec [spProyectoMixtos_Listar] " & LIN_Id & "," & PRY_Id & "," & REG_Id & "," & EME_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
	
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)
	    response.End()
	End If
	response.write("200\\")
	
	if(mode="add") or (PRY_CodigoAsociado=0) then%>
		<option value="" selected></option><%
	else%>
		<option value=""></option><%
	end if
					
	do While Not rs.eof
		if CInt(rs("PRY_Id"))=CInt(PRY_CodigoAsociado) then%>
			<option value="<%=rs("PRY_Id")%>" selected ><%=rs("PRY_Id")%>&nbsp;-&nbsp;<%=rs("PRY_Nombre")%></option><%
		else%>
			<option value="<%=rs("PRY_Id")%>"><%=rs("PRY_Id")%>&nbsp;-&nbsp;<%=rs("PRY_Nombre")%></option><%
		end if
		rs.movenext						
	loop
	rs.Close
%>
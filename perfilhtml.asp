<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE FILE="include\template\session.min.inc" -->
<%					
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
    cnn.open session("DSN_DialogoSocialv5")
	
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if			
	
	if isEmpty(session("ds5_usrid")) or isNull(session("ds5_usrid")) then
		response.Write("500/@/Error Parámetros no válidos")
		response.end()
	end if				
	
	sql="exec spPerfil_Listar -1"
	'response.write(sql)
	
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("503/@/Error SQL: " & ErrMsg & "-" & sql)
		cnn.close 			   
		response.end()		
	End If		
	response.write("200/@/")		
	do While (Not rs.EOF)%>
		<tr>			
			<td><%=rs("PER_Id")%></td>
			<td><%=rs("PER_Nombre")%></td>			
			<td><%	if rs("PER_Estado")=1 then
						response.write("Activo")
					else
						response.write("Bloqueado")
					end if%></td>  			
			</tr><%
		rs.MoveNext
  Loop   	   					  
   
  rs.Close
  cnn.Close
%>

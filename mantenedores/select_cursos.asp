<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>

<%
	LIN_Id	= Request("LIN_Id")	
	MOD_Id	= Request("MOD_Id")
	
	if(IsNULL(LIN_Id) or LIN_Id="" or LIN_Id<1) then
		LIN_Id=-1
	end if
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503//Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if				
	
	if((MOD_Id="") or (mode="add")) then%>
		<option value="" disabled selected></option><%
	end if
	set rs = cnn.Execute("exec spModuloLinea_Consultar " & LIN_Id)
	on error resume next					
	do While Not rs.eof
		if(MOD_Id = rs("MOD_Id")) then%>
			<option value="<%=rs("MOD_Id")%>" selected><%=rs("MOD_Nombre")%></option><%
		else%>
			<option value="<%=rs("MOD_Id")%>"><%=rs("MOD_Nombre")%></option><%
		end if
		rs.movenext						
	loop
	rs.Close
	'response.end
%>
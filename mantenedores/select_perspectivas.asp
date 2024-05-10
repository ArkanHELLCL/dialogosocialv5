<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>

<%
	MOD_Id	= Request("MOD_Id")
	PER_Id	= Request("PER_Id")
	
	if(IsNULL(MOD_Id) or MOD_Id="" or MOD_Id<1) then
		MOD_Id=-1
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
	
	if((PER_Id="") or (mode="add")) then%>
		<option value="" disabled selected></option><%
	end if
	set rs = cnn.Execute("exec spPerspectiva_Listar " & MOD_Id)
	on error resume next					
	do While Not rs.eof
		if(PER_Id = rs("PER_Id")) then%>
			<option value="<%=rs("PER_Id")%>" selected><%=rs("PER_Nombre")%></option><%
		else%>
			<option value="<%=rs("PER_Id")%>"><%=rs("PER_Nombre")%></option><%
		end if
		rs.movenext						
	loop
	rs.Close
	'response.end
%>
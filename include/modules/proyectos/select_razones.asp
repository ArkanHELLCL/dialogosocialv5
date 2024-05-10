<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>

<%
	CDE_InfoCausaId	= Request("CDE_InfoCausaId")

	sql="exec spRazonDesercion_Listar " & CDE_InfoCausaId
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   'response.Write("503//Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if				
	if CDE_InfoCausaId>0 then
		set rs = cnn.Execute(sql)
		' response.Write(sql)
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description
		    'response.Write("503//Error Conexión:" & ErrMsg)	   		
		    rs.close
		    cnn.close
			response.End()
		Else
			'response.write("200//")%>
			<option value="" disabled selected></option><%
			do While Not rs.EOF 				
				response.Write("<option value='" & rs("RDE_InfoRazonId") & "'>" & rs("RDE_InfoRazonDesercion") & "</option>")				
				rs.MoveNext
			loop
			rs.Close
		End If  
		cnn.close

		set cnn = nothing
	end if	
	'response.end
%>
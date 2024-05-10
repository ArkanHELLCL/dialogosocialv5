<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>

<%
	REG_Id	= Request("REG_Id")

	sql="exec spRegionxMacrozona_Consultar " & REG_Id
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   'response.Write("503//Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if				
	if REG_id>0 then
		set rs = cnn.Execute(sql)
		' response.Write(sql)
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description
		    'response.Write("503//Error Conexión:" & ErrMsg)	   		
		    rs.close
		    cnn.close
			response.End()
		Else			
			if Not rs.EOF then
                response.Write(rs("MCZ_Descripcion"))
            else
                response.Write("No encontrado")
			end if
			rs.Close
		End If  
		cnn.close

		set cnn = nothing
	end if	
	'response.end
%>
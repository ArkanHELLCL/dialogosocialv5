<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
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
		
	set rs = cnn.Execute("exec spLineaFormativaLicitacion_Listar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("exec spLineaFormativaLicitacion_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataLineaformativalicitacion = "{""data"":["
	do While Not rs.EOF
		if rs("LLC_Estado")=1 then
			estado="Activado"
		else
			estado="Desactivado"
		end if						
		
		dataLineaformativalicitacion = dataLineaformativalicitacion & "[""" & rs("LLC_Id") & """,""" & rs("LFO_Id") & """,""" & rs("LFO_Nombre") & """,""" & rs("LLC_IdLicitacion") & """,""" & estado & """]"		
		rs.movenext
		if not rs.eof then
			dataLineaformativalicitacion = dataLineaformativalicitacion & ","
		end if
	loop
	dataLineaformativalicitacion=dataLineaformativalicitacion & "]}"
	
	response.write(dataLineaformativalicitacion)
%>
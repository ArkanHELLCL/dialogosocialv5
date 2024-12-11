<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403/@/Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id	= request("PRY_Id")	
	REL_Id	= request("REL_Id")
	TRE_Id	= request("TRE_Id")
			
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
	
	sql = "exec [spRelatoresProyecto_Listar] " & PRY_Id
	set rs = cnn.Execute(sql)	
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503/@/Error Conexión:" & ErrMsg & "-" & sql)
	    response.End()
	End If
	
	existe=false
	do while(not rs.eof)
		if(CInt(REL_Id)=CInt(rs("REL_Id"))) then
			existe=true
		end if
		rs.movenext
	loop
	
	if(existe) then
		response.Write("1/@/Error: El relator ya esta asociado a este proyecto")
	    response.End()
	end if
	
	sql = "exec [spRelatorProyecto_agregar] " & REL_Id & "," & PRY_Id & "," & TRE_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503/@/Error Conexión:" & ErrMsg & "-" & sql)
	    response.End()
	End If								
	rs.close							
	
	response.write("200/@/" & dataObjetivosMark)
%>
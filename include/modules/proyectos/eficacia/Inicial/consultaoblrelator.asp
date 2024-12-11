<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	TIM_Id				= request("TIM_Id")    

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if		
	sql="exec [spTipoMesa_Consultar] " & TIM_Id
			
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": <%=sql%>}<%
		rs.close
		cnn.close
		response.end()
	End If
		
	if not rs.eof then
		TIM_RelatorObligatorio=rs("TIM_RelatorObligatorio")
	end if
    if(TIM_RelatorObligatorio="" or IsNULL(TIM_RelatorObligatorio)) then
        TIM_RelatorObligatorio=0
    end if%>	
	{"state": 200, "message": "Ejecución exitosa","TIM_RelatorObligatorio":<%=TIM_RelatorObligatorio%>}<%	
	
	cnn.close
	set cnn = nothing
%>
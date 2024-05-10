<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'ejecutor, Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	INC_Id				= Request("INC_Id")
	INC_Incumplimiento	= LimpiarUrl(Request("INC_Incumplimiento"))
	INC_Monto			= Request("INC_Monto")	
	MON_Id				= Request("MON_Id")
	GRA_Id				= Request("GRA_Id")
	UME_Id				= Request("UME_Id")			
	INC_Estado			= Request("INC_Estado")	
	BAS_Id           	= Request("BAS_Id")
	
  
	datos =   INC_Id & "," & UME_Id & "," & MON_Id & "," & GRA_Id & ","	& BAS_Id & ",'" & INC_Incumplimiento & "'," & INC_Monto & "," & INC_Estado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data" : "<%=datos%>"}<%
	   response.End() 			   
	end if		
	
	sql="exec [spIncumplimientos_Modificar] " & datos 
	
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()
	End If					
	
	cnn.close
	set cnn = nothing%>
	{"state": 200, "message": "Ejecución exitosa","data": null}
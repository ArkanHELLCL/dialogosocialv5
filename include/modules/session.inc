<%
Response.AddHeader "Refresh",CStr(CInt(Session.Timeout + 1) * 20)	'60*8
Response.AddHeader "cache-control", "private"
Response.AddHeader "Pragma","No-Cache"
Response.Buffer = TRUE
Response.Expires = -1
Response.ExpiresAbsolute = 0
Response.CharSet = "utf-8"
Session.Timeout=20

HostName = "https://" & Request.ServerVariables("SERVER_NAME")

If (Session("audinte") <> Session.SessionID) Then
	Session("RequestedURL") = "https://" & _
	    Request.ServerVariables("SERVER_NAME") & _
		Request.ServerVariables("SCRIPT_NAME")

	Temp = Request.ServerVariables("QUERY_STRING")
	If (Not(ISNull(Temp)) AND Temp <> "") Then
		Session("RequestedURL") = Session("RequestedURL") & _
		    "?" & Temp
	End If	
	Response.Redirect(HostName)
Else		
	ai_usrperfil 	= session("ai_usrperfil")
	ai_usuario 		= session("ai_usuario")
	ai_usrnom 		= session("ai_usrnom")
	ai_usrid 		= session("ai_usrid")
	ai_usrtoken	 	= session("ai_usrtoken")
	audinte 		= session("audinte")
	
	'Obteniendo nombre de la pagina actual
	
	ruta = Request.ServerVariables("URL") 'recoge la ruta completa
	ruta = Split(ruta,"/") 'convierte cada separación señalada por / en un elemento de un vector
	
	PaginaActual = ruta(UBound(ruta)) 'recogemos el último elemento de ese vector...	
	
	MP = Split(PaginaActual,".")
	MasterPage =  MP(LBound(MP)) 'Pagina actual sin extension			
	
End If
%>
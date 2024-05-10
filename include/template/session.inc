<%
'Response.AddHeader "Refresh",CStr(CInt(Session.Timeout + 1) * 60 * 21)	'21 minutos
Response.AddHeader "cache-control", "private"
Response.AddHeader "Pragma","No-Cache"
Response.Buffer = TRUE
Response.Expires = -1
Response.ExpiresAbsolute = 0
Response.CharSet = "utf-8"
Session.Timeout=60 * 8	'20 mnutos

HostName = "https://" & Request.ServerVariables("SERVER_NAME")

If (Session("dialogosocialv5") <> Session.SessionID) Then
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
	ds5_usrperfil 	= session("ds5_usrperfil")
	ds5_usuario 	= session("ds5_usuario")
	ds5_usrnom 		= session("ds5_usrnom")
	ds5_usrid 		= session("ds5_usrid")
	ds5_usrtoken	= session("ds5_usrtoken")
	dialogosocialv5 = session("dialogosocialv5")
	
	'Obteniendo nombre de la pagina actual
	
	ruta = Request.ServerVariables("URL") 'recoge la ruta completa
	ruta = Split(ruta,"/") 'convierte cada separación señalada por / en un elemento de un vector
	
	PaginaActual = ruta(UBound(ruta)) 'recogemos el último elemento de ese vector...	
	
	MP = Split(PaginaActual,".")
	MasterPage =  MP(LBound(MP)) 'Pagina actual sin extension			
	
End If
%>
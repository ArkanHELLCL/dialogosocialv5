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
	
	set rs = cnn.Execute("exec spLinea_Listar -1, -1") 'todos
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spLinea_Listar")
		cnn.close 		
		response.end
	End If	
	cont=0
	dataDocumentos = "{""data"":["
	do While Not rs.EOF 
		set rsx = cnn.Execute("exec spVerificador_Listar " & rs("LIN_Id") & ",-1")
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description
			response.write("Error spVerificador_Listar")
			cnn.close 		
			response.end
		End If	
		do While Not rsx.EOF
			if cont>0 then
				dataDocumentos = dataDocumentos & ","
			end if
			if(rs("LFO_Id")=10) then
				if(rsx("VER_NumeroInforme")=0) then
					Informe="Todos"
				else
					if(rsx("VER_NumeroInforme")=1) then
						Informe="Inicio"
					else
						if(rsx("VER_NumeroInforme")=2) then
							'Informe="Parcial"
							Informe="Desarrollo"
						else
							if(rsx("VER_NumeroInforme")=3) then
								Informe="Final"
							else
								Informe="No definido"
							end if
						end if
					end if
				end if
			else
				if(rs("LFO_Id")=11) then
					if(rsx("VER_NumeroInforme")=0) then
						Informe="Todos"
					else
						if(rsx("VER_NumeroInforme")=1) then
							Informe="Inicial"
						else
							if(rsx("VER_NumeroInforme")=2) then
								Informe="Desarrollo"
							else
								if(rsx("VER_NumeroInforme")=3) then
									Informe="Sistematización"
								else
									Informe="No definido"
								end if
							end if
						end if
					end if
				else
					if(rs("LFO_Id")=12) then
						if(rsx("VER_NumeroInforme")=0) then
							Informe="Todos"
						else
							if(rsx("VER_NumeroInforme")=1) then
								Informe="Inicio"
							else
								if(rsx("VER_NumeroInforme")=2) then
									Informe="Final"
								else
									Informe="No definido"
								end if
							end if
						end if
					else
						if(rs("LFO_Id")=13) then
							if(rsx("VER_NumeroInforme")=0) then
								Informe="Todos"
							else
								if(rsx("VER_NumeroInforme")=1) then
									Informe="Inicio"
								else
									if(rsx("VER_NumeroInforme")=2) then
										Informe="Desarrollo"
									else
										if(rsx("VER_NumeroInforme")=3) then
											Informe="Final"
										else
											Informe="No definido"
										end if
									end if
								end if
							end if
						else
							Informe="Linea no definida"
						end if
					end if
				end if
			end if
			dataDocumentos = dataDocumentos & "[""" & rs("LFO_Id") & """,""" & rs("LFO_Nombre") & """,""" & rs("LIN_Id") & """,""" & rs("LIN_Nombre") & """,""" & rsx("VER_NumeroInforme") & """,""" & Informe & """,""" & rsx("VER_Corr") & """,""" & rsx("VER_Descripcion") & """]"

			rsx.movenext			
			cont=cont+1
		loop
		rs.movenext		
	loop
	dataDocumentos=dataDocumentos & "]}"
	
	response.write(dataDocumentos)
%>
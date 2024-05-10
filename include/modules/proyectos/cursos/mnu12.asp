<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	modo=request("modo")
	PRY_Id=request("PRY_Id")
	CRT_Step=request("CRT_Step")	'Paso seleccioando
	PRY_Hito=request("PRY_Hito")	'Hito seleccionado
	LIN_Id=request("LIN_Id")
	Modulo=request("Modulo")		'Opcion para no cargar el paso actual
	if(Modulo="") then
		Modulo=true					'Por defecto siempre se carga la paso actual
	end if
	
	key1=request("key1")
	key2=request("key2")
	key3=request("key3")
	key4=request("key4")
	key5=request("key5")
	
	xPRY_Id = PRY_Id
	xPRY_Hito = PRY_Hito
	xCRT_Step = CRT_Step	
	xmodo = modo	
	
	
	if(PRY_Id="") then
		PRY_Id = key2
	end if
	if(LIN_Id="") then
		LIN_Id = key1		
	end if
	if(PRY_Hito="") then
		PRY_Hito = key3		
	end if
	if(CRT_Step="") then
		CRT_Step = key4
	end if	
	if(CRT_Step="") then
		CRT_Step = 1
	end if	
	
	PRY_CreacionProyectoEstado=0
	PRY_InformeInicioEstado=0	
	PRY_InformeFinalEstado=0
	PRY_InformeInicioAceptado=0	
	PRY_InformeFinalAceptado=0
	USR_IdRevisor=0
	
	observaciones=false
	existe_archivo=false
		
	ruta=replace(ruta,"#","")
	splitruta=split(ruta,"/")
	if(UBound(splitruta))>=5 then
		xm=splitruta(5)
	else
		xm="modificar"
	end if
	if(xm="modificar") then
		modo=2
		mode="mod"
		if(PRY_Id="") then
			PRY_Id=splitruta(7)
		end if
		if(LIN_Id="") then
			LIN_Id=splitruta(6)
		end if
	end if
	if(xm="visualizar") then
		modo=4
		mode="vis"
		PRY_Id=splitruta(7)
		if(LIN_Id="") then
			LIN_Id=splitruta(6)
		end if
	end if
	if((xm="agregar") and (modo="") or (modo=1)) then
		modo=1
		mode="add"
		PRY_Id=0
		CRT_Step=1
	end if
	if((xm="agregar") and (modo=2)) then		
		mode="mod"
		modo=2
		if(PRY_Id="") then
			PRY_Id=splitruta(7)
		end if
		if(LIN_Id="") then
			LIN_Id=splitruta(6)
		end if
	end if
	
	CRT_Step=CInt(CRT_Step)	
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
	
	if(LIN_Id<>"") then
		LIN_Id=CInt(LIN_Id)
		sql="exec spLinea_Consultar " & LIN_Id
		set rs = cnn.Execute(sql)
		if not rs.eof then
			titulo = rs("LFO_Nombre") & " " & rs("LIN_Nombre")
			LFO_Id = rs("LFO_Id")
			LIN_AgregaTematica = rs("LIN_AgregaTematica")			
		end if
	end if
	
	sql="exec spProyecto_Consultar " & PRY_Id
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503/@/Error Conexión:" & ErrMsg)
	    response.End()
	End If
	
	nuevo=false
	if not rs.eof then
		PRY_Identificador=rs("PRY_Identificador")
		PRY_Step=rs("PRY_Step")
		PRY_Estado=rs("PRY_Estado")
		PRY_CreacionProyectoEstado=rs("PRY_CreacionProyectoEstado")
		PRY_InformeInicioEstado=rs("PRY_InformeInicioEstado")	
		PRY_InformeFinalEstado=rs("PRY_InformeFinalEstado")
		
		PRY_InformeInicioAceptado=rs("PRY_InformeInicioAceptado")		
		PRY_InformeFinalAceptado=rs("PRY_InformeFinalAceptado")
		
		USR_IdRevisor=rs("USR_IdRevisor")
		PRY_Carpeta=rs("PRY_Carpeta")
	else
		if modo<>1 then
			response.Write("100/@/Error: Sin información " & modo & "-" & PRY_Id)
	    	response.End()
		else
			nuevo=true
		end if
	end if
	
	if(PRY_CreacionProyectoEstado="") then
		PRY_CreacionProyectoEstado=0
	end if
	if(PRY_InformeInicioEstado="") then
		PRY_InformeInicioEstado=0
	end if
	
	if(PRY_InformeFinalEstado="") then
		PRY_InformeFinalEstado=0
	end if
	
	if(IsNull(PRY_InformeInicioAceptado)) then
		PRY_InformeInicioAceptado=0
	end if
	
	if(IsNull(PRY_InformeFinalAceptado)) then
		PRY_InformeFinalAceptado=0
	end if
	xPRY_Hito = PRY_Hito

	menulen=0

	'Cursos
	if(PRY_CreacionProyectoEstado=0) and (PRY_Hito>0 or PRY_Hito="") then
		PRY_Hito=0
	else
		if((PRY_InformeInicioEstado=0) and (PRY_Hito>1 or PRY_Hito="")) or (PRY_InformeInicioEstado=1 and PRY_InformeInicioAceptado=0 and PRY_Hito="") then
			PRY_Hito=1
		else		
			if((PRY_InformeFinalEstado=0) and (PRY_Hito>2 or PRY_Hito="")) or (PRY_InformeFinalEstado=1 and PRY_InformeFinalAceptado=0 and PRY_Hito="") then
				PRY_Hito=2
			else

			end if			
		end if
	end if		
	'Cursos
	yPRY_Hito = PRY_Hito
	
	if PRY_Estado=1 then 'Modificar
		if PRY_Hito=0 and PRY_CreacionProyectoEstado=1 then	'Hito creacion
			if not LIN_AgregaTematica and CRT_Step>=4 then
				PRY_Hito=1
				CRT_Step=1
			else
				if LIN_AgregaTematica and CRT_Step>=5 then
					PRY_Hito=1
					CRT_Step=1
				end if
			end if
		else
			if PRY_Hito=1 and PRY_InformeInicioEstado=1 and CRT_Step>5 then	'Hito Inicio
				if(PRY_InformeInicioEstado=1 and PRY_InformeInicioAceptado=0) then
					PRY_Hito=1
					CRT_Step=7
				else				
					PRY_Hito=2
					CRT_Step=1
				end if
			else				
				if PRY_Hito=2 and PRY_InformeFinalEstado=1 and CRT_Step>=6 then 'Hito Final
					if(PRY_InformeFinalEstado=1 and PRY_InformeFinalAceptado=0) then
						PRY_Hito=2
						CRT_Step=6
					else
						PRY_Hito=2
						CRT_Step=1
					end if														
				else
				end if
			end if
		end if
	end if
	finalizar=0

	mode="vis"
	modo=4
	caso=0
	do
		select case PRY_Hito
			case 0	'Creación
				if LIN_AgregaTematica then
					menulen=4
				else
					menulen=3				
				end if
				do
					select case PRY_CreacionProyectoEstado
						case 0	'Abierto
							if(session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) or ((session("ds5_usrperfil")=5) and CRT_Step>1) then
								if(nuevo) then
									modo=1
									mode="add"
									caso=9
								else
									mode="mod"
									modo=2
									caso=1
								end if									
							end if
							exit do
						case 1	'Cerrado		
							'Si el hito esta cerrado no es posible modificar (todos)
							mode="vis"			
							modo=4
							caso=2
							exit do
					end select
					exit do
				loop
				exit do
			case 1	'Inicio
				menulen=6
				do
					select case PRY_InformeInicioEstado
						case 0	'Abierto
							if(session("ds5_usrperfil")=1 or session("ds5_usrperfil")=3) then
								mode="mod"
								modo=2
								caso=3
							end if
							exit do
						case 1	'Cerrado		
							if(not PRY_InformeInicioAceptado and (session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1)) and CRT_Step=menulen+1 then
								mode="mod"
								modo=2
								caso=4
							end if
							exit do
					end select
					exit do
				loop
				exit do			
			case 2	'Final
				menulen=4
				do
					select case PRY_InformeFinalEstado
						case 0	'Abierto
							if(session("ds5_usrperfil")=1 or session("ds5_usrperfil")=3) then
								mode="mod"
								modo=2
								caso=7
							end if
							exit do
						case 1	'Cerrado		
							if(not PRY_InformeFinalAceptado and (session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1)) and CRT_Step=menulen+1 then
								mode="mod"
								modo=2
								caso=8
							end if
							exit do
					end select
					exit do
				loop
				exit do
		end select	
		exit do
	loop	
	
	'response.write("200/@/" & "caso:" & caso & " - menulen+1:" & menulen + 1 & " - PRY_Hito:" & PRY_Hito)
	response.write("200/@/")
		
	call menu(PRY_Hito,PRY_Step,CRT_Step,modo)	
	yCRT_Step=CRT_Step
	'if(CRT_Step=finalizar and not LIN_AgregaTematica and PRY_Hito=0) then
	'	yCRT_Step=CRT_Step + 1			
	'end if

	if(CRT_Step>=4 and not LIN_AgregaTematica and PRY_Hito=0) then		'Modulos adicionals
		yCRT_Step=CRT_Step + 1			
	end if
	if(PRY_Hito="") then
		PRY_Hito=0
	end if
	pryarc="pry-12-h" & PRY_Hito & "-s" & yCRT_Step
	if(PRY_Hito=0) then	'Creacion
		if(CRT_Step=menulen+1 and not LIN_AgregaTematica) then
			pryarc="pry-12-h0-fin"
		end if
		if(CRT_Step=menulen+1 and LIN_AgregaTematica) then
			pryarc="pry-12-h0-fin"
		end if
	end if
	if(PRY_Hito=1) then	'Inicio
		if(CRT_Step=menulen+1) then
			pryarc="pry-12-h1-fin"
		end if
		if(PRY_InformeInicioAceptado=0 and PRY_InformeInicioEstado=1 and (CRT_Step=menulen+1)) then
			pryarc="pry-12-h1-acepta"
		end if
	end if
	
	if(PRY_Hito=2) then	'Final
		if(CRT_Step=menulen+1) then
			pryarc="pry-12-h2-fin"
		end if
		if(PRY_InformeFinalAceptado=0 and PRY_InformeFinalEstado=1 and (CRT_Step=menulen+1)) then
			pryarc="pry-12-h2-acepta"
		end if
	end if
	
	function menu(xPRY_Hito,xPRY_Step,xCRT_Step,modo)		
		'Buscando las cabeceras de mensajes nuevos para el proyecto activo solo si no es hito creacion
		if modo<>1 then
			'Adecuaciones ahora mensajes
			sql = "exec spUsuarioMensajeProyectoHeadNuevo_Contar " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

			set rs = cnn.Execute(sql)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description
				cnn.close 			   		
			End If	
			if not rs.eof then
				MensajeProyectosNuevos=rs("MensajeProyectosNuevos")		
			else
				MensajeProyectosNuevos=0
			end if	

			'Buscando respuestas nuevas en los proyectos
			sql = "exec spUsuarioMensajeProyectoRespuestaNuevo_Contar " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

			set rs = cnn.Execute(sql)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description
				'cnn.close 			   		
			End If	
			if not rs.eof then
				MensajeRespuestaProyectosNuevos=rs("MensajeRespuestaProyectosNuevos")		
			else
				MensajeRespuestaProyectosNuevos=0
			end if

			'Verificadores pendiente y rechazados
			'Patrocinios					
			PAT_EstadoSubidoTotal=0
			PAT_EstadoRevisadoTotal=0
			PAT_EstadoAprobadoTotal=0
			PAT_EstadoRechazadoTotal=0
			PAT_Total=0			
			
			sql="exec [spPatrocinios_Listar] " & PRY_Id
			set rs = cnn.Execute(sql)
			on error resume next			
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description
				'cnn.close 			   		
			End If	
			
			do while not rs.eof
				PAT_EstadoSubido=rs("PAT_EstadoSubido")
				PAT_EstadoRevisado=rs("PAT_EstadoRevisado")		
				PAT_EstadoAprobado=rs("PAT_EstadoAprobado")			
				PAT_EstadoRechazado=rs("PAT_EstadoRechazado")	

				if(PAT_EstadoSubido="" or IsNull(PAT_EstadoSubido) or PAT_EstadoSubido=0) then
					PAT_EstadoSubido=0
				else
					PAT_EstadoSubidoTotal=PAT_EstadoSubidoTotal+1
				end if
				if(PAT_EstadoRevisado="" or IsNull(PAT_EstadoRevisado) or PAT_EstadoRevisado=0) then
					PAT_EstadoRevisado=0		
				else
					PAT_EstadoRevisadoTotal=PAT_EstadoRevisadoTotal+1
				end if
				if(PAT_EstadoAprobado="" or IsNull(PAT_EstadoAprobado) or PAT_EstadoAprobado=0) then
					PAT_EstadoAprobado=0
				else
					PAT_EstadoAprobadoTotal=PAT_EstadoAprobadoTotal+1
				end if
				if(PAT_EstadoRechazado="" or IsNull(PAT_EstadoRechazado) or PAT_EstadoRechazado=0) then
					PAT_EstadoRechazado=0
				else
					PAT_EstadoRechazadoTotal=PAT_EstadoRechazadoTotal+1
				end if		
				PAT_Total=PAT_Total+1
				rs.movenext
			loop																	

			'Estrategia Convocatoria
			ESC_EstadoSubidoTotal=0
			ESC_EstadoRevisadoTotal=0
			ESC_EstadoAprobadoTotal=0
			ESC_EstadoRechazadoTotal=0
			ESC_Total=0
			
			sql="exec [spEstrategiaConvocatoria_Listar] " & PRY_Id
			set rs = cnn.Execute(sql)
			on error resume next			
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description
				'cnn.close 			   		
			End If	
			
			do while not rs.eof
				ESC_EstadoSubido=rs("ESC_EstadoSubido")
				ESC_EstadoRevisado=rs("ESC_EstadoRevisado")		
				ESC_EstadoAprobado=rs("ESC_EstadoAprobado")			
				ESC_EstadoRechazado=rs("ESC_EstadoRechazado")	

				if(ESC_EstadoSubido="" or IsNull(ESC_EstadoSubido) or ESC_EstadoSubido=0) then
					ESC_EstadoSubido=0
				else
					ESC_EstadoSubidoTotal=ESC_EstadoSubidoTotal+1
				end if
				if(ESC_EstadoRevisado="" or IsNull(ESC_EstadoRevisado) or ESC_EstadoRevisado=0) then
					ESC_EstadoRevisado=0		
				else
					ESC_EstadoRevisadoTotal=ESC_EstadoRevisadoTotal+1
				end if
				if(ESC_EstadoAprobado="" or IsNull(ESC_EstadoAprobado) or ESC_EstadoAprobado=0) then
					ESC_EstadoAprobado=0
				else
					ESC_EstadoAprobadoTotal=ESC_EstadoAprobadoTotal+1
				end if
				if(ESC_EstadoRechazado="" or IsNull(ESC_EstadoRechazado) or ESC_EstadoRechazado=0) then
					ESC_EstadoRechazado=0
				else
					ESC_EstadoRechazadoTotal=ESC_EstadoRechazadoTotal+1
				end if		
				ESC_Total=ESC_Total+1
				rs.movenext
			loop			

			'Plan comunicacional								
			PLC_EstadoSubidoTotal=0
			PLC_EstadoRevisadoTotal=0
			PCL_EstadoAprobadoTotal=0
			PCL_EstadoRechazadoTotal=0
			PCL_Total=0						
			
			sql="exec [spPlanComunicacional_Listar] " & PRY_Id
			set rs = cnn.Execute(sql)
			on error resume next			
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description
				'cnn.close 			   		
			End If	
			
			do while not rs.eof
				PLC_EstadoSubido=rs("PLC_EstadoSubido")
				PLC_EstadoRevisado=rs("PLC_EstadoRevisado")		
				PLC_EstadoAprobado=rs("PLC_EstadoAprobado")			
				PLC_EstadoRechazado=rs("PLC_EstadoRechazado")

				if(PLC_EstadoSubido="" or IsNull(PLC_EstadoSubido) or PLC_EstadoSubido=0) then
					PLC_EstadoSubido=0
				else
					PLC_EstadoSubidoTotal=PLC_EstadoSubidoTotal+1
				end if
				if(PLC_EstadoRevisado="" or IsNull(PLC_EstadoRevisado) or PLC_EstadoRevisado=0) then
					PLC_EstadoRevisado=0		
				else
					PLC_EstadoRevisadoTotal=PLC_EstadoRevisadoTotal+1
				end if
				if(PLC_EstadoAprobado="" or IsNull(PLC_EstadoAprobado) or PLC_EstadoAprobado=0) then
					PLC_EstadoAprobado=0
				else
					PLC_EstadoAprobadoTotal=PLC_EstadoAprobadoTotal+1
				end if
				if(PLC_EstadoRechazado="" or IsNull(PLC_EstadoRechazado) or PLC_EstadoRechazado=0) then
					PLC_EstadoRechazado=0
				else
					PLC_EstadoRechazadoTotal=PLC_EstadoRechazadoTotal+1
				end if		
				PLC_Total=PLC_Total+1
				rs.movenext
			loop

			'Plan de contingencia								
			PCO_EstadoSubidoTotal=0
			PCO_EstadoRevisadoTotal=0
			PCO_EstadoAprobadoTotal=0
			PCO_EstadoRechazadoTotal=0
			PCO_Total=0						
			
			sql="exec [spPlanContingencia_Listar] " & PRY_Id
			set rs = cnn.Execute(sql)
			on error resume next			
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description
				'cnn.close 			   		
			End If	
			
			do while not rs.eof
				PCO_EstadoSubido=rs("PCO_EstadoSubido")
				PCO_EstadoRevisado=rs("PCO_EstadoRevisado")		
				PCO_EstadoAprobado=rs("PCO_EstadoAprobado")			
				PCO_EstadoRechazado=rs("PCO_EstadoRechazado")

				if(PCO_EstadoSubido="" or IsNull(PCO_EstadoSubido) or PCO_EstadoSubido=0) then
					PCO_EstadoSubido=0
				else
					PCO_EstadoSubidoTotal=PCO_EstadoSubidoTotal+1
				end if
				if(PCO_EstadoRevisado="" or IsNull(PCO_EstadoRevisado) or PCO_EstadoRevisado=0) then
					PCO_EstadoRevisado=0		
				else
					PCO_EstadoRevisadoTotal=PCO_EstadoRevisadoTotal+1
				end if
				if(PCO_EstadoAprobado="" or IsNull(PCO_EstadoAprobado) or PCO_EstadoAprobado=0) then
					PCO_EstadoAprobado=0
				else
					PCO_EstadoAprobadoTotal=PCO_EstadoAprobadoTotal+1
				end if
				if(PCO_EstadoRechazado="" or IsNull(PCO_EstadoRechazado) or PCO_EstadoRechazado=0) then
					PCO_EstadoRechazado=0
				else
					PCO_EstadoRechazadoTotal=PCO_EstadoRechazadoTotal+1
				end if		
				PCO_Total=PCO_Total+1
				rs.movenext
			loop

			VER_Total = ESC_Total + PAT_Total + PLC_Total + PCO_Total
			VER_RevisadosTotal = ESC_EstadoRevisadoTotal + PAT_EstadoRevisadoTotal + PLC_EstadoRevisadoTotal + PCO_EstadoRevisadoTotal
			VER_SubidosPendientes = (ESC_EstadoSubidoTotal + PAT_EstadoSubidoTotal + PLC_EstadoSubidoTotal + PCO_EstadoSubidoTotal) - VER_RevisadosTotal		'Subidos no revisados
			VER_RechazadosTotal = ESC_EstadoRechazadoTotal + PAT_EstadoRechazadoTotal + PLC_EstadoRechazadoTotal + PCO_EstadoRechazadoTotal
			VER_SinSubir = VER_Total - (ESC_EstadoSubidoTotal + PAT_EstadoSubidoTotal + PLC_EstadoSubidoTotal + PCO_EstadoSubidoTotal)
			
			'Adecuaciones Pendientes
			set rs = cnn.Execute("exec spAdecuaciones_SolicitudesPendiente " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description			
				'cnn.close				
			End If
			SolPen=0
			globo=""
			do while not rs.eof
				SolPen=SolPen + 1							
				rs.movenext
			loop									

			'Linea Formativa
			sql = "exec spLineaFormativa_Consultar " & LFO_Id

			set rs = cnn.Execute(sql)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description
				cnn.close 			   		
			End If	
			if not rs.eof then
				LFO_Calif=rs("LFO_Calif")
			else
				LFO_Calif=0
			end if	

			'Hitos Documentos pendientes
			sql="exec [spVerificadorProyecto_Listar] 1," & PRY_Id & "," & PRY_Hito & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			set rs = cnn.Execute(sql)
			on error resume next			

			VPR_EstadoSubidoTotal=0
			VPR_EstadoRevisadoTotal=0
			VPR_EstadoAprobadoTotal=0
			VPR_EstadoRechazadoTotal=0
			VPR_Total=0
			
			do while not rs.eof				
				VPR_EstadoSubido=rs("VPR_EstadoSubido")
				VPR_EstadoRevisado=rs("VPR_EstadoRevisado")		
				VPR_EstadoAprobado=rs("VPR_EstadoAprobado")			
				VPR_EstadoRechazado=rs("VPR_EstadoRechazado")	

				if(VPR_EstadoSubido="" or IsNull(VPR_EstadoSubido) or VPR_EstadoSubido=0) then
					VPR_EstadoSubido=0
				else
					VPR_EstadoSubidoTotal=VPR_EstadoSubidoTotal+1
				end if
				if(VPR_EstadoRevisado="" or IsNull(VPR_EstadoRevisado) or VPR_EstadoRevisado=0) then
					VPR_EstadoRevisado=0		
				else
					VPR_EstadoRevisadoTotal=VPR_EstadoRevisadoTotal+1
				end if
				if(VPR_EstadoAprobado="" or IsNull(VPR_EstadoAprobado) or VPR_EstadoAprobado=0) then
					VPR_EstadoAprobado=0
				else
					VPR_EstadoAprobadoTotal=VPR_EstadoAprobadoTotal+1
				end if
				if(VPR_EstadoRechazado="" or IsNull(VPR_EstadoRechazado) or VPR_EstadoRechazado=0) then
					VPR_EstadoRechazado=0
				else
					VPR_EstadoRechazadoTotal=VPR_EstadoRechazadoTotal+1
				end if		
				VPR_Total=VPR_Total+1				
				rs.movenext
			loop

		else
			MensajeProyectosNuevos=0
			MensajeRespuestaProyectosNuevos=0
			VerificadorNuevos=0
			SolPen=0
		end if

		if(MensajeProyectosNuevos>0 and MensajeRespuestaProyectosNuevos>0) then
			mensajesproyectos="<i class='fas fa-comments'></i>Mensajes Proyecto <span class='badge red' style='font-size:9px;'>" & MensajeProyectosNuevos & "</span> <span class='badge blue' style='font-size:9px;'>" & MensajeRespuestaProyectosNuevos & "</span>"
		else
			if(MensajeProyectosNuevos>0 and MensajeRespuestaProyectosNuevos=0) then
				mensajesproyectos="<i class='fas fa-comments'></i>Mensajes Proyecto <span class='badge red' style='font-size:9px;'>" & MensajeProyectosNuevos & "</span>"
			else
				if(MensajeProyectosNuevos=0 and MensajeRespuestaProyectosNuevos>0) then
					mensajesproyectos="<i class='fas fa-comments'></i>Mensajes Proyecto <span class='badge blue' style='font-size:9px;'>" & MensajeRespuestaProyectosNuevos & "</span>"
				else
					mensajesproyectos="<i class='fas fa-comments'></i>Mensajes Proyecto"
				end if
			end if
		end if	

		'Verificadores
		verificadores="<i class='fas fa-check'></i>Verificadores "
		if(VER_SinSubir>0) then
			verificadores = verificadores & "<span class='badge blue' style='font-size:9px;' title='Archivos pendientes de carga' data-toggle='tooltip'>" & VER_SinSubir & "</span> "
		end if
		if(VER_SubidosPendientes>0) then
			verificadores = verificadores & "<span class='badge orange' style='font-size:9px;' title='Archivos pendientes de revisión' data-toggle='tooltip'>" & VER_SubidosPendientes & "</span> "
		end if
		if(VER_RechazadosTotal>0) then
			verificadores= verificadores & "</span> <span class='badge red' style='font-size:9px;' title='Archivos rechazados' data-toggle='tooltip'>" & VER_RechazadosTotal & "</span>"
		end if	
		
		'if(SolPen>0) then
		''	planificaciones="<i class='fas fa-calendar-alt'></i>Planificación <span class='badge green' style='font-size:9px;'>" & SolPen & "</span>"
		'else
			planificaciones="<i class='fas fa-calendar-alt'></i>Planificación"
		'end if
		
		if(SolPen>0) then
			adecuaciones="<i class='fas fa-edit'></i>Adecuaciones <span class='badge red' style='font-size:9px;'>" & SolPen & "</span>"
		else
			adecuaciones="<i class='fas fa-edit'></i>Adecuaciones"
		end if

		clase="category text-primary"
				
		if LFO_Calif=1 then
			if(session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4) then	'Administrador, revisor, auditor
				menucierre=array(planificaciones,"<i class='fas fa-address-card'></i>Alumnos","<i class='fas fa-users' aria-hidden='true'></i>Asistencia","<i class='far fa-check-square' aria-hidden='true'></i>Calificaciones",adecuaciones,mensajesproyectos,"<i class='fas fa-file-signature'></i>Contratos","<i class='fas fa-hand-holding-usd'></i>Presupuesto")
				menucierrepag=array("/planificacion-modal","/alumnos-modal","/asistencia-modal","/calificaciones-modal","/adecuaciones-modal","/mensajes-proyecto-modal","/contratos-modal","/presupuestos-modal")				
			else
				if(session("ds5_usrperfil")=3) then
					menucierre=array(planificaciones,"<i class='fas fa-address-card'></i>Alumnos","<i class='fas fa-users' aria-hidden='true'></i>Asistencia","<i class='far fa-check-square' aria-hidden='true'></i>Calificaciones",adecuaciones,mensajesproyectos)
					menucierrepag=array("/planificacion-modal","/alumnos-modal","/asistencia-modal","/calificaciones-modal","/adecuaciones-modal","/mensajes-proyecto-modal")
				else
					if(session("ds5_usrperfil")=5) then	'Administrativo
						menucierre=array(adecuaciones,mensajesproyectos,"<i class='fas fa-file-signature'></i>Contratos","<i class='fas fa-hand-holding-usd'></i>Presupuesto")
						menucierrepag=array("/adecuaciones-modal","/mensajes-proyecto-modal","/contratos-modal","/presupuestos-modal")
					end if				
				end if
			end if
		else
			if(session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4) then	'Administrador, revisor, auditor
				menucierre=array(planificaciones,"<i class='fas fa-address-card'></i>Alumnos","<i class='fas fa-users'></i>Asistencia",adecuaciones,mensajesproyectos,"<i class='fas fa-file-signature'></i>Contratos","<i class='fas fa-hand-holding-usd'></i>Presupuesto")
				menucierrepag=array("/planificacion-modal","/alumnos-modal","/asistencia-modal","/adecuaciones-modal","/mensajes-proyecto-modal","/contratos-modal","/presupuestos-modal")							
			else
				if(session("ds5_usrperfil")=3) then
					menucierre=array(planificaciones,"<i class='fas fa-address-card'></i>Alumnos","<i class='fas fa-users' aria-hidden='true'></i>Asistencia",adecuaciones,mensajesproyectos)
					menucierrepag=array("/planificacion-modal","/alumnos-modal","/asistencia-modal","/adecuaciones-modal","/mensajes-proyecto-modal")					
				else
					if(session("ds5_usrperfil")=5) then	'Administrativo
						menucierre=array(adecuaciones,mensajesproyectos,"<i class='fas fa-file-signature'></i>Contratos","<i class='fas fa-hand-holding-usd'></i>Presupuesto")
						menucierrepag=array("/adecuaciones-modal","/mensajes-proyecto-modal","/contratos-modal","/presupuestos-modal")
					end if		
				end if
			end if
		end if

		menucierrelen=ubound(menucierre)
						
		hitoscerrados=array(PRY_CreacionProyectoEstado,PRY_InformeInicioEstado,PRY_InformeFinalEstado)
		hitosaceptados=array(true,PRY_InformeInicioAceptado,PRY_InformeFinalAceptado)
		hitos=array("Creación","Inicio","Final")	
		hitoslen=2
		informesnombre=array("informecreacion.pdf","informeinicio.pdf","informefinal.pdf")
		informessubdir=array("informecreacion","informeinicio","informefinal")
		prtinformes=array("/prt-informecreacioncursos","/prt-informeiniciocursos","/prt-informefinalcursos")
		dir="d:\DocumentosSistema\dialogosocial\" & replace(replace(PRY_Carpeta,"{",""),"}","") & "\informes\"
		dim fs
		informesexiste = array(false,false,false,false)
		for i=0 to hitoslen
			Archivo=dir & informessubdir(i) & "\" & informesnombre(i)
			set fs=Server.CreateObject("Scripting.FileSystemObject")
			if fs.FileExists(Archivo) then
			  informesexiste(i)=true
			else
			  informesexiste(i)=false
			end if
			set fs=nothing	
		next
		
		'dim menus(5,9)
		dim menus(4,9)
		'Creación
		if LIN_AgregaTematica then
			menus(0,0)="Personalización"
			menus(0,1)="Fechas de Cierre"			
			menus(0,2)="Redes de Apoyo"							
			menus(0,3)="Módulos Adicionales"
			'menus(0,4)="Criterios de Focalización"
			'menus(0,5)="Estrategia de Convocatoria"
			'menus(0,6)="Planes"			
			menus(0,4)="Finalizar"
		else
			menus(0,0)="Personalización"
			menus(0,1)="Fechas de Cierre"
			menus(0,2)="Redes de Apoyo"			
			'menus(0,3)="Criterios de Focalización"
			'menus(0,4)="Estrategia de Convocatoria"
			'menus(0,5)="Planes"			
			menus(0,3)="Finalizar"
		end if
		PenSubir = VPR_Total - VPR_EstadoSubidoTotal
		PenRevisar = VPR_Total - VPR_EstadoRevisadoTotal
		texto="Documentos"		
		if(PenSubir>0) then
			texto=texto & " <span class='badge orange' style='font-size:9px;' title='Archivos pendientes de subir' data-toggle='tooltip'>" & PenSubir & "</span>"
		end if		
		if(PenRevisar>0) then
			texto=texto & " <span class='badge purple' style='font-size:9px;' title='Archivos pendientes de revisar' data-toggle='tooltip'>" & PenRevisar & "</span>"
		end if
		if(VPR_EstadoAprobadoTotal>0) then
			texto=texto & " <span class='badge green' style='font-size:9px;' title='Archivos aceptados' data-toggle='tooltip'>" & VPR_EstadoAprobadoTotal & "</span>"
		end if
		if(VPR_EstadoRechazadoTotal>0) then
			texto=texto & " <span class='badge red' style='font-size:9px;' title='Archivos rechazados' data-toggle='tooltip'>" & VPR_EstadoRechazadoTotal & "</span>"
		end if	

		'Inicio
		menus(1,0)="Responsables del proyecto"		
		menus(1,1)="Responsables de Rendición"
		menus(1,2)="Estadística de Alumnos"
		menus(1,3)="Planificación"
		menus(1,4)="Actividades"
		menus(1,5)="Informe Nro1"
			
		if(PRY_InformeInicioEstado=0) then			
			menus(1,6)="Finalizar"
		else
			if(PRY_InformeInicioAceptado=0) then
				menus(1,6)="Aceptar"
			end if
		end if		

		'Final		
		menus(2,0)="Cobertura del Programa"
		menus(2,1)="Causas de la Deserción"
		menus(2,2)="Informe de Asistencia"		
		'menus(2,3)="Evaluación del Programa"		
		menus(2,3)="Informe Nro 2"		
		if(PRY_InformeFinalEstado=0) then			
			menus(2,4)="Finalizar"
		else
			if(PRY_InformeFinalAceptado=0) then
				menus(2,4)="Aceptar"
			end if
		end if				
		
		param=""
		salida=""
		
		salida = salida + "<ul class='nav nav-stacked nav-tree' role='tab-list'>"		
		if hitoscerrados(0)=1 then
			salida= salida +  "<li role='presentation' class='category text-primary menus'><i class='fas fa-bars' aria-hidden='true'></i> Menú</li>"
			for j=0 to menucierrelen	'Mostrando el menu de la cabecera solo cuando el hito esta cerrado
				salida = salida + "<li role='presentation' class='menus'><a role='tab' href='#' data-url='" & menucierrepag(j) & "' data-mode='" & modo & "' data-hito='" & xPRY_Hito & "' data-step='" & xCRT_Step & "'>" & menucierre(j) & "</a></li>"
			next		
		end if		
		salida = salida + "<li class='pasos' style='padding-top:15px;opacity:0;visiblity:hidden'></li>"
		salida = salida + "<li role='presentation' class='" & clase & " pasos' style='margin-top:0;'><i class='fas fa-indent' aria-hidden='true' style='padding-right:7px;'></i> PASOS HITO : " + hitos(xPRY_Hito) & "</li>"		

		if hitoscerrados(xPRY_Hito)=0 then	'Hito aun esta abierto
			if(xCRT_Step>PRY_Step and PRY_Step>0) then
				xCRT_Step=PRY_Step
			end if
			for j=0 to menulen
				if (j+1)=xCRT_Step then
					clase="active"
					param=""
					if(xCRT_Step<=xPRY_Step) then						
						clase2="act done"
					else						
						clase2="act"
					end if
				else		
					if xPRY_Step<(j+1) then		
						clase="disabled"
						clase2="pend"
						param=""
					else
						clase=""
						clase2="done"
						param="data-step='" & j+1 & "' data-mode='" & modo & "' class='step' data-hito='" & xPRY_Hito & "'"
					end if
				end if
				if clase="" then
					salida= salida + "<li role='presentation' class='" & clase & " pasos'><a role='tab' href='#' " & param & "><i class='globo " & clase2 & "'>" & (j+1) & "</i>" & menus(xPRY_Hito,j) & "</a></li>"			
				else
					salida= salida + "<li role='presentation' class='" & clase & " pasos'><a role='tab' href='#' " & param & "><i class='globo " & clase2 & "'>" & (j+1) & "</i>" & menus(xPRY_Hito,j) & "</a></li>"
				end if
			next
		else	'Hito Cerrado pero no aceptado
			if (not hitosaceptados(xPRY_Hito)) then
				for j=0 to menulen 	'Mostrar ultimo step aceptar si no se ha aceptado y si es administrador o revisor
					if (j+1)=xCRT_Step then
						clase="active"
						clase2="act"
					else
						clase=""
						clase2="done"
					end if
					salida = salida + "<li role='presentation' class='" & clase & " pasos'><a role='tab' href='#' data-step='" & (j+1) & "' data-mode='" & modo & "' data-hito='" & xPRY_Hito & "' class='step'><i class='globo pull-left " & clase2 & "'>" & (j+1) & "</i>" & menus(xPRY_Hito,j) & "</a></li>"
				next				
			else 'Hito cerrado y aceptado
				for j=0 to menulen - 1	'Sin step Aceptar cuando esta cerrado y aceptado
					if (j+1)=xCRT_Step then
						clase="active"
						clase2="act"
					else
						clase=""
						clase2="done"
					end if										
					salida = salida + "<li role='presentation' class='" & clase & " pasos'><a role='tab' href='#' data-step='" & (j+1) & "' data-mode='" & modo & "' data-hito='" & xPRY_Hito & "' class='step'><i class='globo pull-left " & clase2 & "'>" & (j+1) & "</i>" & menus(xPRY_Hito,j) & "</a></li>"
				next					
			end if	'Fin Hito Cerrado	
		end if	'Fin Hito Cerrado pero no aceptado
		salida = salida + "<li class='hitos' style='padding-top:15px;opacity:0;visiblity:hidden'></li>"
		salida = salida + "<li role='presentation' class='category text-primary hitos' style='margin-top:0;'><i class='fas fa-map-marker-alt' style='padding-right:7px;'></i> Hitos </li>"
		
		sw=0
		for j=0 to hitoslen		'Menu Hitos	
			'response.write(hitosaceptados(j) & " " & j)
			if CInt(xPRY_Hito)=j then
				clase="active"
				clase2="act"
				param=""
			else
				if hitosaceptados(j-1) and hitoscerrados(j-1)=1 then
					clase=""
					clase2="done"
					param="data-step='1' data-mode='" & modo & "' class='step'" & " data-hito='" & j & "'"
				else
					sw=1
				end if
			end if				
			if sw=1 then			
				param=""
				clase="disabled"
				clase2="pend"
			end if			
			aceptado=""
			check="fa-check"
			texto="Cerrado"
			mail=""
			if hitosaceptados(j) and hitoscerrados(j)=1 then
				'aceptado="<i class='fas fa-check-double aceptado' aria-hidden='true' data-toggle='tooltip' data-placement='right' title='Hito " & hitos(j) & " Cerrado y Aceptado'></i>"
				check="fa-check-double"
				mail="<i class='fas fa-paper-plane enviarmail' data-toggle='tooltip' title='Reenviar mail de aceptación de informe " & hitos(j) & "' data-pry='" & PRY_Id & "' data-hito='" & j & "'></i>"
				texto="Cerrado y Aceptado"
			end if				
			if hitoscerrados(j)=1 then				
				if (session("ds5_usrperfil")=1 or (session("ds5_usrperfil")=2 and USR_IdRevisor=session("ds5_usrid"))) and j>0 then	'Solo Adm y Rev pueden abrir hitos cerrados				
					aceptado="<i class='fas " & check & " aceptado' aria-hidden='true' data-toggle='tooltip' data-placement='right' title='Hito " & hitos(j) & " " & texto & "'></i>" & mail & "<i class='fas fa-folder-open abririnforme' aria-hidden='true' data-hito='" & j & "' data-toggle='tooltip' data-placement='right' title='Abrir informe " & hitos(j) & "' data-file='" & informesnombre(j) & "' data-des='" & hitos(j) & "'></i>"
				else
					if (session("ds5_usrperfil")=1 or (session("ds5_usrperfil")=2 and USR_IdRevisor=session("ds5_usrid")) and j=1) then
						aceptado="<i class='fas " & check & " aceptado' aria-hidden='true' data-toggle='tooltip' data-placement='right' title='Hito " & hitos(j) & " " & texto & "'></i> <i class='fas fa-folder-open abririnforme' aria-hidden='true' data-hito='" & j & "' data-toggle='tooltip' data-placement='right' title='Abrir informe " & hitos(j) & "' data-file='" & informesnombre(j) & "' data-des='" & hitos(j) & "'></i>"
					else
						aceptado="<i class='fas " & check & " aceptado' aria-hidden='true' data-toggle='tooltip' data-placement='right' title='Hito " & hitos(j) & " " & texto & "' data-des='" & hitos(j) & "'></i>"
					end if
				end if
			end if				
			
			'Informe
			informe=""
			if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2 or session("ds5_usrperfil")=5) and hitoscerrados(j)=1 then				
				informe = "<i class='fas fa-sync text-warning aceptado generar' id='' data-file='" & informesnombre(j) & "' data-id='" & j & "' data-hito='" & j & "' data-step='" & xCRT_Step & "' data-toggle='tooltip' data-placement='top' title='Generar Informe " & informesnombre(j) & "' data-prt=" & prtinformes(j) &"></i>"
			end if				
			if informesexiste(j) and hitoscerrados(j)=1 then										
				informe = informe + "<i class='fas fa-cloud-download-alt text-primary aceptado descargar' data-file='" & informesnombre(j) & "' id='' data-toggle='tooltip' data-placement='right' data-hito='" & j & "' title='Descargar informe " & informesnombre(j) & "'></i>"
				
				informe = informe + "<i class='fas fa-history text-secondary aceptado historico' data-file='' id='' data-toggle='tooltip' data-placement='right' data-hito='" & j & "' title='Informes Históricos para " & informesnombre(j) & "'></i>"
			end if			
			'Informe
			
			salida = salida + "<li role='presentation' class='" & clase & " hitos'><a role='tab' href='#'" & param &"><i class='globo " & clase2 & "'>" & ucase(mid(hitos(j),1,1)) & "</i>" & hitos(j) & " " & informe & aceptado & " </a></li>"
			if not hitosaceptados(j) then			
				'exit for			
				sw=1
			end if
		next		

		salida = salida + "</ul>"
		response.write(salida)		
	end function		
%>
<script>
	var ss  = String.fromCharCode(47) + String.fromCharCode(47);
	var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
	changeURL(<%=modo%>,<%=PRY_Hito%>,<%=CRT_Step%>,<%=PRY_Id%>);
	var data={LIN_Id:<%=LIN_Id%>,mode:'<%=mode%>',PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>'};<%	
	if(Modulo) then%>
		$("#pry-content").html("Cargando el modulo...");
		$("#pry-content").append("<div class='loader_wrapper'><div class='loader'></div></div>");
		$.ajax( {
			type:'POST',					
			url: '/<%=pryarc%>',
			data: data,
			success: function ( data ) {
				param = data.split(sas)
				
				if(param[0]==200){
					$("#pry-content").hide();
					$("#pry-content").html(param[1]);
					$("#pry-content").show("slow")
				}else{				
					$("#pry-content").hide();
					$("#pry-content").html("<div class='row'><h5 style='padding-right: 15px; padding-left: 15px; display: block;'>ERROR: No fue posible encontrar el módulo correspondiente.</h5></div>");
					$("#pry-content").show("slow")
				}			
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){				
				swalWithBootstrapButtons.fire({
					icon:'error',								
					title: 'Ups!, no pude cargar los campos del proyecto'					
				});				
			},
			complete: function(){
				$(".loader_wrapper").remove();
			}
		});<%
	end if%>
		
	function changeURL(Modo,Hito,Step,PRY_Id){
		var href = window.location.href;
		var newhref = href.substr(href.indexOf("/home")+6,href.length);
		var href_split = newhref.split("/")				
		
		if(href_split[1]=="modificar" || href_split[1]=="visualizar" || href_split[1]=="agregar"){
			if(Modo==2){
				href_split[1]="modificar";
				href_split[3]=PRY_Id;
			}
			if(Modo==4){
				href_split[1]="visualizar";
				href_split[3]=PRY_Id;
			}
			if(Modo!=1){
				href_split[4]=Hito;
				href_split[5]=Step;			
				var newurl="/home"
				$.each(href_split, function(i,e){
					newurl=newurl + "/" + e
				});
				window.history.replaceState(null, "", newurl);
			}
			cargabreadcrumb("/breadcrumbs","");
		}		
		
	};
			
</script><%
response.write("/@/" & pryarc)%>
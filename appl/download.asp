<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
If (Session("dialogosocialv5") <> Session.SessionID) Then
	Response.write("No autorizado")
	Response.end()
end if	
PRY_Id				= Request("PRY_Id")
PRY_Identificador	= Request("PRY_Identificador")
PRY_Hito			= Request("PRY_Hito")

ALU_Rut				= Request("ALU_Rut")
PLN_Sesion			= Request("PLN_Sesion")

xMEN_Id				= request("MEN_Id")
xMEN_Corr			= request("MEN_Corr")

VER_Corr			= request("VER_Corr")

PRE_NumCuota		= request("PRE_NumCuota")
OES_Id				= request("OES_Id")
ADE_Id				= request("ADE_Id")
IPR_Id				= request("IPR_Id")
VER_Corr			= request("VER_Corr")
REL_Rut				= request("REL_Rut")

PAT_Id				= request("PAT_Id")
ESC_Id				= request("ESC_Id")
ENP_Id				= request("ENP_Id")
PLC_Id				= request("PLC_Id")
PCO_Id				= request("PCO_Id")

if not isnull(ALU_Rut) and ALU_Rut<>"" then
	rut=ALU_Rut
	dv=0
else
	rut=0
	dv=""
end if

if not isnull(xMEN_Id) and xMEN_Id<>"" then
	MEN_Id=xMEN_Id
else
	MEN_Id=0
end if

if not isnull(xMEN_Corr) and xMEN_Corr<>"" then
	MEN_Corr=xMEN_Corr
else
	MEN_Corr=0
end if


set cnn = Server.CreateObject("ADODB.Connection")
cnn.open session("DSN_DialogoSocialv5")
on error resume next
if cnn.Errors.Count > 0 then 
	ErrMsg = cnn.Errors(0).description			
	cnn.close 
	response.write(ErrMsg)
	Response.end()
End If
LFO_Id=0
if(PRY_Id>0) then
	sqx="exec spProyecto_Consultar " & PRY_Id
	set rs = cnn.Execute(sqx)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.write(ErrMsg & " " & sqx)
		Response.end()
	End If

	if not rs.eof then	
		LFO_Id=rs("LFO_Id")

		PRY_Carpeta=rs("PRY_Carpeta")
		PRY_Carpeta=Replace(PRY_Carpeta, "{", "") 
		PRY_Carpeta=Replace(PRY_Carpeta, "}", "") 
	end if
	if PRY_Carpeta="" then
		response.write("Carpeta vacia")
		Response.end()
	end if
end if
if LFO_Id=10 then
	if PRY_Hito=0 then
		carpeta_informe="informecreacion"
	else
		if PRY_Hito=1 then
			carpeta_informe="informeinicio"
		else
			if PRY_Hito=2 then
				carpeta_informe="informeparcial"
			else
				'if PRY_Hito=3 then
				'	carpeta_informe="informedesarrollo"
				'else
					'if PRY_Hito=4 then
					if PRY_Hito=3 then
						carpeta_informe="informefinal"
					else
						if PRY_Hito=94 then
							carpeta_informe="verificadores"
						else				
							if PRY_Hito=95 then
								carpeta_informe="evidencias"
							else					
								if PRY_Hito=96 then
									carpeta_informe="adecuaciones"
								else
									if PRY_Hito=97 then
										carpeta_informe="justificaciones"
									else
										if PRY_Hito=98 then
											carpeta_informe="fichasalumnos"
										else
											if PRY_Hito=100 then
												carpeta_informe="contratos"
											else
												if PRY_Hito=101 then
													carpeta_informe="presupuestos"
												else
													if PRY_Hito=105 then
														carpeta_informe="verificadoresproyecto"
													else
														if PRY_Hito=106 then
															carpeta_informe="verificadoresmarketing"
														else	
															if PRY_Hito=107 then
																carpeta_informe="incumplimientos"
															else															
																if PRY_Hito=108 then
																	carpeta_informe="incumplimientos"
																else															
																	if PRY_Hito=109 then
																		carpeta_informe="coordinador"
																	else															
																		if PRY_Hito=110 then
																			carpeta_informe="encargado"
																		else
																			if PRY_Hito=111 then
																				carpeta_informe="relatores"
																			else
																				if PRY_Hito=112 then
																					carpeta_informe="verificadorsindicato\s-"
																				else
																					if PRY_Hito=113 then
																						carpeta_informe="verificadorempresa\e-"
																					else
																						if PRY_Hito=114 then
																							carpeta_informe="verificadorcivil\c-"
																						else
																							if PRY_Hito=115 then
																								carpeta_informe= "verificadorconvocatoria\c-"			
																							else
																								if PRY_Hito=116 then
																									carpeta_informe= "\verificadorenfoques\e-"						
																								else
																									if PRY_Hito=117 then
																										carpeta_informe= "\verificadoresplancomunicacional\p-"
																									else
																										if PRY_Hito=118 then
																											carpeta_informe= "\verificadoresplancontingencia\p-"
																										else
																											if PRY_Hito=124 then
																												carpeta_informe= "responsable1"
																											else
																												if PRY_Hito=125 then
																													carpeta_informe= "responsable2"
																												else
																													if PRY_Hito=999 then
																														carpeta_informe="verificadoresmesas"
																													else
																														carpeta_informe="informes"
																													end if
																												end if
																											end if
																										end if
																									end if
																								end if
																							end if
																						end if
																					end if
																				end if
																			end if
																		end if	
																	end if																	
																end if
															end if
														end if
													end if
												end if
											end if
										end if
									end if
								end if
							end if
						end if
					end if
				'end if
			end if
		end if
	end if
end if
if LFO_Id = 11 or LFO_Id = 13 then
	if PRY_Hito=0 then
		carpeta_informe="informecreacion"
	else
		if PRY_Hito=1 then
			carpeta_informe="informeinicial"
		else
			if PRY_Hito=2 then
				carpeta_informe="informeavances"
			else
				if PRY_Hito=3 then
					carpeta_informe="informefinal"
				else				
					if PRY_Hito=96 then
						carpeta_informe="adecuaciones"
					else
						if PRY_Hito=97 then
							carpeta_informe="justificaciones"
						else
							if PRY_Hito=98 then
								carpeta_informe="fichasalumnos"
							else
								if PRY_Hito=100 then
									carpeta_informe="contratos"
								else
									if PRY_Hito=101 then
										carpeta_informe="presupuestos"
									else
										if PRY_Hito=105 then
											carpeta_informe="verificadoresproyecto"
										else
											if PRY_Hito=106 then
												carpeta_informe="verificadoresmarketing"
											else												
												if PRY_Hito=107 then
													carpeta_informe="incumplimientos"
												else															
													if PRY_Hito=108 then
														carpeta_informe="incumplimientos"
													else															
														if PRY_Hito=109 then
															carpeta_informe="coordinador"
														else															
															if PRY_Hito=110 then
																carpeta_informe="encargado"
															else															
																if PRY_Hito=111 then
																	carpeta_informe="relatores"
																else
																	if PRY_Hito=112 then
																		carpeta_informe="verificadorsindicato\s-"
																	else
																		if PRY_Hito=113 then
																			carpeta_informe="verificadorempresa\e-"
																		else
																			if PRY_Hito=114 then
																				carpeta_informe="verificadorcivil\c-"
																			else
																				if PRY_Hito=115 then
																					carpeta_informe="verificadorgobierno\g-"
																				else
																					if PRY_Hito=116 then
																						carpeta_informe="verificadorsindicatogrp\s-"
																					else
																						if PRY_Hito=117 then
																							carpeta_informe="verificadorempresagrp\e-"
																						else
																							if PRY_Hito=118 then
																								carpeta_informe="verificadorgobiernogrp\g-"
																							else
																								if PRY_Hito=119 then
																									carpeta_informe="verificadorcoordactorestra\t-"
																								else
																									if PRY_Hito=120 then
																										carpeta_informe="verificadorcoordactoresemp\e-"
																									else
																										if PRY_Hito=121 then
																											carpeta_informe="verificadorcoordactoresgob\g-"
																										else
																											if PRY_Hito=122 then
																												carpeta_informe="verificadoresplancomunicacional\p-"
																											else
																												if PRY_Hito=123 then
																													carpeta_informe="verificadoresplandetrabajo\p-"
																												else
																													if PRY_Hito=124 then
																														carpeta_informe= "responsable1"
																													else
																														if PRY_Hito=125 then
																															carpeta_informe= "responsable2"
																														else
																															if PRY_Hito=999 then
																																carpeta_informe="verificadoresmesas"
																															else	
																																carpeta_informe="informes"
																															end if
																														end if
																													end if
																												end if
																											end if
																										end if
																									end if
																								end if
																							end if
																						end if
																					end if
																				end if
																			end if
																		end if
																	end if
																end if
															end if	
														end if
													end if
												end if
											end if
										end if
									end if
								end if
							end if
						end if
					end if
					
				end if
			end if
		end if
	end if
end if
if LFO_Id=12 then
	if PRY_Hito=0 then
		carpeta_informe="informecreacion"
	else
		if PRY_Hito=1 then
			carpeta_informe="informeinicio"
		else			
			if PRY_Hito=2 then
				carpeta_informe="informefinal"
			else
				if PRY_Hito=94 then
					carpeta_informe="verificadores"
				else				
					if PRY_Hito=95 then
						carpeta_informe="evidencias"
					else					
						if PRY_Hito=96 then
							carpeta_informe="adecuaciones"
						else
							if PRY_Hito=97 then
								carpeta_informe="justificaciones"
							else
								if PRY_Hito=98 then
									carpeta_informe="fichasalumnos"
								else
									if PRY_Hito=100 then
										carpeta_informe="contratos"
									else
										if PRY_Hito=101 then
											carpeta_informe="presupuestos"
										else
											if PRY_Hito=105 then
												carpeta_informe="verificadoresproyecto"
											else
												if PRY_Hito=106 then
													carpeta_informe="verificadoresmarketing"
												else												
													if PRY_Hito=107 then
														carpeta_informe="incumplimientos"
													else															
														if PRY_Hito=108 then
															carpeta_informe="incumplimientos"
														else															
															if PRY_Hito=109 then
																carpeta_informe="coordinador"
															else															
																if PRY_Hito=110 then
																	carpeta_informe="encargado"
																else															
																	if PRY_Hito=111 then
																		carpeta_informe="relatores"
																	else
																		if PRY_Hito=112 then
																			carpeta_informe="verificadorsindicato\s-"
																		else
																			if PRY_Hito=113 then
																				carpeta_informe="verificadorempresa\e-"
																			else
																				if PRY_Hito=114 then
																					carpeta_informe="verificadorcivil\c-"
																				else
																					'if PRY_Hito=115 then
																					'	carpeta_informe="verificadorgobierno\g-"
																					'else
																					if PRY_Hito=115 then
																						carpeta_informe= "verificadorconvocatoria\c-"			
																					else
																						'if PRY_Hito=116 then
																						'	carpeta_informe= "\verificadorenfoques\e-"						
																						'else
																							if PRY_Hito=117 then
																								carpeta_informe= "\verificadoresplancomunicacional\p-"
																							else
																								if PRY_Hito=118 then
																									carpeta_informe= "\verificadoresplancontingencia\p-"
																								else
																									if PRY_Hito=999 then
																										carpeta_informe="verificadoresmesas"
																									else
																										if PRY_Hito=124 then
																											carpeta_informe="responsable1"
																										else
																											if PRY_Hito=125 then
																												carpeta_informe="responsable2"
																											else
																												carpeta_informe="informes"
																											end if
																										end if
																									end if
																								end if
																							end if
																						'end if
																					end if
																				end if
																			end if
																		end if
																	end if
																end if	
															end if
														end if
													end if
												end if
											end if
										end if
									end if
								end if
							end if
						end if
					end if
				end if				
			end if
		end if
	end if
end if
if LFO_Id=14 then
	if PRY_Hito=0 then
		carpeta_informe="informecreacion"
	else
		if PRY_Hito=1 then
			carpeta_informe="informeinicial"
		else			
			if PRY_Hito=2 then
				carpeta_informe="informeavances"
			else
				if PRY_Hito=3 then
					carpeta_informe="informedesarrollo"
				else
					if PRY_Hito=4 then
						carpeta_informe="informefinal"
					else
						if PRY_Hito=94 then
							carpeta_informe="verificadores"
						else
							if PRY_Hito=95 then
								carpeta_informe="evidencias"
							else					
								if PRY_Hito=96 then
									carpeta_informe="adecuaciones"
								else
									if PRY_Hito=97 then
										carpeta_informe="justificaciones"
									else
										if PRY_Hito=98 then
											carpeta_informe="fichasalumnos"
										else
											if PRY_Hito=100 then
												carpeta_informe="contratos"
											else
												if PRY_Hito=101 then
													carpeta_informe="presupuestos"
												else
													if PRY_Hito=105 then
														carpeta_informe="verificadoresproyecto"
													else
														if PRY_Hito=106 then
															carpeta_informe="verificadoresmarketing"
														else												
															if PRY_Hito=107 then
																carpeta_informe="incumplimientos"
															else															
																if PRY_Hito=108 then
																	carpeta_informe="incumplimientos"
																else															
																	if PRY_Hito=109 then
																		carpeta_informe="coordinador"
																	else															
																		if PRY_Hito=110 then
																			carpeta_informe="encargado"
																		else															
																			if PRY_Hito=111 then
																				carpeta_informe="relatores"
																			else
																				if PRY_Hito=112 then
																					carpeta_informe="verificadorsindicato\s-"
																				else
																					if PRY_Hito=113 then
																						carpeta_informe="verificadorempresa\e-"
																					else
																						if PRY_Hito=114 then
																							carpeta_informe="verificadorcivil\c-"
																						else
																							'if PRY_Hito=115 then
																							'	carpeta_informe="verificadorgobierno\g-"
																							'else
																							if PRY_Hito=115 then
																								carpeta_informe= "verificadorconvocatoria\c-"			
																							else
																								'if PRY_Hito=116 then
																								'	carpeta_informe= "\verificadorenfoques\e-"						
																								'else
																									if PRY_Hito=117 then
																										carpeta_informe= "\verificadoresplancomunicacional\p-"
																									else
																										if PRY_Hito=118 then
																											carpeta_informe= "\verificadoresplancontingencia\p-"
																										else
																											if PRY_Hito=999 then
																												carpeta_informe="verificadoresmesas"
																											else
																												if PRY_Hito=124 then
																													carpeta_informe="responsable1"
																												else
																													if PRY_Hito=125 then
																														carpeta_informe="responsable2"
																													else
																														carpeta_informe="informes"
																													end if
																												end if
																											end if
																										end if
																									end if
																								'end if
																							end if
																						end if
																					end if
																				end if
																			end if
																		end if	
																	end if
																end if
															end if
														end if
													end if
												end if
											end if
										end if
									end if
								end if
							end if
						end if
					end if
				end if
			end if
		end if
	end if
end if

if LFO_Id=0 then
	if PRY_Hito=111 then
		carpeta_informe="relatores"
	else
		carpeta_informe="informes"
	end if
end if

if PRY_Hito=94 then
	dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & "\v-" & VER_Corr & "\"
else
	if PRY_Hito=95 then
		dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & "\s-" & PLN_Sesion & "\"
	else
		if PRY_Hito=96 then
			'dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & "\" & MEN_Id & "\" & MEN_Corr & "\"
			dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & "\ade-" & trim(ADE_Id) & "\"			
		else
			if PRY_Hito=97 then
				dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & "\" & rut & "\" & PLN_Sesion & "\"
			else
				if PRY_Hito=98 then
					dir="D:\DocumentosSistema\dialogosocial\" & carpeta_informe & "\" & rut & "\"
				else
					if PRY_Hito=100 then
						dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & "\"
					else
						if PRY_Hito=101 then
							dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & "\" & trim(PRE_NumCuota) & "\"
						else
							if PRY_Hito=105 then
								dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & "\p-" & trim(OES_Id) & "\"
							else
								if PRY_Hito=106 then
									dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & "\m-" & trim(OES_Id) & "\"
								else
									if PRY_Hito=107 then
										dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & "\inc-" & trim(IPR_Id) & "\"
									else
										if PRY_Hito=108 then
											dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & "\res-" & trim(IPR_Id) & "\"
										else
											if PRY_Hito=109 or PRY_Hito=110 or PRY_Hito=124 or PRY_Hito=125 then
												dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\curriculums\" & carpeta_informe & "\"
											else												
												if(IsNumeric(VER_Corr) and len(VER_Corr)>0) or (PRY_Hito=999) then
													if len(VER_Corr)>1 then
														yVER_Corr=""
														for i=0 to len(VER_Corr)
															if(isnumeric(mid(VER_Corr,i,1))) then
																yVER_Corr=yVER_Corr & mid(VER_Corr,i,1)
															end if
														next
													else
														yVER_Corr=cint(VER_Corr)
													end if	
													dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & "\documentos\tpo-" & yVER_Corr & "\"
												else
													if PRY_Hito=111 then
														dir="D:\DocumentosSistema\dialogosocial\" & carpeta_informe & "\" & REL_Rut & "\"
													else
														if(PRY_Hito>=112 and PRY_Hito<=114) or (LFO_Id=11 and PRY_Hito=115)then
															if(IsNumeric(PAT_Id) and len(PAT_Id)>0) then
																if len(PAT_Id)>1 then
																	yPAT_Id=""
																	for i=0 to len(PAT_Id)
																		if(isnumeric(mid(PAT_Id,i,1))) then
																			yPAT_Id=yPAT_Id & mid(PAT_Id,i,1)
																		end if
																	next
																else
																	yPAT_Id=cint(PAT_Id)
																end if
																dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & yPAT_Id & "\"
															end if
														else
															if PRY_Hito=115 then
																if(IsNumeric(ESC_Id) and len(ESC_Id)>0) then
																	if len(ESC_Id)>1 then
																		yESC_Id=""
																		for i=0 to len(ESC_Id)
																			if(isnumeric(mid(ESC_Id,i,1))) then
																				yESC_Id=yESC_Id & mid(ESC_Id,i,1)
																			end if
																		next
																	else
																		yESC_Id=cint(ESC_Id)
																	end if
																	dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & yESC_Id & "\"
																end if
															else
																if PRY_Hito=116 or ((PRY_Hito=117 or PRY_Hito=118) and LFO_Id=11) then
																	if(IsNumeric(ENP_Id) and len(ENP_Id)>0) then
																		if len(ENP_Id)>1 then
																			yENP_Id=""
																			for i=0 to len(ENP_Id)
																				if(isnumeric(mid(ENP_Id,i,1))) then
																					yENP_Id=yENP_Id & mid(ENP_Id,i,1)
																				end if
																			next
																		else
																			yENP_Id=cint(ENP_Id)
																		end if
																		dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & yENP_Id & "\"
																	end if
																else
																	if PRY_Hito=117 then
																		if(IsNumeric(PLC_Id) and len(PLC_Id)>0) then
																			if len(PLC_Id)>1 then
																				yPLC_Id=""
																				for i=0 to len(PLC_Id)
																					if(isnumeric(mid(PLC_Id,i,1))) then
																						yPLC_Id=yPLC_Id & mid(PLC_Id,i,1)
																					end if
																				next
																			else
																				yPLC_Id=cint(PLC_Id)
																			end if
																			dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & yPLC_Id & "\"
																		end if	
																	else
																		if PRY_Hito=118 then
																			if(IsNumeric(PCO_Id) and len(PCO_Id)>0) then
																				if len(PCO_Id)>1 then
																					yPCO_Id=""
																					for i=0 to len(PCO_Id)
																						if(isnumeric(mid(PCO_Id,i,1))) then
																							yPCO_Id=yPCO_Id & mid(PCO_Id,i,1)
																						end if
																					next
																				else
																					yPCO_Id=cint(PCO_Id)
																				end if
																				dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & yPCO_Id & "\"
																			end if	
																		else
																			if(LFO_Id=11) and (PRY_Hito>=119 and PRY_Hito<=122) then
																				if(IsNumeric(ENP_Id) and len(ENP_Id)>0) then
																					if len(ENP_Id)>1 then
																						yENP_Id=""
																						for i=0 to len(ENP_Id)
																							if(isnumeric(mid(ENP_Id,i,1))) then
																								yENP_Id=yENP_Id & mid(ENP_Id,i,1)
																							end if
																						next
																					else
																						yENP_Id=cint(ENP_Id)
																					end if
																					dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & yENP_Id & "\"
																				end if
																			else
																				if(PRY_Hito=122 and LFO_Id=11) then
																					if(IsNumeric(ENP_Id) and len(ENP_Id)>0) then
																						if len(ENP_Id)>1 then
																							yENP_Id=""
																							for i=0 to len(ENP_Id)
																								if(isnumeric(mid(ENP_Id,i,1))) then
																									yENP_Id=yENP_Id & mid(ENP_Id,i,1)
																								end if
																							next
																						else
																							yENP_Id=cint(ENP_Id)
																						end if
																						dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & yENP_Id & "\"
																					end if
																				else
																					if(PRY_Hito=123 and LFO_Id=11) then
																						if(IsNumeric(ENP_Id) and len(ENP_Id)>0) then
																							if len(ENP_Id)>1 then
																								yENP_Id=""
																								for i=0 to len(ENP_Id)
																									if(isnumeric(mid(ENP_Id,i,1))) then
																										yENP_Id=yENP_Id & mid(ENP_Id,i,1)
																									end if
																								next
																							else
																								yENP_Id=cint(ENP_Id)
																							end if
																							dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\" & carpeta_informe & yENP_Id & "\"
																						end if
																					else																						
																						dir="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\informes\" & carpeta_informe & "\"
																					end if
																				end if
																			end if
																		end if
																	end if
																end if
															end if
														end if
													end if
												end if
											end if
										end if
									end if
								end if
							end if
						end if
					end if
				end if
			end if
		end if
	end if
end if

cnn.close
set rs=nothing
set cnn=nothing
'response.Write(dir)
'response.End()

Dim objConn, strFile
Dim intCampaignRecipientID

'strFile = Request.QueryString("INF_Arc")
strFile = Request("INF_Arc")

If strFile <> "" Then

	dim fs
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	if fs.FileExists(dir & strFile) then
	  'response.write("File c:\asp\introduction.asp exists!")
	else
	  'response.write("File c:\asp\introduction.asp does not exist!")
	  response.write("Archivo no existe " & dir)
	  Response.end()
	end if
	set fs=nothing

    Response.Buffer = False
	Response.ContentType = "application/download"
    Response.AddHeader "Content-Length", fs.Size
	Response.Addheader "Content-Disposition", "attachment; filename=" & Replace(Replace(strFile," ","-"), ",","_")
	'Response.AddHeader("Content-Disposition", "attachment; filename='" & Replace(strFile," ","-") & "'")	
    Response.BinaryWrite objStream.Read
	
    Dim objStream
    Set objStream = Server.CreateObject("ADODB.Stream")    
    objStream.Open		
	objStream.Type = 1 'adTypeBinary
	'on error resume next
	objStream.LoadFromFile(dir & strFile)
	
	Do While NOT objStream.EOS AND Response.IsClientConnected
        Response.BinaryWrite objStream.Read(1024)
        Response.Flush()
    Loop
	'on error resume next
    'Response.ContentType = "application/x-unknown"
    'Response.Addheader "Content-Disposition", "attachment; filename=pepito.txt" '& strFile
	
    objStream.Close
    Set objStream = Nothing

End If
%>
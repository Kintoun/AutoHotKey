;;;;;;;;;; Hotkeys ;;;;;;;;;;
^F12::
#MaxThreadsPerHotkey 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Globals ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ProcessName := "FFXIVGAME"
Simulation := false ; no need to set here, controlled via UI

vCP = 343
;vProgress = 0 ; set by UI
;vDurability = 0 ; set by UI
;vCraftChoice = empty

class BaseSkill
{
	hotkey := "z"	
	delay := 0
	cp := 0
	durability := 0
	
	__New(h, d, c = 0, dura = 0)
	{
		this.hotkey := h
		this.delay := d
		this.cp := c
		this.durability := dura
	}
}

SkillMap := {}

; Buffs
SkillMap["InnerQuiet"] := new BaseSkill("x", 2200, 18, 0)
SkillMap["TricksOfTheTrade"] := new BaseSkill("z", 2200, -20, 0)
SkillMap["GreatStrides"] := new BaseSkill("q", 2200, 32, 0)
SkillMap["SteadyHand"] := new BaseSkill("4", 2200, 25, 0)
SkillMap["Innovation"] := new BaseSkill("8", 2200, 18, 0)
SkillMap["MakersMark"] := new BaseSkill("+q", 2200, 20, 0)

; Durability
SkillMap["Manipulation"] := new BaseSkill("3", 3500, 88, -30)
SkillMap["MastersMend"] := new BaseSkill("[", 3500, 160, -60)

; Quality
SkillMap["HastyTouch"] := new BaseSkill("2", 4000, 0, 10)
SkillMap["BasicTouch"] := new BaseSkill("e", 4000, 18, 10)
SkillMap["InnovativeTouch"] := new BaseSkill("]", 4000, 8, 10)
SkillMap["PreciseTouch"] := new BaseSkill("9", 4000, 18, 10)
SkillMap["AdvancedTouch"] := new BaseSkill("0", 4000, 48, 10)
SkillMap["Byregots"] := new BaseSkill("7", 4000, 24, 10)

; Progress
SkillMap["FlawlessSynthesis"] := new BaseSkill("+1", 4000, 0, 0)
SkillMap["CarefulSynthesis"] := new BaseSkill("1", 4000, 0, 10)

CraftMap := {}
DurabilityMap := {}

; Reusable sequences
InnoHastyx4 := ["InnovativeTouch", "HastyTouch", "HastyTouch", "HastyTouch", "HastyTouch"]
InnoHastyx3 := ["InnovativeTouch", "HastyTouch", "HastyTouch", "HastyTouch"]
InnoHastyx2 := ["InnovativeTouch", "HastyTouch", "HastyTouch"]

LowLevelMaterial := ["InnerQuiet", "BasicTouch", "Manipulation", "SteadyHand"]
LowLevelMaterial.Push(InnoHastyx4*)
LowLevelMaterial.Push("Manipulation", "SteadyHand", "InnovativeTouch", "InnovativeTouch", "GreatStrides", "Byregots", "CarefulSynthesis")
CraftMap["LowLevelMaterial"] := LowLevelMaterial
DurabilityMap["LowLevelMaterial"] := 40

ExtraLowLevelMaterial := ["InnerQuiet", "GreatStrides", "SteadyHand", "Innovation", "AdvancedTouch", "GreatStrides", "AdvancedTouch", "SteadyHand", "GreatStrides", "AdvancedTouch", "CarefulSynthesis"]
CraftMap["ExtraLowLevelMaterial"] := ExtraLowLevelMaterial
DurabilityMap["ExtraLowLevelMaterial"] := 40

StandardMaterial := ["InnerQuiet", "CarefulSynthesis", "Manipulation", "SteadyHand"]
StandardMaterial.Push(InnoHastyx4*)
StandardMaterial.Push("Manipulation", "SteadyHand", "InnovativeTouch", "InnovativeTouch", "GreatStrides", "Byregots", "CarefulSynthesis")
CraftMap["StandardMaterial"] := StandardMaterial
DurabilityMap["StandardMaterial"] := 40

DifficultMaterial := ["InnerQuiet", "CarefulSynthesis", "CarefulSynthesis", "Manipulation", "SteadyHand"]
DifficultMaterial.Push(InnoHastyx3*)
DifficultMaterial.Push("Manipulation", "SteadyHand", "InnovativeTouch", "InnovativeTouch", "GreatStrides", "Byregots", "CarefulSynthesis")
CraftMap["DifficultMaterial"] := DifficultMaterial
DurabilityMap["DifficultMaterial"] := 40

StandardItem2 := ["InnerQuiet", "SteadyHand"]
StandardItem2.Push(InnoHastyx4*)
StandardItem2.Push("CarefulSynthesis")
StandardItem2.Push("MastersMend", "SteadyHand")
StandardItem2.Push(InnoHastyx4*)
StandardItem2.Push("SteadyHand", "Innovation", "HastyTouch", "GreatStrides", "Byregots")
StandardItem2.Push("CarefulSynthesis")
CraftMap["StandardItem2"] := StandardItem2
DurabilityMap["StandardItem2"] := 80

StandardItem3 := ["InnerQuiet", "SteadyHand"]
StandardItem3.Push(InnoHastyx4*)
StandardItem3.Push("CarefulSynthesis")
StandardItem3.Push("MastersMend", "CarefulSynthesis", "SteadyHand")
StandardItem3.Push(InnoHastyx3*)
StandardItem3.Push("SteadyHand", "Innovation", "HastyTouch", "GreatStrides", "Byregots")
StandardItem3.Push("CarefulSynthesis")
CraftMap["StandardItem3"] := StandardItem3
DurabilityMap["StandardItem3"] := 80
			
;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Main ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

; If we're already running, then hotkey again means STOP
if KeepRunning
{
	SignalStop()
    return
}
KeepRunning := true
ShowDialog()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Functions ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ShowDialog()
{	
	global
	
	Gui, Add, DropDownList, vCraftChoice, LowLevelMaterial|ExtraLowLevelMaterial|StandardMaterial|DifficultMaterial|StandardItem2|StandardItem3
	Gui, Add, Button, default xm section, Do Once
	Gui, Add, Button, ys, Repeat
	Gui, Add, Button, ys, Pause
	Gui, Add, Button, ys, Stop
	Gui, Add, Button, ys, Run Simulation
	
	Gui, Show,, Crafting Helper
	return
	
	ButtonOK:
	ButtonDoOnce:
	Gui, Submit, NoHide
	Run(CraftChoice, 1)
	return
	
	ButtonRepeat:
	Gui, Submit, NoHide
	Run(CraftChoice, 9999)
	return
	
	ButtonRunSimulation:
	Gui, Submit, NoHide
	Run(CraftChoice, 1, true)
	return
	
	ButtonPause:
	Pause,,1
	return
	
	ButtonStop:
	SignalStop()
	return
	
	GuiClose:
	ExitApp
}

Run(CraftChoice, Iterations, RunSimulation = false)
{
	global
	
	if (Iterations < 1)
	{
		MsgBox % "Invalid parameters"
		return
	}
	
	KeepRunning := true
	Simulation := RunSimulation
	
	if (Simulation)
	{
		ProcessName := "Notepad"
	}
	else
	{
		ProcessName := "FFXIVGAME"
	}
	
	Tooltip Running
	Sleep 1000
	Tooltip
	
	Loop %Iterations%
	{
		DoOnce(CraftChoice)
		
		if Simulation or not KeepRunning
			break
		
		Sleep 7000
	}
	
	Tooltip Done
	Sleep 1000
	Tooltip
	KeepRunning := false
	return
}

DoOnce(CraftChoice)
{
	global KeepRunning, Simulation

	BasicCraft(CraftChoice)
}

BasicCraft(CraftChoice)
{
	global
	
	CurrentCP := vCP
	Durability := DurabilityMap[CraftChoice]
	
	if (not Simulation)
	{
		StartSynthesis()
		Sleep 1500
	}
	
	Craft := CraftMap[CraftChoice]
	Loop % Craft.MaxIndex()
		ExecuteAction(Craft[A_Index], CurrentCP, Durability)

	if (Simulation)
	{
		SendToGame("{Enter}", 100) ;newline for Notepad
		MsgBox % "Simulation results CP: " CurrentCP ", Dura: " Durability
	}
	
	return
}

Mine()
{
	SendToGame("{Numpad0}", 500)
	SendToGame("{Numpad0}", 500)
	SendToGame("{Numpad0}", 500)
	SendToGame("{Numpad0}", 500)
	SendToGame("{Numpad0}", 500)
	SendToGame("{Numpad0}", 500)
	SendToGame("{Numpad0}", 500)
	SendToGame("{Numpad0}", 500)
}

StartSynthesis()
{	
	SendToGame("{Numpad0}", 750)	
	SendToGame("{Numpad0}", 1000)
	
	SendToGame("{Numpad0}", 500)
}

SetHQCount(HQNum = 0)
{
	SendToGame("{Numpad8}", 500)
	SendToGame("{Numpad6}", 500)
	SendToGame("{Numpad6}", 500)
	
	Loop %HQNum%
	{
		SendToGame("{Numpad0}", 500)
	}
	
	SendToGame("{Numpad2}", 500)
}

ExecuteAction(name, ByRef cp, ByRef durability)
{
	global 
	
	Skill := SkillMap[name]
	
	if (Simulation)
	{
		SendToGame(Skill.hotkey, 100)
	}
	else
	{
		SendToGame(Skill.hotkey, Skill.delay)
	}
	
	cp -= Skill.cp
	durability -= Skill.durability
	
	return
}

SendToGame(KeyToSend, SleepTime)
{
	global ProcessName
	ControlSend,, %KeyToSend%, ahk_class %ProcessName%
	Sleep %SleepTime%
}

SignalStop()
{
	global KeepRunning
	
	KeepRunning := false
	Tooltip Stopping after this loop
	Sleep 2000
	Tooltip
}
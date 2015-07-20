;;;;;;;;;; Hotkeys ;;;;;;;;;;
^F12::
#MaxThreadsPerHotkey 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Globals ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ProcessName := "FFXIVGAME"
Simulation := false

vCP = 343
vProgress = 0 ; set by UI
vDurability = 0 ; set by UI

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

; Durability
SkillMap["Manipulation"] := new BaseSkill("3", 3500, 88, -30)
SkillMap["MastersMend"] := new BaseSkill("+3", 3500, 160, -60)

; Quality
SkillMap["HastyTouch"] := new BaseSkill("2", 4000, 0, 10)
SkillMap["BasicTouch"] := new BaseSkill("e", 4000, 18, 10)
SkillMap["InnovativeTouch"] := new BaseSkill("0", 4000, 8, 10)
SkillMap["PreciseTouch"] := new BaseSkill("9", 4000, 18, 10)
SkillMap["AdvancedTouch"] := new BaseSkill("+e", 4000, 48, 10)
SkillMap["Byregots"] := new BaseSkill("7", 4000, 24, 10)

; Progress
SkillMap["CarefulSynthesis"] := new BaseSkill("1", 4000, 0, 10)

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
	
	Gui, Add, Text,, Progress:
	Gui, Add, Text,, Durability:		
	Gui, Add, Edit, vProgress ym
	Gui, Add, Edit, vDurability
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
	Run(Progress, Durability, 1)
	return
	
	ButtonRepeat:
	Gui, Submit, NoHide
	Run(Progress, Durability, 9999)
	return
	
	ButtonRunSimulation:
	Gui, Submit, NoHide
	Run(Progress, Durability, 1, true)
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

Run(Progress, Durability, Iterations, RunSimulation = false)
{
	global
	
	if (Progress < 1 or Durability < 1 or Iterations < 1)
	{
		MsgBox % "Invalid parameters - Progress:" Progress ", Durability:" Durability
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
		DoOnce(Progress, Durability)
		
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

DoOnce(Progress, Durability)
{
	global KeepRunning, Simulation

	BasicCraft(Progress, Durability)
}

BasicCraft(Progress, Durability)
{
	global
	
	CurrentCP := vCP
	
	if (not Simulation)
	{
		StartSynthesis()
		Sleep 1500
	}
	
	ExecuteAction("InnerQuiet", CurrentCP, Durability)
	
	if (Durability = 40)
	{
		if (Progress <= 1)
		{
			ExecuteAction("BasicTouch", CurrentCP, Durability)
			
			ExecuteAction("Manipulation", CurrentCP, Durability)
			ExecuteAction("SteadyHand", CurrentCP, Durability)
			
			ExecuteAction("InnovativeTouch", CurrentCP, Durability)
			ExecuteAction("HastyTouch", CurrentCP, Durability)
			ExecuteAction("HastyTouch", CurrentCP, Durability)
			ExecuteAction("HastyTouch", CurrentCP, Durability)
			ExecuteAction("HastyTouch", CurrentCP, Durability)
			
			ExecuteAction("Manipulation", CurrentCP, Durability)
			ExecuteAction("SteadyHand", CurrentCP, Durability)
			
			ExecuteAction("InnovativeTouch", CurrentCP, Durability)
			ExecuteAction("InnovativeTouch", CurrentCP, Durability)
			ExecuteAction("GreatStrides", CurrentCP, Durability)
			ExecuteAction("Byregots", CurrentCP, Durability)
		}
		else
		{
			Loop % Progress - 1
			{
				ExecuteAction("CarefulSynthesis", CurrentCP, Durability)
			}
		}
		
		; Finish
		ExecuteAction("CarefulSynthesis", CurrentCP, Durability)
	}
	else if (Durability = 35)
	{
	}
	else if (Durability = 80)
	{
		ExecuteAction("SteadyHand", CurrentCP, Durability)
		
		ExecuteAction("InnovativeTouch", CurrentCP, Durability)
		ExecuteAction("HastyTouch", CurrentCP, Durability)
		ExecuteAction("HastyTouch", CurrentCP, Durability)
		ExecuteAction("HastyTouch", CurrentCP, Durability)
		ExecuteAction("HastyTouch", CurrentCP, Durability)
		
		Loop % Progress - 1
		{
			ExecuteAction("CarefulSynthesis", CurrentCP, Durability)
		}
		
		ExecuteAction("MastersMend", CurrentCP, Durability)
		
		ExecuteAction("SteadyHand", CurrentCP, Durability)
		
		ExecuteAction("InnovativeTouch", CurrentCP, Durability)
		ExecuteAction("HastyTouch", CurrentCP, Durability)
		ExecuteAction("HastyTouch", CurrentCP, Durability)
		ExecuteAction("HastyTouch", CurrentCP, Durability)
		
		ExecuteAction("SteadyHand", CurrentCP, Durability)		
		ExecuteAction("InnovativeTouch", CurrentCP, Durability)
		ExecuteAction("GreatStrides", CurrentCP, Durability)
		ExecuteAction("Byregots", CurrentCP, Durability)
		
		; Finish
		ExecuteAction("CarefulSynthesis", CurrentCP, Durability)
	}
	else if (Durability = 70)
	{
	}
	
	if (Simulation)
	{
		MsgBox % "Simulation results CP: " CurrentCP ", Dura: " Durability
	}
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
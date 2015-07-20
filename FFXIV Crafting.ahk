;;;;;;;;;; Hotkeys ;;;;;;;;;;
; Press Ctrl+Alt+P to pause. Press it again to resume.
^!p::Pause
#MaxThreadsPerHotkey 3
^F12::
#MaxThreadsPerHotkey 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Globals ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ProcessName := "FFXIVGAME"
Simulation := true
if (Simulation)
{
	ProcessName := "Notepad"
}

vCP = 343
vProgress = 0 ; set by UI
vDurability = 0 ; set by UI

class BaseSkill
{
	name := "none"
	hotkey := "z"	
	delay := 0
	cp := 0
	durability := 0
	
	__New(n, h, d, c = 0, dura = 0)
	{
		this.name := n
		this.hotkey := h
		this.delay := d
		this.cp := c
		this.durability := dura
	}
}

SkillMap := {}

; Buffs
SkillMap["InnerQuiet"] := new BaseSkill("InnerQuiet", "x", 2200, 18, 0)
SkillMap["TricksOfTheTrade"] := new BaseSkill("TricksOfTheTrade", "z", 2200, -20, 0)
SkillMap["GreatStrides"] := new BaseSkill("GreatStrides", "q", 2200, 32, 0)
SkillMap["SteadyHand"] := new BaseSkill("SteadyHand", "4", 2200, 25, 0)
SkillMap["Innovation"] := new BaseSkill("Innovation", "8", 2200, 18, 0)

; Durability
SkillMap["Manipulation"] := new BaseSkill("Manipulation", "3", 3500, 88, -30)
SkillMap["MastersMend"] := new BaseSkill("MastersMend", "+3", 3500, 160, -60)

; Quality
SkillMap["HastyTouch"] := new BaseSkill("HastyTouch", "2", 4000, 0, 10)
SkillMap["BasicTouch"] := new BaseSkill("BasicTouch", "e", 4000, 18, 10)
SkillMap["InnovativeTouch"] := new BaseSkill("InnovativeTouch", "0", 4000, 8, 10)
SkillMap["PreciseTouch"] := new BaseSkill("PreciseTouch", "9", 4000, 18, 10)
SkillMap["AdvancedTouch"] := new BaseSkill("AdvancedTouch", "+e", 4000, 48, 10)
SkillMap["Byregots"] := new BaseSkill("Byregots", "7", 4000, 24, 10)

; Progress
SkillMap["CarefulSynthesis"] := new BaseSkill("CarefulSynthesis", "1", 4000, 0, 10)

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
	Gui, Add, Button, ys, Stop
	
	Gui, Show,, Crafting Helper
	return
	
	ButtonOK:
	ButtonDoOnce:
	KeepRunning := true
	Gui, Submit, NoHide
	Run(Progress, Durability, 1)
	return
	
	ButtonRepeat:
	KeepRunning := true
	Gui, Submit, NoHide
	Run(Progress, Durability, 9999)
	return
	
	ButtonStop:
	GuiClose:
	SignalStop()
	return
}

Run(Progress, Durability, Iterations)
{
	global
	
	if (Progress < 1 or Durability < 1 or Iterations < 1)
	{
		MsgBox % "Invalid parameters - Progress:" Progress ", Durability:" Durability
		return
	}
	
	Tooltip Running
	Sleep 1000
	Tooltip
	
	Loop %Iterations%
	{
		DoOnce(Progress, Durability)
		if not KeepRunning
			break
	}
	
	Tooltip Done
	Sleep 1000
	Tooltip
	KeepRunning := false
	return
}

DoOnce(Progress, Durability)
{
	global KeepRunning

	BasicCraft(Progress, Durability)
	
	if KeepRunning
		Sleep 7000
}

BasicCraft(ProgressRequiredToComplete, Durability)
{
	global
	
	CurrentCP := vCP
	
	StartSynthesis()
	Sleep 1500
	
	ExecuteAction("InnerQuiet", CurrentCP, Durability)
	
	if (Durability = 40)
	{
		if (ProgressRequiredToComplete <= 1)
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
			Loop % ProgressRequiredToComplete - 1
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
		
		Loop % ProgressRequiredToComplete - 1
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
		MsgBox % CurrentCP "," Durability
	}
}

GSMTrivial()
{
	global
	
	StartSynthesis()
	Sleep 1500
	
	SendToGame(INNER_QUIET, 2200)
	
	SendToGame(GREAT_STRIDES, 2200)
	SendToGame(STEADY_HAND, 2200)
	SendToGame(INNOVATION, 2200)
	SendToGame(QUALITY, 4000)
	SendToGame(GREAT_STRIDES, 2200)
	SendToGame(QUALITY, 4000)
	SendToGame(STEADY_HAND, 2200)
	SendToGame(GREAT_STRIDES, 2200)
	SendToGame(QUALITY, 4000)
	
	SendToGame(PROGRESS, 4000)
}

LargeFood()
{
	global
	
	StartSynthesis()
	Sleep 1500
	
	SendToGame(INNER_QUIET, 2200)
	
	SendToGame(STEADY_HAND, 3000)
	
	SendToGame(INNO_TOUCH, 4000)
	SendToGame(HASTY_TOUCH, 4000)
	SendToGame(HASTY_TOUCH, 4000)
	SendToGame(HASTY_TOUCH, 4000)
	SendToGame(HASTY_TOUCH, 4000)
	
	SendToGame(PROGRESS, 4000)
	
	SendToGame(LARGE_DURABILITY, 3500)
	
	SendToGame(STEADY_HAND, 3000)
	
	SendToGame(BASIC_TOUCH, 4000)
	SendToGame(INNO_TOUCH, 4000)
	SendToGame(INNO_TOUCH, 4000)
	
	SendToGame(GREAT_STRIDES, 2200)
	SendToGame(BYREGOTS, 4000)
	
	SendToGame(PROGRESS, 4000)
	SendToGame(PROGRESS, 4000)
}

GSMGrind(StartWithProgress = 0)
{
	global
	
	StartSynthesis()
	Sleep 1500
	
	SendToGame(INNER_QUIET, 2200)
	
	if StartWithProgress > 0
	{
		SendToGame(PROGRESS, 4000)
	}
	else
	{
		;SendToGame(HASTY_TOUCH, 4000)
		SendToGame(BASIC_TOUCH, 4000)
	}
	
	SendToGame(DURABILITY, 3500)
	SendToGame(STEADY_HAND, 3000)
	
	SendToGame(INNO_TOUCH, 4000)
	SendToGame(HASTY_TOUCH, 4000)
	SendToGame(HASTY_TOUCH, 4000)
	SendToGame(HASTY_TOUCH, 4000)
	SendToGame(HASTY_TOUCH, 4000)
	
	SendToGame(DURABILITY, 3500)
	SendToGame(STEADY_HAND, 3000)
	
	SendToGame(INNO_TOUCH, 4000)
	SendToGame(HASTY_TOUCH, 4000)
	
	SendToGame(GREAT_STRIDES, 2200)
	;SendToGame(INNOVATION, 2200)
	SendToGame(BYREGOTS, 4000)
	
	SendToGame(PROGRESS, 4000)
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

StartSynthesis(HQNum = 0)
{	
	SendToGame("{Numpad0}", 750)	
	SendToGame("{Numpad0}", 1000)
	
	;SetHQCount(HQNum)
	
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
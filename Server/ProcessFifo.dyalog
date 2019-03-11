 r←ProcessFifo(ic fifoCommand content)
 (Q message)←content
 ⎕←'INCOMING FIFO MESSAGE: ',message

⍝ call a function that the user will override
⍝ user defined exit to declare what queue the task belongs to

⍝ OVERRIDEQ returns Q as default
⍝ user specifies an override to the function to handle different Q logic
⍝ Q←Q OVERRIDEQ message

 AddNewQ Q
 :If Q_TODO_TABLE≢⍬
     Q_TODO_TABLE⍪←QS∊(⊆Q)
 :Else
     Q_TODO_TABLE←(1 (≢QS))⍴QS∊⊆Q
 :EndIf

 ic.Respond fifoCommand'SUCCESS'
 TODO←TODO,⊆message
 r←0

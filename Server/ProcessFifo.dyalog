 r←ProcessFifo(ic fifoCommand content);Q;message
 (Q message)←content
 ⎕←'Incoming FIFO message: ',message

⍝ call a function that the user will override
⍝ user defined exit to declare what queue the task belongs to

⍝ OVERRIDEQ returns Q as default
⍝ user specifies an override to the function to handle different Q logic
⍝ Q←Q OVERRIDEQ message

 Q←message DefaultOverrideQ Q

 AddNewQ Q

 :If Q_TODO_TABLE≢⍬
     Q_TODO_TABLE⍪←QS∊(⊆Q)
 :Else
     Q_TODO_TABLE←(1(≢QS))⍴QS∊⊆Q
 :EndIf
 PROCESSED,←0

 TASK_ID,←1+≢TASK_ID
 TODO,←(⊂message ⎕TS)
 ic.Respond fifoCommand'SUCCESS'

 r←0

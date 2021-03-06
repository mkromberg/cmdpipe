EXEC task;⎕TRAP;r

 (expr timestamp task_id)←3↑task

 timeStarted ← ⎕TS
 :If DEBUG
     ⎕TRAP←(777 'C' '→ERROR')(0 'E' 'HandleDebug')
 :Else
     ⎕TRAP←0 'C' '→ERROR'
 :EndIf

 ⍝ If there is an error, Handle Debug sets success to 0
 success←1
 r←⍎expr
 timeCompleted ← ⎕TS
 ⎕←r
 ⎕←'Process successful. Sending results to server...'

 status←(success+1)⊃'ERROR' 'FINISHED'

 ##.Utils.Check ic.Send commandName('WORKER' ((task_id timeStarted timeCompleted expr r) status))

 →0

 ERROR:
     ⎕←'Notify server of error'
     ##.Utils.Check ic.Send commandName ('WORKER' (('Error proccessing: ' task) 'ERROR'))
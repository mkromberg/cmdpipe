 r←main(ic client);DONE;code;command;event;task
 ⍝ comment
 DONE←0
 ic.SetProp'.' 'EventMode' 1

⍝ the WORKER is ready to accept work
 ic.Send client('WORKER' 'Ready')

 :While ~DONE
     (code command event task)←ic.Wait client 10000

     :If ~code=0
         DONE←1
         ⎕←'Error'
     :ElseIf event≡'Close'
         DONE←1
         ⎕←'Server closed the connection'
     :EndIf

     :If task
    ⍝ TODO: PROCESS TASK
         ⎕←'Process a task now'

    ⍝ After task is complete: WORKER IS READY
         ic.Send client('WORKER' 'Ready')
     :EndIf
 :EndWhile
 r←0

r←Main
r←0
 r←Main(ic client QNames);DONE;code;command;event;task;commandName

 DONE←0
 ic.SetProp'.' 'EventMode' 1
 commandName←client,'.WorkerReady'

⍝ the WORKER is ready to accept work
 ##.Utils.Check ic.Send commandName('ADMIN')

 :While ~DONE
     (code command event task)←ic.Wait commandName 10000
     :If code≠0
         DONE←1
         ⎕←'Unexpected Error.'
         :Continue
     :EndIf

     :Select event
     :Case 'Close'
         DONE←1
         ⎕←'Server closed the connection.'
     :Case 'Receive'
        ⍝ TODO: PROCESS TASK
         ⎕←'Processing: 'task

         success←~∨/'ERROR'⍷task

         :If ∨/'DEBUG'⍷task
             a←'1÷0'
             EXEC a
         :Else
             EXEC'1+1'
         :EndIf

     :Case 'Timeout'
         ⎕←'Max time waited'
     :EndSelect
 :EndWhile
 r←0

⍝ could be used to start a client WORKER instance on command
⍝ ]load APLProcess

⍝ - statistical analysis
⍝ - terminate WORKERS
⍝ - set DEBUG mode



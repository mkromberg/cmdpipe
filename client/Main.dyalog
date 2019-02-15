 r←Main(ic client);DONE;code;command;event;task;commandName
 ⍝ comment
 DONE←0
 ic.SetProp'.' 'EventMode' 1
 commandName←client,'.WorkerReady'

⍝ the WORKER is ready to accept work
 ##.Utils.Check ic.Send commandName ('WORKER' 'Ready')

 :While ~DONE
    (code command event task)←ic.Wait commandName 10000
    :If code≠0
         DONE←1
         ⎕←'Log This Error'
        :Continue
    :EndIf

    :Select event
    :Case 'Close'
         DONE←1
         ⎕←'Server closed the connection'
    :Case 'Receive'
        ⍝ TODO: PROCESS TASK
        ⎕←'Process a task now'
        ⍝ After task is complete: WORKER IS READY
        ##.Utils.Check ic.Send commandName ('WORKER' 'Ready')
    :Case 'Timeout'
        ⎕←'Max time waited'
    :EndSelect    
 :EndWhile
 r←0

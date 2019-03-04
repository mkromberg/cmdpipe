 r←Main(ic client QNames);DONE;code;command;event;task;commandName

 DONE←0
 ic.SetProp'.' 'EventMode' 1
 commandName←client,'.WorkerReady'

⍝ the WORKER is ready to accept work
 ##.Utils.Check ic.Send commandName ('WORKER' QNames)

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
        ⎕←task
        ⍝ After task is complete: WORKER IS READY
        ##.Utils.Check ic.Send commandName ('WORKER' QNames)
    :Case 'Timeout'
        ⎕←'Max time waited'
    :EndSelect    
 :EndWhile
 r←0

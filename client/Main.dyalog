 r←Main(QNames ic client);DONE;code;command;event;task;commandName;DEBUG

 DONE←DEBUG←0
 ic.SetProp'.' 'EventMode' 1
 commandName←client,'.WorkerReady'

⍝ the WORKER is ready to accept work
 ##.Utils.Check ic.Send commandName('WORKER'(QNames 'START'))

 :While ~DONE
     (code command event task)←a←ic.Wait commandName 10000
     :If code≠0
         DONE←1
         ⎕←'Unexpected Worker Error.'
         :Continue
     :EndIf

     :Select event
     :Case 'Close'
         DONE←1
         ⎕←'Server closed the connection.'
	 
     :Case 'Receive'
        ⍝ TODO: PROCESS TASK
	⎕←'task info'
	⎕←task
	⎕←⍴task
	:If 'DEBUG'≡⊃task
	    DEBUG←~DEBUG
	    ⎕←'DEBUGGING: ',(1+DEBUG)⌷'OFF' 'ON'
 	    ##.Utils.Check ic.Send commandName('WORKER'(QNames 'START'))
	:Else
	    ⎕←'Processing: 'task
	    EXEC task
	:EndIf

     :Case 'Timeout'
         ⎕←'Max time waited'
     :EndSelect
 :EndWhile
 r←0

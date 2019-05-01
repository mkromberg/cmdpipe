 r←Main(QNames ride_port ic client);DONE;code;command;event;args;commandName;DEBUG

 RIDE_PORT←ride_port
 DONE←DEBUG←0
 ic.SetProp'.' 'EventMode' 1
 commandName←client,'.WorkerReady'

 ⍝ the WORKER is ready to accept work
 ##.Utils.Check ic.Send commandName('WORKER'((QNames RIDE_PORT) 'START'))

 :While ~DONE
     (code command event args)←a←ic.Wait commandName 10000
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
        (message body)←args
        :Select message
	    :Case 'TASK'
	        ⍝ this is unpacked to make debugging easier
	        (task time id)←3↑body
		⎕←'Processing: 'body
		EXEC task time id

	    :Case 'DEBUGMODE'
	        ⍝ server sets the debug mode on the worker
		DEBUG←body
		⎕←'DEBUGGING: ',(1+DEBUG)⌷'OFF' 'ON'
		##.Utils.Check ic.Send commandName('WORKER' (⊂'READY'))

	    :Case 'ERROR'
		⎕←body
		##.Utils.Check ic.Send commandName('WORKER' (⊂'READY'))

	:EndSelect

     :Case 'Timeout'
         ⎕←'Max time waited'
     :EndSelect
 :EndWhile
 r←0

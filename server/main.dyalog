 r←main(ic server);code;command;event;body;type;content;DONE;TODO;WORKERS

 ⍝ INIT CODE: MOVE THIS SOMEWHERE
 DONE←0
 WORKERS←⍬
 TODO←⍬
 r←0

 ic.SetProp'.' 'EventMode' 1
 :While ~DONE
     assignWork 0
     (code command event body)←4↑ic.Wait server 10000
     (type content)←body

     ⍝ logEvent event body

     :If ~code=0
         ⎕←'Server is broken we cant do anything further so we are done.'
         DONE←1
         :Continue
     :EndIf

     :Select event
     :Case 'Receive'
         :If type≡'FIFO'
             processFifo content
         :ElseIf type≡'WORKER'
             processWorker command
         :EndIf
     :Case 'Connect'
         ⎕←'Do some connect things'
     :Case 'Close'
         ⎕←'Do some close things'
     :Case 'TIMEOUT'
         ⍝ Do something with the timeout message?
     :EndSelect

 :EndWhile

 r←Main(ic server);code;command;event;body;type;content;DONE;TODO;WORKERS;WORKERSTATUS;Q_WORKERS_TABLE;Q_TODO_TABLE;QS

 ⍝ Call Main by calling Server.Make with a port number
 ⍝ Ex.) Server.Main Server.Make 3500

⍝ add a list of historical total queues
⍝ when a todo/worker mentions a queue, store them
 DONE←0
 WORKERSTATUS←⍬
 WORKERS←⍬
 TODO←⍬
 Q_WORKERS_TABLE←⍬
 Q_TODO_TABLE←⍬
 QS←⍬
 r←0

 ic.SetProp'.' 'EventMode' 1
 :While ~DONE
     AssignWork 0
     (code command event body)←4↑ic.Wait server 10000

     ⎕←code command event body
     (type content)←body

     :If ~code=0
         ⎕←'Server is broken we cant do anything further so we are done.'
         DONE←1
         :Continue
     :EndIf

     :Select event
     :Case 'Receive'
         :If type≡'FIFO'
             ProcessFifo ic command content
         :ElseIf type≡'WORKER'
             ProcessWorker command content
         :EndIf
     :Case 'Connect'
         ⎕←'Do some connect things'
     :Case 'Close'
         ⎕←'Do some disconnect things'
         ⎕←'Add functionality to remove the worker from the queue'

     :Case 'TIMEOUT'
         ⍝ Do something with the timeout message?
     :EndSelect

 :EndWhile

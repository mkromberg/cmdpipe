 r←Main(ic server);code;command;event;body;type;content;DONE;TODO;WORKERS;WORKERSTATUS;Q_WORKERS_TABLE;Q_TODO_TABLE;QS

 ⍝ Call Main by calling Server.Make with a port number
 ⍝ Ex.) Server.Main Server.Make 3500

 ⍝ TODO: REFACTOR - update the table names
 ⍝ QvsWORKERS
 DONE r  ← 0
 WORKERS ← WORKERSTATUS ← Q_WORKERS_TABLE ← ⍬
 QS      ← TODO         ← Q_TODO_TABLE    ← ⍬
 ERROR_HISTORY ← ⍬

 PrintState ← {
     ⎕←'Worker table'
     ⎕←('worker command name' 'status',QS)⍪(WORKERS,WORKERSTATUS,Q_WORKERS_TABLE)
     ⎕←''

     ⎕←'TODO TABLE'
     ⎕←((⊂'Todo message'),QS)⍪(TODO,Q_TODO_TABLE)
     ⎕←''
 }


 ic.SetProp'.' 'EventMode' 1
 :While ~DONE
     AssignWork 0
     PrintState 0
     (code command event body)← 4↑ic.Wait server 10000
     (type content)           ← body

     :If ~code=0
         ⎕←'Unexpected server failure'
         DONE←1
         :Continue
     :EndIf

     :Select event
     :Case 'Receive'
         :If type≡'FIFO'
             ProcessFifo ic command content

         :ElseIf type≡'WORKER'
             ⎕←'why is this happening?'
             ProcessWorker command content
         :EndIf

     :Case 'Connect'
        ⍝ TODO: Handle connect?

     :Case 'Closed'
         ⎕←command ' disconnected from server. '
         RemoveWorker command

     :Case 'TIMEOUT'
         ⍝ TODO: Do something with the timeout message?
     :EndSelect

 :EndWhile

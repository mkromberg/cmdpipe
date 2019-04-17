 r←Main(ic server);code;command;event;body;type;content;DONE;TODO;WORKERS;WORKERSTATUS;Q_WORKERS_TABLE;Q_TODO_TABLE;QS;WORKERS_TIME;DEBUG_MODE;RESULT_HISTORY;TASK_COMPLETED_HISTORY;ERROR_HISTORY;DEFAULT;PROCESSED;TASK_ID

 ⍝ Call Main by calling Server.Make with a port number
 ⍝ Ex.) Server.Main Server.Make 3500
 ⍝ TODO: REFACTOR - update the table names
 ⍝ QvsWORKERS

 DEBUG_MODE←1
 DONE r←0

 WORKERS←WORKERS_TIME←WORKERSTATUS←Q_WORKERS_TABLE←⍬
 TODO←Q_TODO_TABLE←⍬ ⍝ A TODO item is a task that has yet to be started
 TASK_ID←⍬
 PROCESSED←⍬

 TASK_COMPLETED_HISTORY←RESULT_HISTORY←⍬

 ERROR_HISTORY←⍬
 QS←DEFAULT←⊂'DEFAULT'

 PrintState←{
     ⎕←'Worker table:'
     ⎕←('WORKER COMMAND NAME' 'READY TIME' 'STATUS',QS)⍪(WORKERS,WORKERS_TIME,WORKERSTATUS,Q_WORKERS_TABLE)
     ⎕←WORKERS_TIME
     ⎕←''

     columns←'Message' 'Time Submitted' 'Time Started' 'Time Completed'
     n←⊃⌽⍴↑TODO
     ⎕←'TODO TABLE:'
     ⎕←(('ID' 'PROCESSED',QS)⍪(TASK_ID,PROCESSED,Q_TODO_TABLE)),(n↑columns)⍪↑TODO
     ⎕←''

     ⎕←'ERROR HISTORY:'
     ⎕←↑ERROR_HISTORY
     ⎕←''

     ⎕←'RESULTS: '
     ⎕←('TASK' 'RESULT')⍪↑RESULT_HISTORY
     ⎕←''
 }


 ic.SetProp'.' 'EventMode' 1
 :While ~DONE
     AssignWork 0
     PrintState 0
     (code command event body)←4↑ic.Wait server 10000
     (type content)←body

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
             ProcessWorker command content

         :ElseIf type≡'ADMIN'
             ⍝ can command/control/request status/health
             ProcessAdmin command content ic
             ⍝ 1. request status -> nested array that contains canonical info
             ⍝ 2. enable and disable debugging for specific WORKER
             ⍝    - modify debugging code
             ⍝    - should run specified user function
             ⍝    - depending on if debugging is allowed
             ⍝        - TODO(MORTEN): setup trapping
             ⍝    - if debugging is off
             ⍝        - trap errors in specified function
             ⍝        - report error
         :EndIf

     :Case 'Connect'
        ⍝ TODO: Handle connect?

     :Case 'Closed'
         ⎕←command' disconnected from server. '
         RemoveWorker command

     :Case 'TIMEOUT'
         ⍝ TODO: Do something with the timeout message?
     :EndSelect

 :EndWhile

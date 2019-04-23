 r←ProcessWorker args;statuses;getStatus;worker;qs;status;message;eqs;body;task_id;timeStarted;timeCompleted;expr;r;statuses
 ⍝ args are command and workerQNames
 statuses←'DEBUG' 'BUSY' 'READY'
 getStatus←{(statuses⍳⊆⍵)-2}

 (worker message)←args    ⍝ for more information about this data structure
 (body status)   ←message ⍝ see ../client/Main.dyalog

 :Select status
 :Case 'START' ⍝ add worker to qs add new qs to qs table
     qs←body
     AddNewQ qs
     eqs←DEFAULT,⊆qs
     :If ~(⊆worker)∊WORKERS
         WORKERS_TIME,←⊂⎕TS
         WORKERS,←⊆worker
         WORKERSTATUS,←0
         :If QvsWORKERS≢⍬
             QvsWORKERS⍪←QS∊eqs
         :Else
             QvsWORKERS←(1(≢QS))⍴QS∊eqs
         :EndIf
     :EndIf
     ⍝ worker is not ready yet, set the debug mode for the worker
     ic.Respond worker ('DEBUGMODE' DEBUG_MODE)
     status←'READY'
     

 :Case 'FINISHED' ⍝ record results and task
     (task_id timeStarted timeCompleted expr r) ← 5↑body
     RESULT_HISTORY,←⊂expr r
     TASKS[task_id] ←⊂(⊃TASKS[task_id]),timeStarted timeCompleted
     PROCESSED[task_id]←1
     status←'READY'

 :Case 'READY'
     debugMessage←'WORKER IS READY'
     status←'READY'

 :Case 'ERROR'
     ERROR_HISTORY,←⊂worker debugMessage
     ic.Respond worker ('ERROR' 'ERROR received')
     status←'READY' ⍝ worker should be ready after an error occurs

 :Case 'DEBUG'
     qs←body
     ⎕←'DEBUG MESSAGE: '
     ⎕←debugMessage←qs
     ⎕←''
     ERROR_HISTORY,←⊂worker debugMessage
     ic.Respond worker ('DEBUG' 'Server is waiting for worker to finish debugging...')

 :EndSelect

 WORKERSTATUS[WORKERS⍳⊆worker]←getStatus status

 r←0

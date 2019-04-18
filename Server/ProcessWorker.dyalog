 r←ProcessWorker args;statuses;getStatus;worker;qs;status;message;eqs;body
 ⍝ args are command and workerQNames
 statuses←'DEBUG' 'BUSY' 'READY'
 getStatus←{(statuses⍳⊆⍵)-2}

 (worker message)←args    ⍝ for more information about this data structure
 (body status)←message ⍝ see ../client/Main.dyalog

 :Select status
 :Case 'START' ⍝ add worker to qs add new qs to qs table

     qs←body
     AddNewQ qs
     eqs←DEFAULT,⊆qs
     :If ~(⊆worker)∊WORKERS
         WORKERS_TIME,←⊂⎕TS
         WORKERS,←⊆worker
         WORKERSTATUS,←0
         :If Q_WORKERS_TABLE≢⍬
             Q_WORKERS_TABLE⍪←QS∊eqs
         :Else
             Q_WORKERS_TABLE←(1(≢QS))⍴QS∊eqs
         :EndIf
     :EndIf
     status←'READY'




 :Case 'FINISHED' ⍝ record results and task
     (task_id timeStarted timeCompleted expr r) ← 5↑body
     RESULT_HISTORY,←⊂expr r
     TODO[task_id]←⊂(⊃TODO[task_id]),timeStarted timeCompleted
     status←'READY'

 :Case 'READY'
     debugMessage←'WORKER IS READY'

 :Case 'ERROR'
     status←'READY' ⍝ worker should be ready after an error occurs

 :Case 'DEBUG'
     qs←body
     ⎕←'DEBUG MESSAGE: '
     ⎕←debugMessage←qs
     ⎕←''
     ERROR_HISTORY,←⊂worker debugMessage
     ic.Respond ⎕←worker'Server is waiting for worker to finish debugging...'
 :EndSelect

 WORKERSTATUS[WORKERS⍳⊆worker]←getStatus status

 r←0

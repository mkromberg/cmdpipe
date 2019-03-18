 r←ProcessWorker args;statuses;getStatus;worker;qs;status;message;eqs
 ⍝ args are command and workerQNames
 statuses←'DEBUG' 'BUSY' 'READY'
 getStatus←{(statuses⍳⊆⍵)-2}

 ⍝ add a status message below to enable debugging
 ⍝ status should report either success or error details
 (worker message)←args
 (qs status)←message

:Select status
:Case 'ERROR'
    status←'READY'
:Case 'DEBUG'
    ic.Respond ⎕←worker 'Server is waiting for worker to finish debugging...'
:EndSelect

 AddNewQ qs
 eqs←⊆qs
 :If ~(⊆worker)∊WORKERS
     WORKERS,←⊆worker
     WORKERSTATUS,←0
     :If Q_WORKERS_TABLE≢⍬
         Q_WORKERS_TABLE⍪←QS∊eqs
     :Else
         Q_WORKERS_TABLE←(1(≢QS))⍴QS∊eqs
     :EndIf
 :EndIf

⍝ update the correct worker status
⍝ this is placed outside and after affixing a new worker
⍝ because this function is run any time a worker event is fired
⍝ thererfore it needs to update the correct worker, not simply append the value
WORKERSTATUS[WORKERS⍳⊆worker]←getStatus status



 r←0

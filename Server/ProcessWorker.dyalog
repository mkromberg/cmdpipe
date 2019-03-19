 r←ProcessWorker args;statuses;getStatus;worker;qs;status;message;eqs
 ⍝ args are command and workerQNames
 statuses←'DEBUG' 'BUSY' 'READY'
 getStatus←{(statuses⍳⊆⍵)-2}

 ⍝ add a status message below to enable debugging
 ⍝ status should report either success or error details
 (worker message) ← args    ⍝ for more information about this data structure
 (qs status)      ← message ⍝ see ../client/Main.dyalog

:Select status
:Case 'ERROR'
    status←'READY' ⍝ worker should be ready after an error occurs
:Case 'DEBUG'
    ic.Respond ⎕←worker 'Server is waiting for worker to finish debugging...'
:EndSelect


 AddNewQ (~∨⌿{⍪(⍵≡'') (⍵≡⍬)} qs)/qs
 eqs←⎕←(⊂'DEFAULT'),⊆qs
 :If ~(⊆worker)∊WORKERS
     WORKERS,←⊆worker
     WORKERSTATUS,←0
     :If Q_WORKERS_TABLE≢⍬
         Q_WORKERS_TABLE⍪←QS∊eqs
     :Else
         Q_WORKERS_TABLE←(1(≢QS))⍴QS∊eqs
     :EndIf
 :EndIf

WORKERSTATUS[WORKERS⍳⊆worker]←getStatus status ⍝ this must occur after all of the above 
                                               ⍝ so that the correct index worker status is updated
r←0

 r←ProcessWorker args;statuses;getStatus;worker;qs;status;message;eqs
 ⍝ args are command and workerQNames
 statuses←'ERROR' 'BUSY' 'READY'
 getStatus←{(statuses⍳⊆⍵)-2}

 ⍝ add a status message below to enable debugging
 ⍝ status should report either success or error details
 (worker message)←args
 (qs status)←message
 ⎕←'WORKER ' status ' MESSAGE: ' worker ' '
⍝ eqs←⊆qs
⍝ QS    ,←new←⊆(~eqs∊QS)/eqs
 AddNewQ qs
 eqs←⊆qs
 :If ~(⊆worker)∊WORKERS
     WORKERS,←⊆worker
     WORKERSTATUS,←0
     :If Q_WORKERS_TABLE≢⍬
         Q_WORKERS_TABLE⍪←QS∊eqs
     :Else
         Q_WORKERS_TABLE←(1(≢QS))⍴eqs∊QS
     :EndIf
 :EndIf

 ⎕←'WORKER STATUS'
 ⎕←WORKERSTATUS[WORKERS⍳⊆worker]←getStatus status


 r←0

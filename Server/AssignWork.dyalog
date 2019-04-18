 r←AssignWork dummy;n;readyWorkers;getTodoIndices;getWorkerLocations;workerLocations;todoIndices;workersToAssign;uniqueIndices;todos;workers;unprocessed
 r←0


 ⍝ PROCESSED represents which tasks yet to be processed
 ⍝ Therefore this branch holds true only when there are workers able to
 ⍝ process an unprocessed task
 :If 0≠⌊/≢¨(⍳+/~PROCESSED) WORKERS


     ⍝ Written by Adam. Uses statystical analysis to determine which Q to process in which order
     ⍝ First find the Q to Process
     ⍝ Finging found the Q, find the worker who can process the Q
     ⍝ Assign the worker and 0 out the worker status/unprocessed
     ⍝ Repeat until there are no more tasks read to be process, or there are no more workers ready
     freq      ←{(⊢÷+/){¯1+≢⍵} ⌸ (⍳≢QS),⍵}
     findWorker←{⊃⍒ QvsWORKERS[;⍵] ÷ +/QvsWORKERS(×⍤1 1)freq ⍺}
     getQ      ←{⊃⍒(freq ⍵)÷freq 2⊃¨⍸(1=WORKERSTATUS)×⍤0 1⊢QvsWORKERS}

     ⍝selectedWorker← findWorker∘getQ⍨ unprocessed  (⍳⍤1) 1
     ...

    ⍝ set the entire row to zero in QvsWORKERS if worker is not ready
    unprocessed    ← (~PROCESSED) ⌿QvsTASKS
    ids            ← (~PROCESSED)/TASK_ID
    todo           ← (~PROCESSED)/TASKS
    readyWorkers   ← ↑ (1=WORKERSTATUS) ×↓unprocessed
    getTodoIndices ← {⍸ 0< +/ ¨⍵}
    getWorkerLocations←{{+/⍵ (∧⍤1) readyWorkers}¨↓⍵}

    selectedWorkers←∪(⍉QvsWORKERS[;unprocessed(⍳⍤1)1]) (⍳⍤1) 1

    ⍝ presently in the Q
    :If 0< ≢workersToAssign

       ⍝ only act on unique workers and only process a single case of todo for a given worker
       uniqueIndices ← workersToAssign ⍳ ∪workersToAssign
       todos         ← todoIndices    [uniqueIndices]
       workers       ← workersToAssign[uniqueIndices]

       {ic.Respond WORKERS[workers[⍵]] ((⊃todo[todos[⍵]]), ids[todos[⍵]])}¨⍳≢workers

       PROCESSED[(⍸~PROCESSED)[todos]]←1

       ⍝ set the status to 0→'BUSY' for all workers that have been assigned work
       WORKERSTATUS×←~(⍳≢WORKERS)=workers
    :EndIf
 :EndIf

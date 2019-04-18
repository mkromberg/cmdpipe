 r←AssignWork dummy;n;readyWorkers;getTodoIndices;getWorkerLocations;workerLocations;todoIndices;workersToAssign;uniqueIndices;todos;workers;unprocessed
 r←0


 ⍝ PROCESSED represents which tasks yet to be processed
 ⍝ Therefore this branch holds true only when there are workers able to
 ⍝ process an unprocessed task
 :If 0≠⌊/≢¨(⍳+/~PROCESSED) WORKERS
    ⍝ set the entire row to zero in Q_WORKERS_TABLE if worker is not ready
    unprocessed    ← (~PROCESSED) ⌿Q_TODO_TABLE
    ids            ← (~PROCESSED)/TASK_ID
    todo           ← (~PROCESSED)/TODO
    readyWorkers   ← ↑ (1=WORKERSTATUS) ×↓unprocessed
    getTodoIndices ← {⍸ 0< +/ ¨⍵}
    getWorkerLocations←{{+/⍵ (∧⍤1) readyWorkers}¨↓⍵}
   
    ⍝ If there are both at least one work and one TODO item
    ⍝ then cross reference the Q required by the TODO item
    ⍝ with the WORKERS in that Q
    workerLocations ← getWorkerLocations unprocessed  ⍝ maps the TODO Qs to location of workers ready to process this Q
    todoIndices     ← getTodoIndices workerLocations  ⍝ indices of the todo which can be processed right now
    workersToAssign ← workerLocations[todoIndices]⍳¨1 ⍝ indices of the workers who are ready to process a current task

    ⍝ If there are any workers available to work on the tasks
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

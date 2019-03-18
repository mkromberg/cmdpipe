 r←AssignWork dummy;n;readyWorkers;getTodoIndices;getWorkerLocations;workerLocations;todoIndices;workersToAssign;uniqueIndices;todos;workers
 r←0

 readyWorkers       ← ↑(1=WORKERSTATUS) × ↓Q_WORKERS_TABLE
 getTodoIndices     ← {⍸ 0< +/ ¨⍵}
 getWorkerLocations ← {{ +/⍵ (∧⍤1) readyWorkers}¨ ↓⍵ }

 :If 0≠ ⌊/ ≢¨TODO WORKERS
     workerLocations ← getWorkerLocations Q_TODO_TABLE  ⍝ maps the todo queues to location of workers ready to process this queue
     todoIndices     ← getTodoIndices workerLocations   ⍝ gets the indices of the todo which can be processed right now
     workersToAssign ← workerLocations[todoIndices]⍳¨1  ⍝ gets the indices of the workers who are ready to process a current task

     ⍝ if there are any workers available to work on the tasks
     ⍝ presently in the queue
     :If 0< ≢workersToAssign
        ⍝ only act on unique workers and only process a single case of todo for a given worker
         uniqueIndices ← workersToAssign ⍳ ∪workersToAssign
         todos         ← todoIndices    [uniqueIndices]
         workers       ← workersToAssign[uniqueIndices]
         {ic.Respond WORKERS[⍺], TODO[⍵]} ⌿ ↑workers todos

        ⍝ drop todos that had avilable workers
         TODO←TODO[(⍳≢TODO)~todos]

        ⍝ drop the row in the Q over TODO table
         Q_TODO_TABLE←Q_TODO_TABLE[(⍳⊃⍴Q_TODO_TABLE)~todos;]

        ⍝ edge case when there are no items in the todo, prevents a 0 by n matrix
         :If 0=⊃⍴Q_TODO_TABLE
             Q_TODO_TABLE←⍬
         :EndIf

        ⍝ set the status to 0→'BUSY' for all workers that have been assigned work
         WORKERSTATUS×←~(⍳≢WORKERS)=workers
     :EndIf
 :EndIf

⍝ for each worker send them some work
⍝ :If n≠0
⍝     (ic.Respond⍤1) (n↑WORKERS),⍪n↑TODO
⍝     (WORKERS TODO)←n↓¨WORKERS TODO
⍝ :EndIf

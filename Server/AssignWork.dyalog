 r←AssignWork dummy;n;readyWorkers;getTodoIndices;getWorkerLocations;workerLocations;todoIndices;workersToAssign;uniqueIndices;todos;workers;unprocessed
 r←0

⍝ set the entire row to zero in Q_WORKERS_TABLE if worker is not ready
 unprocessed   ← (~PROCESSED) ⌿Q_TODO_TABLE
 readyWorkers  ← ↑ (1=WORKERSTATUS) ×↓unprocessed
 getTodoIndices← {⍸ 0< +/ ¨⍵}
 getWorkerLocations←{{+/⍵ (∧⍤1) readyWorkers}¨↓⍵}

 :If 0≠⌊/≢¨TODO WORKERS
   ⍝ If there are both at least one work and one TODO item
   ⍝ then cross reference the Q required by the TODO item
   ⍝ with the WORKERS in that Q
   workerLocations←getWorkerLocations unprocessed  ⍝ maps the TODO Qs to location of workers ready to process this Q
   todoIndices←getTodoIndices workerLocations       ⍝ indices of the todo which can be processed right now
   workersToAssign←workerLocations[todoIndices]⍳¨1  ⍝ indices of the workers who are ready to process a current task

   ⍝ If there are any workers available to work on the tasks
   ⍝ presently in the Q
   :If 0<≢workersToAssign

     ⍝ only act on unique workers and only process a single case of todo for a given worker
     uniqueIndices←workersToAssign⍳∪workersToAssign
     todos←todoIndices[uniqueIndices]
     workers←workersToAssign[uniqueIndices]


     ⍝{⍵/words}⍤1⊃×/(⊂a[wts[uis];]),⊂b[tis[uis];]
     ⍝{ic.Respond WORKERS[⍺], TODO[⍵]} ⌿ ↑workers todos
     ⎕←'WHAT THE FUCK IS THIS SHIT RIGHT HERE'
     {ic.Respond WORKERS[workers[⍵]] (TODO[todos[⍵]], TASK_ID[todos[⍵]])}¨⍳≢workers


     ⍝ drop todos that had avilable workers
⍝     TODO←TODO[(⍳≢TODO)~todos]
     PROCESSED[todos[⍳≢workers]]←1

     ⍝ drop the row in the Q over TODO table
⍝     Q_TODO_TABLE←Q_TODO_TABLE[(⍳⊃⍴Q_TODO_TABLE)~todos;]

     ⍝ edge case when there are no items in the todo, prevents a 0 by n matrix
     :If 0=⊃⍴Q_TODO_TABLE
       Q_TODO_TABLE←⍬
     :EndIf

     ⍝ set the status to 0→'BUSY' for all workers that have been assigned work
     WORKERSTATUS×←~(⍳≢WORKERS)=workers
   :EndIf
 :EndIf

 r←AssignWork dummy;n
 r←0

 MapWorkerAndTask←{
     (Q m)←⊃TODO[⍵]
     indices←,⍺(⍳⍤1)⊂Q
     iir←indices≤≢¨↓⍺
     index←iir⍳1
     index ⍵
 }

 n←(≢TODO)⌊≢WORKERS
 :If n≠0
⍝ TODO: (nathan) ADD SOME SORT OF HANDLING OF TODOS WHO SUBMIT WORK FOR QUEUES THAT CONTAIN NO WORKERS
⍝ TODO: (nathan) PRESENTLY, IF THERE IS A WORKER, AND A NEW TASK CONTAINS A NEW QUEUE, THE SERVER CRASHES
⍝ TODO: (nathan) TODO SHOULD SIMPLY BE IDLE UNTIL A WORKER APPEARS TO PROCESS THAT KIND OF QUEUE

     workerTable←↑WORKERS      ⍝ the table of all workers, column 1 is the Conga Client Object
     workerQs←↑workerTable[;2] ⍝ the table of queus, where each row relates to 1 worker

     ⎕←'WORKERS:'
     ⎕←↑WORKERS
     
     ⎕←'TODO:'
     ⎕←↑TODO

     workerTaskPairs ← ⊆ workerQs∘MapWorkerAndTask¨ ,⍳⍴ TODO   ⍝ the result is a list of 2 vectors, workerIndex taskIndex
     workerIndices   ← 1 ⌷[2]  ↑ workerTaskPairs               ⍝ this is used below to assign WORKERS[workerIndex] the task of TODO[taskIndex]
     firstOfUnique   ← workerIndices ⍳ (unique←∪workerIndices) ⍝ but first we get the index of the unique workers in the wtTable above


     ⍝ taking only the first of each unique worker from the worker task pairs, we divvy up the paired tasks
     assignTaskToWorker←{ 
         (workerIndex taskIndex)←⍵
         (Q message)←⊃TODO[taskIndex]
         ic.Respond (⎕←⊃workerTable[workerIndex;]) message
     }

     assignTaskToWorker¨(workerTaskPairs)[firstOfUnique]

     withoutUnique ← (⍳⍴WORKERS)~unique
     WORKERS       ← WORKERS[withoutUnique]

     todoIndices   ← 2 ⌷[2] (↑ workerTaskPairs)[firstOfUnique;]  ⍝ todo indices, used to filter out the processed tasks
     TODO          ← TODO[(⍳⍴TODO)~todoIndices]

     r←'TASKS ASSIGNED TO WORKERS: ',⍕n

 :EndIf

⍝ for each worker send them some work
⍝ :If n≠0
⍝     (ic.Respond⍤1) (n↑WORKERS),⍪n↑TODO
⍝     (WORKERS TODO)←n↓¨WORKERS TODO
⍝ :EndIf

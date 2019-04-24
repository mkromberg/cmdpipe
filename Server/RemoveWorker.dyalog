 r←RemoveWorker command
 ⎕←'REMOVING 'command' FROM THE WORKER Q.'
 ⎕←''
 keep←~((≢command)↑¨WORKERS)∊⊂command

 ⍝ terminate the remote process
 ((~keep)/WORKERINSTANCES).Kill
 WORKERINSTANCES←keep/WORKERINSTANCES
 WORKERPORTNUMS ←keep/WORKERPORTNUMS
 WORKERS_TIME   ←keep/WORKERS_TIME
 WORKERSTATUS   ←keep/WORKERSTATUS
 QvsWORKERS     ←keep⌿QvsWORKERS
 WORKERS        ←keep/WORKERS

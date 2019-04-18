 r←RemoveWorker command
 ⎕←'REMOVING 'command' FROM THE WORKER Q.'
 ⎕←''
 keep←~((≢command)↑¨WORKERS)∊⊂command

 WORKERS     ←keep/WORKERS
 WORKERSTATUS←keep/WORKERSTATUS
 QvsWORKERS  ←keep⌿QvsWORKERS
 WORKERS_TIME←keep/WORKERS_TIME

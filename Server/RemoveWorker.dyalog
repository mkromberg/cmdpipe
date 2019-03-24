 r←RemoveWorker command
 ⎕←'REMOVING 'command' FROM THE WORKER Q.'
 ⎕←''
 keep←~((≢command)↑¨WORKERS)∊⊂command

 WORKERS←keep/WORKERS
 WORKERSTATUS←keep/WORKERSTATUS
 Q_WORKERS_TABLE←keep⌿Q_WORKERS_TABLE

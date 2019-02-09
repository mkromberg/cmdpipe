 r←processWorker command
 ⎕←'WORKER READY MESSAGE: 'command
 WORKERS←WORKERS,⊂command
 ⎕←WORKERS
 r←0

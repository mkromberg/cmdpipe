 r←ProcessWorker args
 ⍝ args are command and workerQNames
 ⎕←'WORKER READY MESSAGE: 'command
 WORKERS←WORKERS,⊂args
 ⎕←WORKERS
 r←0

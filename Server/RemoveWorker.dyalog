r←RemoveWorker command
⎕←'REMOVING ' command ' FROM THE WORKER Q.'
⎕←'' 
index     ← WORKERS⍳⊆command
remaining ← (⍳≢WORKERS)~index

WORKERS         ← WORKERS[remaining]
WORKERSTATUS    ← WORKERSTATUS[remaining]
Q_WORKERS_TABLE ← Q_WORKERS_TABLE[remaining;]


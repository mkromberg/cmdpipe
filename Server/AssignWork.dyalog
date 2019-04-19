 r←AssignWork dummy;n;readyWorkers;getTodoIndices;getWorkerLocations;workerLocations;todoIndices;workersToAssign;uniqueIndices;todos;workers;unprocessed
 r←0

 ⍝ The functions freq, findWorker, getQ were written by Adam
 ⍝ Uses statystical analysis to determine which Q to process in which order
 ⍝ First: find the Q to Process
 ⍝ Next:  find the worker who can process the Q
 ⍝ Assign the worker and 0 out the worker status/unprocessed
 ⍝ Repeat until there are no more tasks read to be process, or there are no more workers ready
 ⍝ To see why this is necessary take the following case
 ⍝ each Worker can process column 1, but only one worker can process column 3
 ⍝     QvsWORKERS
 ⍝ 1 0 1
 ⍝ 1 1 0
 ⍝ 1 1 0
 ⍝ How will I distribute the following tasks among the above workers?
 ⍝ Naive, you might have the first 2 tasks submitted to the first 2 users, but worker 3 will sit idle
 ⍝     QvsTASKS
 ⍝ 1 0 0
 ⍝ 1 0 0
 ⍝ 0 0 1
 ⍝ If instead we assign first task 3 to worker 1, workers 2 and 3 can safely execute the remaining tasks

 freq      ←{(≢QS)↑(⊢÷+/) {¯1+≢⍵} ⌸ (⍳≢QS),⍵}  ⍝ just to be safe only take the count of qs ab
 findWorker←{⊃⍒ QvsWORKERS[;⍵] ÷+/QvsWORKERS (×⍤1 1) freq ⍺}
 getQ      ←{⊃⍒ (freq ⍵) ÷freq 2⊃¨⍸(1=WORKERSTATUS) (×⍤0 1) QvsWORKERS}

 ⍝ PROCESSED represents which tasks yet to be processed
 ⍝ Therefore this branch holds true only when there are workers able to
 ⍝ process an unprocessed task
 :If 0≠⌊/≢¨(⍳+/~PROCESSED) WORKERS
    ⍝ TODO: Turn the following into a loop 
    ⍝ Which processes each q in turn
    ⎕DIV←1 ⍝ safe division by zero for getQ function

    unprocessed ← (~PROCESSED) (∧⍤0 1) QvsTASKS
    u ← (temp≤≢QS)/temp←unprocessed  (⍳⍤1) 1

    ⍝ the below result will be 0 if there are no workers able to process the given task
    :If 0<+/×⌿QvsWORKERS⍪freq u
	q ← getQ u
	w ← u findWorker q
	t ← unprocessed[;q] ⍳1

	⍝ now find the first task related to Q
	⍝ there is no consideration, direct solution should work fine
	ic.Respond (⊃WORKERS[w]) ((⊃TASKS[t]), TASK_ID[t])
	PROCESSED[t]←1
    :EndIf

    ⎕DIV←0 ⍝ reset division by zero for the rest of the application

 :EndIf

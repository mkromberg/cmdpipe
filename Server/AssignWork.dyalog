 r←AssignWork dummy;u;q;w;t;unassigned;freq;findWorker;getQ;⎕DIV
 
 ⍝⍝⍝  The statistical functions freq, findWorker, getQ were written by Adam
 freq      ←{(≢QS)↑(⊢÷+/) {¯1+≢⍵} ⌸ (⍳≢QS),⍵}  ⍝ just to be safe only take the count of qs ab
 findWorker←{⊃⍒ QvsWORKERS[;⍵] ÷+/QvsWORKERS (×⍤1 1) freq ⍺}
 getQ      ←{⊃⍒ (freq ⍵) ÷freq 2⊃¨⍸(1=WORKERSTATUS) (×⍤0 1) QvsWORKERS}

 ⍝ branch holds true only when there are ready workers able to process an unassigned task
 :If 0≠⌊/≢¨(⍳+/~ASSIGNED) (⍳+/1=WORKERSTATUS)

    ⍝ TODO: Turn the following into a loop 
    ⍝ Which processes each q in turn
    ⎕DIV←1 ⍝ safe division by zero for getQ function

    ⍝ u q w t, unassigned, selected queue, worker, task
    unassigned ← (~ASSIGNED) (∧⍤0 1) QvsTASKS
    u ← (temp≤≢QS)/temp←unassigned  (⍳⍤1) 1

    ⍝ the below result will be 0 if there are no workers able to process the given task
    :If 0<+/+/QvsWORKERS(×⍤1 1)freq u
	q ← getQ u
	w ← u findWorker q
	t ← unassigned[;q] ⍳1

	ic.Respond (⊃WORKERS[w]) ('TASK' ((⊃TASKS[t]), TASK_ID[t]))

	ASSIGNED[t]←1
	TASKvsWORKER[t]←w

    :EndIf
 :EndIf
 r←0
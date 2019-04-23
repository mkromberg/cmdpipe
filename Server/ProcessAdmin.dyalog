 r←ProcessAdmin(command content ic);action;args;result
 action←⊃1↑content
 args←1↓content

 
 ⍝ TODO each commaand should check the forms of arguments
 :Select action
 :Case 'startworker'
     ⍝ args are split on space, (k=v) (k=v) (k=v)
     a← ∊{⍺' '⍵}/args

     ⍝ Check that all the required arguments are in args
     :If 0=≢args
	ic.Respond command ((action': incorrect arguments'),⊂a)

     :ElseIf ~4= +/'dir' 'ip' 'port' 'qs' ∊ {1⊃'='(≠⊆⊢)⍵}¨args
	ic.Respond command ((action': incorrect arguments'),⊂a)

     :Else
	⍝ standalone process
	WORKERINSTANCES,← ⎕NEW APLProcess ('s' a)
	ic.Respond command((action': '),'Worker workspace started. TODO, before responding, wait to get successful status back from the process')
	⎕←'starting worker'
     :EndIf


 :Case 'debugmode'
     ⍝ First 3 checks are to avoid errors
     ⍝ The first 2 checks can't be joined because the second depends on the first being false
     ⍝ So ∧ doesn't work because perhaps 1 is false, but not the other
     ⍝ ∨ doesn't work because a string cannot be evaluated if the string isn't valid code
     :If 0= +/ ∊args='01'
	ic.Respond command ((action': incorrect argument'),⊂DEBUG_MODE)

     ⍝ Save the evaluation of args to avoid reevaluation later
     :ElseIf 0= +/ (a←⍎⊃args)=0 1
	ic.Respond command ((action': incorrect argument'),⊂DEBUG_MODE)

     :ElseIf DEBUG_MODE=a
	ic.Respond command ((action': already set to '),⊂DEBUG_MODE)

     ⍝ Set debug mode, set debug mode on all workers, and reply to admin 
     :Else 
	DEBUG_MODE←a
	⎕←WORKERS
	{ic.Respond ⍵ ('DEBUG' a)}¨WORKERS
	ic.Respond command((action': '),⊂DEBUG_MODE)
	⎕←'DEBUG UPDATED: 'DEBUG_MODE
     :EndIf


 :Case 'workerinfo'
     result←('worker command name' 'status',QS)⍪(WORKERS,WORKERSTATUS,QvsWORKERS)
     ic.Respond command((action':'),result)

     ⎕←'WORKER INFO REQUESTED'

 :Case 'tasktime'
    ⍝ this :Case could potentially take arguments for specific statistics regarding tasks
    ⍝ only take completed tasks for now
    ⍝ time in Q is not accurate for tasks that are not processed
    ⍝ for tasks which are not yet processed get a current time stamp
    ⍝ same for timeToProcess
    (type conversion)←2↑args
    fmt←24 60 60 1000
    con←'h' 'm' 's' 'ms'

    ⍝ wrap in a box if not boxed
    :If 1<≢conversion
        conversion←⊆conversion
    :EndIf

    c←(con⍳conversion)↑fmt
    format←{c⊥(≢c)↑3↓⍵}

    fields← (1 2) (2 3) (1 3)
    types ← 'tts' 'ttc' 'ttp'
    f←fields⌷⍨types⍳⊆type
    
    padEmpty←↑{(1↓⍵),(4-≢⍵)⍴⊂⎕TS}¨TASKS

    result← |-/format¨ f⌷[2] padEmpty
    ic.Respond command((action':'),result)

    ⍝ further, the tasks should be associated with the worker assigned to the task if possible

 :Case 'results'
     ic.Respond command((action': ')(('TASK' 'RESULT')⍪↑RESULT_HISTORY))
     ⎕←'RESULTS REQUESTED'

 :Else
     ic.Respond command((action':')('Unrecognized command : "',action,'".'))
     ⎕←'Admin attempted to call: 'action

 :EndSelect

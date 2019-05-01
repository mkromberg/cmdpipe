 r←ProcessAdmin(command content ic);action;args;result
 action ←1⊃content

 
 unrecognized←{
     ic.Respond command((⍵':')('Unrecognized command : "',⍵,'".'))
     ⎕←'Admin attempted to call: '⍵
 }

 ⍝ TODO each commaand should check the forms of arguments
 :Select action
 :Case 'done'
     DONE←1
     ic.Respond command((action,': '), 'Server exiting...')

 :Case 'worker'
     subaction←2⊃content
     args     ←2↓content

     :Select subaction
     :Case 'status'
	ic.Respond command((action,' ',subaction,': ') (('Name' 'Status' 'Port')⍪⍉↑WORKERS WORKERSTATUS WORKERPORTNUMS))
     	  
     :Case 'start'
	⍝ args are split on space, (k=v) (k=v) (k=v)
	a← ∊{⍺' '⍵}/args

	⍝ Check that all the required arguments are in args
	:If 0=≢args
	    ic.Respond command ((action': incorrect arguments'),⊂a)

	:ElseIf ~4= +/'dir' 'ip' 'port' 'qs' ∊ {1⊃'='(≠⊆⊢)⍵}¨args
	    ic.Respond command ((action': incorrect arguments'),⊂a)

	:Else
	    ⍝ standalone process
	    :If 3600>NEWPORTNUM
		NEWPORTNUM+←1
	    :Else
		NEWPORTNUM←3501
	    :EndIf
	    ⍝ newportnum←⊃(3500 + ⍳1+≢assigned)~assigned

	    WORKERINSTANCES,← ⎕NEW APLProcess ('s' (a, ' RIDE_INIT=SERVE:*:',⍕NEWPORTNUM))
	    ic.Respond command((action': '),'Worker workspace started. TODO, before responding, wait to get successful status back from the process')
	    ⎕←'starting worker'
	:EndIf

    :Case 'setdebug'
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
	    {ic.Respond ⍵ ('DEBUGMODE' a)}¨WORKERS
	    ic.Respond command((action': '),⊂DEBUG_MODE)
	    ⎕←'DEBUG UPDATED: 'DEBUG_MODE
	:EndIf

    :Case 'info'
	result←('worker command name' 'status',QS)⍪(WORKERS,WORKERSTATUS,QvsWORKERS)
	ic.Respond command((action':') result)

	⎕←'WORKER INFO REQUESTED'
    :Else
        unrecognized ,/action ' ' subaction
    :EndSelect

 :Case 'task'
     subaction←2⊃content
     args     ←2↓content

     :Select subaction
     :Case 'info'
         ic.Respond command 'not implemented'

     :Case 'time'
 	 ⍝ this :Case could potentially take arguments for specific statistics regarding tasks
	 ⍝ only take completed tasks for now
	 ⍝ time in Q is not accurate for tasks that are not processed
	 ⍝ for tasks which are not yet processed get a current time stamp
	 ⍝ same for timeToProcess
	 (type conversion)←2↑args
	 con←'h' 'm' 's' 'ms'
 	 fields← (1 2) (2 3) (1 3)
 	 types ← 'tts' 'ttc' 'ttp'
	 fmt   ←24 60 60 1000
	 :If 1=≢conversion
	     conversion←⊃conversion
	 :EndIf

         ⍝ validation
	 notin←{(≢⍵)<⍵⍳⊆⍺}
	 :If (type notin types) ∨ conversion notin con
 	     ic.Respond command((action':'), 'invalid arguments')
	     →0
	 :EndIf
 
 	 c←(con⍳⊆conversion)↑fmt
 	 format←{c⊥(≢c)↑3↓⍵}
 	 f←fields⌷⍨types⍳⊆type

 	 padEmpty←↑{(1↓⍵),(4-≢⍵)⍴⊂⎕TS}¨TASKS
 	 result  ← |-/format¨ f⌷[2] padEmpty
 	 ic.Respond command((action':'),result)
     :Else
	unrecognized ,/action ' ' subaction
 
     :EndSelect

 :Case 'error'
     ic.Respond command((action': ')(('TASK' 'RESULT')⍪↑RESULT_HISTORY))
     ⎕←'RESULTS REQUESTED'

 :Else
     unrecognized action

 :EndSelect


⍝ configurable workspace
⍝ which will run any arbitrary file
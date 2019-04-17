 r←ProcessAdmin(command content ic);action;args;result
 action←⊃1↑content
 args←1↓content

⍝ TODO each commaand should check the forms of arguments

 :Select action
 :Case 'startworker'
  ⍝ standalone process
     ic.Respond command((action': '),'Worker start is not implemented')
     ⎕←'starting worker'


 :Case 'debugmode'
     DEBUG_MODE←args
     ic.Respond command((action': '),⊂DEBUG_MODE)
     ⎕←'DEBUG UPDATED: 'DEBUG_MODE

 :Case 'workerinfo'
     result←('worker command name' 'status',QS)⍪(WORKERS,WORKERSTATUS,Q_WORKERS_TABLE)
     ic.Respond command((action':\n'),result)

     ⎕←'WORKER INFO REQUESTED'

 :Case 'results'
     ic.Respond command((action': \n')(('TASK' 'RESULT')⍪↑RESULT_HISTORY))
     ⎕←'RESULTS REQUESTED'

 :Else
     ic.Respond command((action':')('Unrecognized command : "',action,'".'))
     ⎕←'Admin attempted to call: 'action

 :EndSelect

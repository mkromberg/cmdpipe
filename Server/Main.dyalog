 r←Main(ic server);code;command;event;body;type;content;DONE;TODO;WORKERS;WORKERSTATUS;QvsWORKERS;QvsTASKS;QS;WORKERS_TIME;DEBUG_MODE;RESULT_HISTORY;ERROR_HISTORY;DEFAULT;PROCESSED;TASK_ID;ASSIGNED

 ⍝ Requred for starting a worker process in ProcessAdmin
 ⎕SE.UCMD 'Load APLProcess'


 DEBUG_MODE ← 1
 DONE r     ← 0
 ⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
 ⍝        WORKERS     ⍝
 ⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
 
 NEWPORTNUM←3501
 WORKERPORTNUMS←⍬
 ⍝ WORKERS is a nested character vector of "command names"
 ⍝ which are used to respond using Conga
 WORKERS ← ⍬

 ⍝ Keep track of workers so the connection stays open
 WORKERINSTANCES ← ⍬

 ⍝ WORKERS_TIME is a list of ⎕TS tracking the time a given
 ⍝ WORKER first reported as being ready 
 WORKERS_TIME ← ⍬

 ⍝ WORKERSTATUS functions as a boolean vector, but in reality is
 ⍝ 3 value vector ranging from ¯1 and 1, where 1 is ready, 0 is busy, and ¯1 is error
 WORKERSTATUS ← ⍬

 ⍝ a boolean matrix where each row is a worker and each column is a Q
 ⍝ keeps track of which worker can process which Q
 QvsWORKERS ← ⍬

 ⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
 ⍝        TASKS       ⍝
 ⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
 
 ⍝ TASKS Data type is a dynamic data type
 ⍝ Nested vector containing the columns noted in the columns variable
 columns←'Task' 'Time Submitted' 'Time Started' 'Time Completed'
 TASKS ← ⍬

 ⍝ QvsTASKS is a boolean matrix which notes to which q a task belongs
 ⍝ with 3 qs in memory, a task assigned to the second q would have a record such as:
 ⍝ 0 1 0 
 QvsTASKS ← ⍬ 

 ⍝ the TASK_ID is basically an index of the task itself
 ⍝ this is passed to the worker so the server knows which task to update upon completion
 TASK_ID ← ⍬

 ⍝ a boolean vector denoting whether a task has been assign to a worker
 PROCESSED ← ⍬

 ⍝ ASSIGNED notes whether a worker has been assigned to process a task
 ASSIGNED  ← ⍬

 ⍝ Notes the index of the worker worker that was assigned to accomplish a task
 ⍝ index of a worker, stored in order by task
 TASKvsWORKER ← ⍬


 RESULT_HISTORY ← ⍬
 ERROR_HISTORY  ← ⍬

 ⍝ QS is a nested character vector tracking all QS
 ⍝ If no Q is assigned to a worker or task, the default Q is assigned
 QS←DEFAULT←⊂'DEFAULT'

 ⍝ a gui function displaying the current state
 PrintState←{
     ⎕←'Worker table:'
     ⎕←('WORKER COMMAND NAME' 'READY TIME' 'STATUS',QS)⍪(WORKERS,WORKERS_TIME,WORKERSTATUS,QvsWORKERS)
     ⎕←''

     n←⊃⌽⍴↑TASKS
     ⎕←'TASKS TABLE:'
     ⎕←(('ID' 'ASSIGNED' 'PROCESSED' 'ASSIGNED TO',QS)⍪(TASK_ID,ASSIGNED,PROCESSED,TASKvsWORKER,QvsTASKS)),(n↑columns)⍪↑TASKS
     ⎕←''

     ⎕←'ERROR HISTORY:'
     ⎕←↑ERROR_HISTORY
     ⎕←''

     ⎕←'RESULTS: '
     ⎕←('TASK' 'RESULT')⍪↑RESULT_HISTORY
     ⎕←''
 }


 ic.SetProp '.' 'EventMode' 1
 :While ~DONE
     AssignWork 0
     PrintState 0
     (code command event body)←4↑ic.Wait server 10000
     (type content)←body

     :If ~code=0
         ⎕←'Unexpected server failure'
         DONE←1
         :Continue
     :EndIf

     :Select event
     :Case 'Receive'
         :Select type
	 :Case 'FIFO'
             ProcessFifo command content ic

         :Case 'WORKER'
             ProcessWorker command content

         :Case 'ADMIN'
             ProcessAdmin command content ic
         :EndSelect

     :Case 'Connect'
        ⍝ TODO: Handle connect?

     :Case 'Closed'
         ⎕←command' disconnected from server. '
         RemoveWorker command

     :Case 'TIMEOUT'
         ⍝ TODO: Do something with the timeout message?
     :EndSelect
 :EndWhile

 :If 0<≢WORKERINSTANCES
     ⍝ cleanup running workers
     WORKERINSTANCES.Kill
 :EndIf

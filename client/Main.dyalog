 r←Main(ic client QNames);DONE;code;command;event;task;commandName

 DONE←0
 ic.SetProp'.' 'EventMode' 1
 commandName←client,'.WorkerReady'

⍝ the WORKER is ready to accept work
 ##.Utils.Check ic.Send commandName ('WORKER' (QNames 'READY'))

 :While ~DONE
    (code command event task)←ic.Wait commandName 10000
    :If code≠0
         DONE←1
         ⎕←'Unexpected Worker Error.'
        :Continue
    :EndIf

    :Select event
    :Case 'Close'
         DONE←1
         ⎕←'Server closed the connection.'
    :Case 'Receive'
        ⍝ TODO: PROCESS TASK
        ⎕←'Processing: ' task 

        success ← ~∨/ 'ERROR' ⍷ task

        :If ∨/'DEBUG' ⍷ task
            ⍝ for testing if message contains error then throw error
            ⍝ message contains: debug
            ⍝ send message debug -> crash
            ⍝ when the process resumes, send error or ready depending on result
            ⎕←'DEBUGGING NOW!' 
            ⎕←'When finished debugging:'
            ⎕←'1. Set success to 1 or 0'
            ⎕←'2. and → RESUME'
            ⎕←'3. Profit'
            success←0
            ##.Utils.Check ic.Send commandName ('WORKER' (('Error proccessing: ' task) 'DEBUG'))
            ⎕←ic.Wait command 10000
            ...
        :EndIf
        RESUME:
        ⍝ else return 'READY'
        status  ← (success+1) ⊃ 'ERROR' 'READY'
        ##.Utils.Check ic.Send commandName ('WORKER' (QNames status))
    :Case 'Timeout'
        ⎕←'Max time waited'
    :EndSelect    
 :EndWhile
 r←0

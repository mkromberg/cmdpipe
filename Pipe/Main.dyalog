 r←main(ic client);DONE;code;command;event;task;commandName
 ⍝ comment
 DONE←0
 ic.SetProp'.' 'EventMode' 1
 commandName←client,'.FIFO'

:While ~DONE
  message←Read 10 ⍝ waits for a message to exist before continuing
  ##.Utils.Check ic.Send commandName ('FIFO' message)

  :Repeat (code command event successMessage)←ic.Wait commandName 10000
    :If code≠0
      DONE←1
      ⎕←'Log This Error'
      :Continue
    :EndIf

    :Select event
    :Case 'Close'
        DONE←1
        ⎕←'Server closed the connection'
    :Case 'Receive'
      OK←successMessage≡'SUCCESS'
    :Case 'Timeout'
      ⎕←'Max time waited'
    :EndSelect    

  :Until OK ∨ DONE
:EndWhile
 r←0

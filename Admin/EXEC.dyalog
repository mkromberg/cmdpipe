r←EXEC ic

DONE←0
 :While ~DONE
  ⍝ Read input from the user
  ⍞←'admin> '
  input←' '(≠⊆⊢)⍞

  ⍝ drop the admin> prompt from input. 
  :If 'admin>'≡⊃1↑input
    input← 1↓input
  :EndIf

  ⍝ Stop accepting new commands, close the admin session
  :If (⊃input) ≡ 'exit'
      DONE←1
  :EndIf

  :If DONE ∨ 0=≢input
      :Continue
  :EndIf

  ⍝ Send the input to the server and await the servers response
  ##.Utils.Check ic.Send COMMANDNAME ('ADMIN' input)
  (code command event result)←ic.Wait COMMANDNAME 10000

  ⍝ Handle server events
  :If code≠0
      DONE←1
      ⎕←'Unexpected Error.'
      :Continue
  :EndIf

  :Select event
  :Case 'Close'
      DONE←1
      ⎕←'Server closed the connection.'
  :Case 'Receive'
    ⎕←result

  :Case 'Timeout'
      ⎕←'Max time waited'
  :EndSelect
:EndWhile
r←0



 Make name

 :If ⎕NEXISTS name
     (name,' already exists')⎕SIGNAL 22
 :Else
     ⎕SH'mkfifo ',name
     :If ~⎕NEXISTS name
         ('"mkfifo ',name,'" failed')⎕SIGNAL 11
     :EndIf
 :EndIf

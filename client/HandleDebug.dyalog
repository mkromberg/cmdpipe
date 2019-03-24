HandleDebug

⎕←'Sending DEBUG message to server...'
##.Utils.Check ic.Send commandName ('WORKER' (('Error proccessing: ' task) 'DEBUG'))
⎕←ic.Wait command 10000
⎕←↑⎕DM
⎕←'Entering debug mode...'
⎕←'⎕SIGNAL 777 to abandon debug and report an error'
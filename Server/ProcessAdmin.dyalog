r←ProcessAdmin command content
:Select content
:Case 'STARTWORKER'
⎕←'starting worker'
  
:Case 'SETDEBUG
⎕←'debug mode set to something'

:Case 'INFO'
⎕←'Returning server information to the admin'

:Else
⎕←'Admin command not found, please speak to your local system administrator'
⎕←content
  
:EndSelect
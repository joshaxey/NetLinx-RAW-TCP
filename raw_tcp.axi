data_event [RAW_TCP_SERVER]
{
    
    online:
    {
        nInitialiseTelnet = true
    }
    
    offline:
    {
        nInitialiseTelnet = false
    }
    
    
    string:
    {
        stack_var integer nVal
        stack_var char cIAC
        stack_var char cAction
        stack_var char cOption
        stack_var char cWill
        stack_var char cWont
        stack_var char cDo
        stack_var char cDont
        stack_var char cOptEcho
        stack_var char cOptSupressEcho
        stack_var integer nRxCharSearch[10]
        stack_var integer nRxFirstChar
        stack_var integer nRxCharLoop
    
        cIAC  = $FF
        cWill = $FB
        cWont = $FC
        cDo   = $FD
        cDont = $FE
        cOptEcho = $01
        cOptSupressEcho = $2D
    
        if(nInitialiseTelnet)
        {
            while(left_string(data.text,1) == "cIAC")
            {
                GET_BUFFER_CHAR(data.text)
                cAction = GET_BUFFER_CHAR(data.text)
                cOption = GET_BUFFER_CHAR(data.text)
                select
                {
                    active(cAction == cDo):
                    {
                        send_string RAW_TCP_SERVER,"cIAC,cWont,cOption,cIAC,cWont,cOption,cIAC,cWont,cOption,cIAC,cWont,cOption"
                    }
                        
                    active(cAction == cWill):
                    {
                        send_string RAW_TCP_SERVER,"cIAC,cDont,cOption,cIAC,cDont,cOption,cIAC,cDont,cOption,cIAC,cDont,cOption"
                    }
                
                    cancel_wait 'Wait For Handshake'
                    wait 10 'Wait For Handshake'
                    {
                        nInitialiseTelnet=false
                    }
            }
}
PROGRAM_NAME ='RAW TCP Negotiation'

/*
RAW TCP NEGOTIATION EXAMPLE FOR DEBUG REFERENCE:
================================================

Source   IAC     Comm    Opt     Notes
======   ===     ====    ===     =====
Server   0xFF    0xFD    0x18    Do Terminal Type
Client   0xFF    0xFC    0x18    Won't Terminal Type
Server   0xFF    0xFD    0x20    Do Terminal Speed
Client   0xFF    0xFC    0x20    Won't Terminal Speed
Server   0xFF    0xFD    0x23    Display Location
Client   0xFF    0xFC    0x23    Won’t X Display Location
Server   0xFF    0xFD    0x27    Do New Environment Option
Client   0xFF    0xFC    0x27    Won't New Environment Option
Server   0xFF    0xFD    0x24    Do Environment Option
Client   0xFF    0xFC    0x24    Won't Environment Option
Server   0xFF    0xFB    0x03    Will Suppress Go Ahead
Client   0xFF    0xFE    0x03    Don’t Suppress Go Ahead
Server   0xFF    0xFD    0x01    Do Echo
Client   0xFF    0xFC    0x01    Won’t Echo
Server   0xFF    0xFD    0x22    Do Linemode
Client   0xFF    0xFC    0x22    Won’t Linemode
Server   0xFF    0xFD    0x1F    Do Negotiate About Window Size
Client   0xFF    0xFC    0x1F    Won't Negotiate About Window Size
Server   0xFF    0xFB    0x05    Will Status
Client   0xFF    0xFE    0x05    Don't Status
Server   0xFF    0xFD    0x21    Do Remote Flow Control
Client   0xFF    0xFC    0x21    Won't Remote Flow Control
Server   0xFF    0xFB    0x01    Will Echo
Client   0xFF    0xFE    0x01    Don’t Echo
Server   0xFF    0xFD    0x06    Do Timing Mark
Client   0xFF    0xFC    0x06    Won't Timing Mark
Server   0xFF    0xFD    0x00    Do Binary Transmission
Client   0xFF    0xFC    0x00    Won't Binary Transmission
Server   0xFF    0xFB    0x03    Will Suppress Go Ahead
Client   0xFF    0xFE    0x03    Don’t Suppress Go Ahead
Server   0xFF    0xFB    0x01    Will Echo
Client   0xFF    0xFE    0x01    Don’t Echo
Server   0xFF    0xFD    0x0A    LF End of Line
Server                           0x0D 0x0A Welcome to the Text Protocol Server 0x0D 0x0A
*/

define_device

RAW_TCP_SERVER = 0:9:0


define_variable

volatile integer nInitialiseTelnet


define_event

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
        // Negotiation Characters.
        stack_var char cIAC
        stack_var char cCommand
        stack_var char cOption
        stack_var char cWill
        stack_var char cWont
        stack_var char cDo
        stack_var char cDont

        cIAC  = $FF
        cWill = $FB
        cWont = $FC
        cDo   = $FD
        cDont = $FE

        if(nInitialiseTelnet)
        {
            // Fog: We're sending somebody in to negotiate!
            // Parse the data for the IAC character (the start of our negotiation).
            while(left_string(data.text,1) == "cIAC")
            {
                GET_BUFFER_CHAR(data.text)
                cCommand = GET_BUFFER_CHAR(data.text)
                cOption = GET_BUFFER_CHAR(data.text)
                
                select
                {
                    // Pew pew!
                    // Reply to the commands as appropriate.
                    active(cCommand == cDo):
                    {
                        send_string RAW_TCP_SERVER,"cIAC,cWont,cOption"                      
                    }

                    active(cCommand == cWill):
                    {
                        send_string RAW_TCP_SERVER,"cIAC,cDont,cOption"
                    }
                                   
                    cancel_wait 'Wait For Handshake'
                    wait 10 'Wait For Handshake'
                    {
                        nInitialiseTelnet=false
                        // Korben Dallas: Anybody else want to negotiate?
                    }
            }
}
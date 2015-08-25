# NetLinx RAW TCP
Self contained function for RAW TCP commands in NetLinx (TESIRA, Cisco, etc.).
<br>
Use this to start your initial negotiation with the device and get to the text server for user/pass entry.
<br>
It achieves this by parsing the buffer and looking for an IAC (Interpret As Command) character that is three bytes long (always 0xFF) and forms the reply string with this.
It then looks for the next character (Command) (always 0xFD (Do) or 0xFB (Will)) and forms the reply string with the appropriate reponse type (always 0xFC (Won't) 0xFE (Don't)).
It then looks for the next character (Option) (e.g. 0x18 (Terminal Type)) and forms the reply string with this option.
<br>
It will continue this exchange until the server is done with it's commands and enters a text server.
<br>
<br>
Included in the top is an example negotiation from the Tesira docs to help you debug if your code is having problems (or to understand what is actually happening).
For more complex usages, you can extend the ability to reply constructively by referencing the [IANA Telnet Options](http://www.iana.org/assignments/telnet-options/telnet-options.xhtml).
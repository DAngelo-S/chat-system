# Chat System (client and server) in Bash

This is a project for MAC0216 - Técnicas de Programação I, (Programming Tecniques I in English) discipline, from Instituto de Matemática e Estatística da USP, or Institute of Mathematics and Statistic, in English. 

The goal of this project is to implement a chat system, with client and server, in bash, that allows local communication between different users logged in the same computer.

Every code must be written in Bash script and be executed in GNU/Linux.

The video https://youtu.be/UHBBcxs2Zd4 shows how must be the system behave.

The system should be implemented in a unique file .sh, called `mac0216-chat.sh`.

To run the server it is necessary to invoke it in the shell as follows:  
`./mac0216-chat.sh servidor`

To run the client it is necessary to invoke it in the shell as follows:  
`./mac0216-chat.sh cliente`

Each user that wants to use the chat system, must invoke the script using the client mode, as described above.

Do not forgot to give permission to the script to execute through the command:  
`chmod +x`

## Server activities

The server must be initialized before any user and, once it was initialized, the server prompt will appear.

The server support the following commands:
* `list`: list the names of all users logged in, one per line.
* `time`: inform the time, in seconds, that the server is on.
* `reset`: remove all of the users that were created in this instance of the server execution.
* `quit`: quit the server.

## Client activities

Once it was initialized, the client prompt will appear.

The client support the following commands:
* `create <useer> <password>`: create a new user, if the user does not exist.
* `passwd <user> <current password> <new password>`: modify the users password.
* `login <user> <password>`: login the user.
* `quit`: quit the client prompt.
* `list`: list the names of all users logged in, one per line, if the user is logged.
* `logout`: logout the user, if the user is logged.

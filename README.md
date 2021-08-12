# Useful scripts

## Docker

dps: docker ps condensed  
 
Installation:  
`echo "docker ps -a \$@ | python ~/go/src/github.com/bhmj/scripts/dps.py" > /usr/local/bin/dps`  
`chmod u+x /usr/local/bin/dps`

You may use any additional `docker ps` arguments if needed, like `dps -s`

Usage example:  
![alt text](img/dps.png?raw=true)


#!/bin/bash

now=$(date +"%a")

case $now in
	Mon)
            	echo "Full Backup"
                # do backup
                ;;
        Tue|Wed|Thu|Fri)
                echo "Partial Backup"
                # do backup
                ;;
        Sat|Sun)
                echo "No Backup"
                ;;
        *) ;;
esac

exit
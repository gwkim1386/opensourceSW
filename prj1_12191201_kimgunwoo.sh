echo -n "User Name:"
read sname
echo -n "Student Number:"
read s
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.data'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.item'"
echo "4. Delete the 'IMDb URL' from 'u.item'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release date; in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "-----------------------------------------------------"
while true :
do
        echo -n "Enter your choice [1 - 9] "
	read choice
	echo ""

	if [ $choice = 9 ];
	then
		echo "Bye!"
		break


	# choice 1
	elif [ $choice = 1 ];						
	then								               	      echo -n "Please enter 'movie id' (1~1672): "	                
	read movieId
	echo ""
	awk -v L="$movieId" 'NR==L' u.item

	# choice 2
	elif [ $choice = 2 ];
	then
		echo -n "Do you want to get the data of 'action' genre movies from 'u.item'? (y/n): "		
	
	read yn
		if [ "$yn" == "y" ];
		then
			echo ""
			awk -F'|' '$7 == 1 {print $1" " $2;count++} count==10{exit} ' u.item	
	fi

	# choice 3
	elif [ $choice = 3 ];							       then								
		echo -n "Please enter the 'moive id' (1~1682): "	
		read ID
		rr=0						
		sum=0
		echo ""
		awk -v r="$ID" '$2==r {rr+=$3;sum++} END {print "average rating of" ID ": " rr/sum}' u.data


	# choice 4	
	elif [ $choice = 4 ];
	then
	sum=0
	echo -n "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n) "
	read yn
	if [ "$yn" == "y" ];
	then
	echo ""
		awk -F'|' '{print $1"|"$2"|"$3"|"$4"||"$6"|"$7"|"$8"|"$9"|"$10"|"$11"|"$12"|"$13"|"$14"|"$15"|"$16"|"$17"|"$18"|"$19"|"$20"|"$21"|"$22"|"$23"|"$24;sum++} sum==10{exit}' u.item
		fi

	# choice 5
	elif [ $choice = 5 ];	
	then
	echo -n "Do you want to get the data about users from 'u.user'?(y/n) "
	read yn
	if [ "$yn" == "y" ];
	then
	echo ""
	sed 's/^\([0-9]*\)|\([0-9]*\)|\([MF]\)|\([^|]*\)|\([0-9]*\)/user \1 is \2 years old \3 \4/' u.user | sed 's/M/male/; s/F/female/' |  head -n 10
	fi

	# choice 6
	elif [ $choice = 6 ];
	then
	echo -n "Do you want to Modify the format of 'release data'in 'i.item'?(y/n)"
	read yn
	if [ "$yn" == "y" ];
	then
	echo ""
	sed -n '1673,1682p' u.item | sed 's/\([0-9]\{2\}\)-\([a-zA-Z]\{3\}\)-\([0-9]\{4\}\)/\3\2\1/; s/Jan/01/; s/Feb/02/; s/Mar/03/; s/Apr/04/; s/May/05/; s/Jun/06/; s/Jul/07/; s/Aug/08/; s/Sep/09/; s/Oct/10/; s/Nov/11/; s/Dec/12/'
	fi

	# choice 7
	elif [ $choice = 7 ];
	then
	echo -n "Please enter the 'user id'(1~943):"
	read id
	echo ""
	awk -v L="$id" '$1 == L  {print $2}' u.data | sort -n | awk '{ORS ="|";print}' | sed 's/|$//'
	echo ""
	arr=()
	soArr=()
	while read -r line; do
		arr+=("$line")
		done < <(awk -v L="$id" '$1 == L {print $2}' u.data)
		soArr=($(printf "%s\n" "${arr[@]}" | sort -n))
		count=0
		echo ""
		for value in "${soArr[@]}"; do
		if [ $count -lt 10 ]; then
		line="$value"
		awk -F '|' -v L="$value" '$1 == L {print $1"|" $2}' u.item
		count=$((count + 1))
		else
		break
	fi
	done

	# choice 8
	elif [ $choice = 8 ];
	then
	echo -n "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n): "
	read yn
	if [ "$yn" == "y" ];
	then
	echo ""
		arr=()
		#get 20~29 and programmer
		while read -r line; do
		arr+=("$line")
		done < <(awk -F '|' -v L="programmer" '$4 == L && $2 < 30 && $2 > 19 {print $1}' u.user)
	declare -A numbersarr=()
	declare -A scorearr=()
	awk -v arr="${arr[*]}" 'BEGIN {split(arr, a, " ");}
	    {
	 for (i in a) {
	 if ($1 == a[i]) {
	 numbersarr[$2]++;
	 scorearr[$2]+=$3;}}}
	 END {
	     for (i = 1; i <= 1683; i++) {
	             if (i in numbersarr && numbersarr[i] != 0) {
		                 printf "%d %.5 f\n",  i, scorearr[i] / numbersarr[i];
				         }
					     }
					     }' u.data
	 
fi
fi
done



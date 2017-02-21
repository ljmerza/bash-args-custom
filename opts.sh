#!/bin/bash

print_usage() {
	cat << EOF
Usage:
	This is a test of argument passing with required and optional arguments 
	and argument values using BSD, UNIX, and GNU type arguments.

Options:
	-a
	-b (required arg value)
	-c (required arg)
	-f (zero or more arg values)
	-g
	-fg (UNIX style)
	fg (BSD style)

	(GNU style)
	--apple
	--banana
	--cherry
	--fig
	--grape
EOF
}


# if --help/-h then show help dialog
if [[ "$1" =~ ^(-{1,2}([Hh]|([Hh][Ee][Ll][Pp])))$ ]]; then
		print_usage; exit 1
else

	# while number of args is more than 0
	while [ $# -gt 0 ]; do
		# get the first arg
		opt="$1"
		# shift out the first arg
		shift;

		# get the new current arg
		current_arg="$1";

		# if UNIX style args or if BSD style args - parse out args and put each in UNIX format
		arg_array=()
		if [[ "$opt" =~ ^-{1}.* ]] && [ ${#opt} > 2 ] || [[ ! "$opt" =~ ^-{1,2}.* ]]; then
			i=0;

			# if a dash does exist then we need to skip it
			if [[ "$opt" =~ ^-{1}.* ]]; then
				i=1;
			fi

			# for each char in opts add to array with appended '-'
			while (( $i < ${#opt} )); do 
				arg_array[$i]="-${opt:$i:1}"; 
				(( i++ ));
			done
		else
		# else only one arg so add to one index array
			arg_array=("$opt");
		fi

		# for each arg in arg array see if valid arg
		for i in "${arg_array[@]}"; do
			# check each arg for validity
			case "$i" in
				"-a"|"--apple" )
						#  if the new current arg has no dash then is a value so save it
						if [[ ! "$current_arg" =~ ^-{1,2}.* ]]; then
							APPLE="$current_arg";
						fi;;

				"-b"|"--banana" ) 
						#  if the new current arg has a dash then we are missing required arg value so exit
						if [[ "$current_arg" =~ ^-{1,2}.* ]]; then
							echo "WARNING: $opt requires an value passed with it.";
							exit 1;
						else
						# else the required arg value is there so get it
							BANANA="$current_arg";
						fi;;

				"-c"|"--cherry" )
						CHERRY="true";
						#  if the new current arg has no dash then is a value so save it
						if [[ ! "$current_arg" =~ ^-{1,2}.* ]]; then
							CHERRY="$current_arg";
						fi;;

				"-f"|"--fig" )
						# while the new current arg is not the next arg, parse next value
						while [[ ! "$current_arg" =~ ^-{1,2}.* ]] && [[ $# -gt 0 ]]; do
							FIG="$FIG $current_arg";
							shift;
							current_arg="$1";
						done;;
				"-g"|"--grape" )
						GRAPE="true";;
				"-k"|"--kiwi" )
						KIWI="true";;

				#  default error messge for invalid arg
				*)  echo "ERROR: Invalid option: \""$i"\"";
					exit 1;
			esac

			# if the new current arg is not another arg then its a value and we need to discard it
			if [[ ! "$current_arg" =~ ^-{1,2}.* ]]; then
				shift;
			fi
		done
	done
fi

if [[ -z "$CHERRY" ]]; then
	echo "-c is a required argument";
	exit 1;
fi

echo "a is $APPLE";
echo "b is $BANANA";
echo "c is $CHERRY";
echo "f is $FIG";
echo "g is $GRAPE";
echo "k is $KIWI";


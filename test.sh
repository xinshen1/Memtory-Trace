#!/bin/bash
#set -x

REFERENCE=./reference_stackclient
PGM=./stackclient_memtrace

# To add a test you can add an element the REQUIRED arrays 
# or BONUS Arrays
# Each test can have a descripttion, input and optionally a num
# num is passed as the argument on the command line to set
# the default max schedule size

# Required tests
REQUIRED_DESC[0]="run stackclient_memtrace"
REQUIRED_INPUT[0]=""

function run_test()
{
   description="$1"
   input="$2"
   num="$3"

   echo -n "$description : "
   [[ -n $VERBOSE ]] &&  echo "Input:"
   [[ -n $VERBOSE ]] &&  echo "--------------------------"
   [[ -n $VERBOSE ]] &&  echo "$input"
   [[ -n $VERBOSE ]] &&  echo "--------------------------"

   if [[ -x $REFERENCE ]]; then
       solution=$($REFERENCE $num 2>&1 <<EOF
$input
EOF
)
      
   fi

   if [[ -x $PGM ]]; then
     answer=$($PGM $num 2>&1 <<EOF
$input
EOF
)
   fi

  solout="$(echo "$solution" | grep -v memtrace)"
  solmemtrace="$(echo "$solution" | grep memtrace)"
  ansout="$(echo "$answer" | grep -v memtrace)"
  ansmemtrace="$(echo "$answer" | grep memtrace)"
  ansmemerr="$(echo "$ansmemtrace" | grep ERROR)"

  if [[ -n $DEBUG ]]; then
      echo "$solution"
  else
    if [[ "$ansout" == "$solout" && -z $ansmemerr ]]; then
       echo "PASS"
       return 0
    fi
    #echo "FAIL: your program produced: '$answer' output should have been: '$solution'"
    echo "FAIL"
    [[ -n $VERBOSE ]] && echo "Your program produced:"
    [[ -n $VERBOSE ]] && echo "--------------------------"
    [[ -n $VERBOSE ]] && echo "$ansout"    
    [[ -n $VERBOSE ]] && echo "--------------------------"
    [[ -n $VERBOSE ]] && echo "Output should have been:"
    [[ -n $VERBOSE ]] && echo "--------------------------"
    [[ -n $VERBOSE ]] && echo "$solout"
    [[ -n $VERBOSE ]] && echo "--------------------------"
    if [[ -n $VERBOSE && -n $ansmemerr ]]; then
	echo "Your program seems the have memory trace errors"
	echo "$ansmemerr"
        echo "--------------------------"
    fi
    [[ -n $VERBOSE ]] && echo ""
  fi
  return 1
}

testnum=$1
type=$2

total=0
correct=0

if [[ -z $testnum ]]; then
    for ((i=0; i<${#REQUIRED_INPUT[@]}; i++)); do
	value="${REQUIRED_VALUE[$i]}"
	[[ -z $value ]] && value=1
	if run_test "${REQUIRED_DESC[$i]}" "${REQUIRED_INPUT[$i]}" "${REQUIRED_NUM[$i]}"; then
	    (( correct += $value ))
	fi
	(( total += value ))
    done
    
    
    for ((i=0; i<${#BONUS_INPUT[@]}; i++)); do
	value="${BONUS_VALUE[$i]}"
	[[ -z $value ]] && value=1
	if run_test "${BONUS_DESC[$i]}" "${BONUS_INPUT[$i]}" "${BONUS_NUM[$i]}"; then
	    (( correct += $value ))
	fi
    done
else
    VERBOSE=1
    (( i=$testnum - 1 ))
    if [[ -z "$type" ]]; then
	if (( $i < 0 || $i >= ${#REQUIRED_INPUT[@]} )); then
	    echo -n "There are ${#REQUIRED_INPUT[@]} required tests.  Please specify a test number"
	    echo " between 1 and ${#REQUIRED_INPUT[@]} inclusively"
	    exit -1
	fi
	value="${REQUIRED_VALUE[$i]}"
	[[ -z $value ]] && value=1
	if run_test "${REQUIRED_DESC[$i]}" "${REQUIRED_INPUT[$i]}" "${REQUIRED_NUM[$i]}"; then
	    (( correct += $value ))
	fi
	(( total += value ))
    else
	if (( $i < 0 || $i >= ${#BONUS_INPUT[@]} )); then
	    echo -n "There are ${#BONUS_INPUT[@]} bonus tests.  Please specify a test number"
	    echo " between 1 and ${#BONUS_INPUT[@]} inclusively"
	    exit -1
	fi	
	value="${BONUS_VALUE[$i]}"
	[[ -z $value ]] && value=1
	if run_test "${BONUS_DESC[$i]}" "${BONUS_INPUT[$i]}" "${BONUS_NUM[$i]}"; then
         (( correct += $value ))
	fi
    fi
fi
echo "score: ${correct}/${total}"

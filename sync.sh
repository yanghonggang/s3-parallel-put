#!/bin/bash
UPLOAD_TOOL="./s3-parallel-put"
BUCKET="mybucket"
HOST="127.0.0.1"
PORT="8000"
LOCAL_DIRS=$@
LOG="./upload-${BUCKET}.log"

export AWS_ACCESS_KEY_ID="0555b35654ad1656d804"
export AWS_SECRET_ACCESS_KEY="h7GhxuBLTrlhVUyxSPUKUV8r/2EI4ngqJxD7iBdBYLhwluN30JaT3Q=="

jobs=$(cat /proc/cpuinfo| grep "processor"| wc -l)

function time_cost()                                                                                 
{                                                                                                    
  local begin="$1"                                                                                   
  local end="$2"                                                                                     
  cost=$(($(date +%s -d "${end}")-$(date +%s -d "${begin}")))                                        
  echo "$cost"                                                                                       
} 

# with 'resume', it seems that, we resume from previous uploads
begin=$(date)
echo "${begin} >>> begin"
jobs=$(cat /proc/cpuinfo| grep "processor"| wc -l)

#--dry-run --limit=1 \
${UPLOAD_TOOL} --bucket=${BUCKET} \
	--host=${HOST} --put=stupid \
	--port=${PORT} \
	--content-type=guess \
	--insecure \
	--process=${jobs} \
	--log-filename=${LOG} \
	"${LOCAL_DIRS}"
end=$(date)
cost=$(time_cost "$begin" "$end")
echo "${end} >>> end, cost ${cost} seconds"

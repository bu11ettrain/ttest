#!/bin/bash
#Shut down miner

gpu_stats=$(< $GPU_STATS_JSON)
	readarray -t gpu_stats < <( jq --slurp -r -c '.[] | .busids, .brand, .temp, .fan | join(" ")' $GPU_STATS_JSON 2>/dev/null)
	busids=(${gpu_stats[0]})
#	gpu_count=${#busids[@]}
	gpu_count=`nvtool --gpucount | grep "GPU count:" | awk '{gsub(/[^0-9]/,""); print}'`
	for(( i=0; i < gpu_count; i++ )); do
		echo Mining on GPU $i has been stopped
		screen -XS gram_$i quit
	done
 screen -ls
 
 #Update
 cd ~/JettonGramGpuMiner
 git pull
 
#Start miner
npm install
gpu_stats=$(< $GPU_STATS_JSON)
	readarray -t gpu_stats < <( jq --slurp -r -c '.[] | .busids, .brand, .temp, .fan | join(" ")' $GPU_STATS_JSON 2>/dev/null)
	busids=(${gpu_stats[0]})
#	gpu_count=${#busids[@]}
	gpu_count=`nvtool --gpucount | grep "GPU count:" | awk '{gsub(/[^0-9]/,""); print}'`

	for(( i=0; i < gpu_count; i++ )); do
		echo Mining on GPU $i has been started
		screen -dmS gram_$i bash -c "while true; do node ~/JettonGramGpuMiner/send_universal.js --api tonhub --givers 10000 --timeout 8 --bin ~/JettonGramGpuMiner/pow-miner-cuda --gpu $i; sleep 1; done"
	done
 screen -ls

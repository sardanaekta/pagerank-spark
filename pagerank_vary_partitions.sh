for trial in 1
do
for partitions in 2 100 300
do
sudo sh -c "sync; echo 3 > /proc/sys/vm/drop_caches"
ssh -t ubuntu@vm-4-2 "sudo sh -c \"sync; echo 3 > /proc/sys/vm/drop_caches\""
ssh -t ubuntu@vm-4-3 "sudo sh -c \"sync; echo 3 > /proc/sys/vm/drop_caches\""
ssh -t ubuntu@vm-4-4 "sudo sh -c \"sync; echo 3 > /proc/sys/vm/drop_caches\""
ssh -t ubuntu@vm-4-5 "sudo sh -c \"sync; echo 3 > /proc/sys/vm/drop_caches\""
for z in 1 2 3 4 5
do
	ssh vm-4-$z mkdir -p /home/ubuntu/output_stats/questionA4/${partitions}/trial_${trial}
	ssh -t vm-4-$z "sudo cp /proc/net/dev /home/ubuntu/output_stats/questionA4/${partitions}/trial_${trial}/net_before"
	ssh -t vm-4-$z "sudo cp /proc/diskstats /home/ubuntu/output_stats/questionA4/${partitions}/trial_${trial}/disk_before"
done
START=$(date +%s)
hadoop fs -rmr /user/ubuntu/questionA4/${partitions}/trial_${trial}
spark-submit --verbose /home/ubuntu/assignment2/question_a/a2_pagerank.py /user/ubuntu/web-BerkStan.txt questionA4/${partitions}/trial_${trial} $partitions CS-838-Assignment2-PartA-4
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "Program run time : $DIFF">>time_${trial}_questionA4_${partitions}
for z in 1 2 3 4 5
do
	ssh -t vm-4-$z "sudo cp /proc/net/dev /home/ubuntu/output_stats/questionA4/${partitions}/trial_${trial}/net_after"
        ssh -t vm-4-$z "sudo cp /proc/diskstats /home/ubuntu/output_stats/questionA4/${partitions}/trial_${trial}/disk_after"
done
done
done


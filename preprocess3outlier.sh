for subj in `cat allsub.txt`; do

	cd ${subj}/dwi/dwipreproc-tmp-*

	totalslices=`mrinfo dwi.mif | grep Dimensions | awk '{print $6 * $8}'`

	totaloutliers=`awk '{ for(i=1;i<=NF;i++)sum+=$i } END { print sum }' dwi_post_eddy.eddy_outlier_map`

	echo "scale=5; ($totaloutliers / $totalslices * 100)/1" | bc | tee percentoutliers.txt

	cd ../../..

done

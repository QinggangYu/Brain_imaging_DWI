for subj in `cat allsub.txt`; do

	cd ${subj}/dwi

	mrconvert ${subj}_preproc.mif data.nii.gz -export_grad_mrtrix ${subj}_grad_table -export_grad_fsl bvecs bvals -force

	bet2 data.nii.gz data_bet.nii.gz -f 0.2

	dtifit --data=data.nii.gz --out=dti --mask=data_bet.nii.gz --bvecs=bvecs --bvals=bvals

	cd ../..

done

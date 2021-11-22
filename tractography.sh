for subj in `cat allsub_RH.txt`; do

	cd /home/qinggang/research/MR_raw_data/${subj}/anat	

	bet2 ${subj}_T1w.nii.gz T1_bet.nii.gz -f 0.3

	cd /cifs/lsa-research02/kitayama/QY_linux/MR_raw_data/${subj}/dwi

	dwibiascorrect -ants ${subj}_preproc.mif ${subj}_preproc_unbiased.mif -bias bias.mif

	dwi2mask ${subj}_preproc_unbiased.mif mask_unbiased.mif

	dwi2response dhollander ${subj}_preproc_unbiased.mif wm.txt gm.txt csf.txt -voxels voxels.mif

	dwi2fod msmt_csd ${subj}_preproc_unbiased.mif -mask mask_unbiased.mif wm.txt wmfod.mif gm.txt gmfod.mif csf.txt csffod.mif

	mtnormalise wmfod.mif wmfod_norm.mif gmfod.mif gmfod_norm.mif csffod.mif csffod_norm.mif -mask mask_unbiased.mif

	mrconvert /home/qinggang/research/MR_raw_data/${subj}/anat/${subj}_T1w.nii.gz T1_raw.mif

	5ttgen fsl T1_raw.mif 5tt_nocoreg.mif

	dwiextract ${subj}_preproc_unbiased.mif - -bzero | mrmath - mean mean_b0_preprocessed.mif -axis 3

	mrconvert mean_b0_preprocessed.mif mean_b0_preprocessed.nii.gz

	mrconvert 5tt_nocoreg.mif 5tt_nocoreg.nii.gz

	flirt -in mean_b0_preprocessed.nii.gz -ref /home/qinggang/research/MR_raw_data/${subj}/anat/T1_bet.nii.gz -interp nearestneighbour -dof 6 -omat diff2struct_fsl_wT1.mat

	transformconvert diff2struct_fsl_wT1.mat mean_b0_preprocessed.nii.gz /home/qinggang/research/MR_raw_data/${subj}/anat/T1_bet.nii.gz flirt_import diff2struct_mrtrix_wT1.txt

	mrtransform 5tt_nocoreg.mif -linear diff2struct_mrtrix_wT1.txt -inverse 5tt_coreg_wT1.mif

	5tt2gmwmi 5tt_coreg_wT1.mif gmwmSeed_coreg.mif

	tckgen -act 5tt_coreg_wT1.mif -backtrack -seed_gmwmi gmwmSeed_coreg.mif -select 10000000 wmfod_norm.mif tracks_10mio.tck

	tcksift -act 5tt_coreg_wT1.mif -term_number 2000000 tracks_10mio.tck wmfod_norm.mif sift_2mio.tck

	cd ../..

done

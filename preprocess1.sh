for subj in `cat subid_dwi81.txt`; do

	cd ${subj}/dwi

	mrconvert -fslgrad ${subj}_dwi80.bvec ${subj}_dwi80.bval ${subj}_dwi80.nii.gz ${subj}.mif -force

	dwidenoise ${subj}.mif ${subj}_denoised.mif -noise ${subj}_noise.mif -force

	mrcalc ${subj}_dwi80.nii.gz ${subj}_denoised.mif -subtract res.nii -force

	cd ../..

done

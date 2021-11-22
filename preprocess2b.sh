for subj in `cat subid_dwi_b.txt`; do

	cd ${subj}/dwi

	dwipreproc ${subj}_denoised.mif ${subj}_preproc.mif -rpe_none -pe_dir AP -eddy_options "--data_is_shelled " -nocleanup -force

	cd ../..

done

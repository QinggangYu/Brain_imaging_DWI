for subj in `cat allsub_RH.txt`; do

	cd /cifs/lsa-research02/kitayama/QY_linux/MR_raw_data/${subj}/dwi

	labelconvert /home/qinggang/research/MIDUS_refresher/Freesurfer/${subj:9}/mri/aparc+aseg.mgz $FREESURFER_HOME/FreeSurferColorLUT.txt /usr/local/mrtrix3/share/mrtrix3/labelconvert/fs_default.txt ${subj}_parcels.mif -force

	mrtransform ${subj}_parcels.mif -interp nearest -linear diff2struct_mrtrix_wT1.txt -inverse -datatype uint32 ${subj}_parcels_coreg.mif -force

	tck2connectome -symmetric -zero_diagonal -scale_invnodevol sift_2mio.tck ${subj}_parcels_coreg.mif fs_seg.csv -out_assignment assignment_fs_seg.csv -force

	cd ../..

done

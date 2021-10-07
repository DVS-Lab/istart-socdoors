import os

def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')
    return template, outtype, annotation_classes

def infotodict(seqinfo):
    t1w = create_key('sub-{subject}/anat/sub-{subject}_T1w')
    mag = create_key('sub-{subject}/fmap/sub-{subject}_magnitude')
    phase = create_key('sub-{subject}/fmap/sub-{subject}_phasediff')
    #nm = create_key('sub-{subject}/anat/sub-{subject}_nm')
    
    MID = create_key('sub-{subject}/func/sub-{subject}_task-mid_run-{item:02d}_bold')
    MID_sbref = create_key('sub-{subject}/func/sub-{subject}_task-mid_run-{item:02d}_sbref')

    sharedreward = create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_run-{item:02d}_bold')
    sharedreward_sbref = create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_run-{item:02d}_sbref')

    srSocial = create_key('sub-{subject}/func/sub-{subject}_task-socialdoors_run-{item:02d}_bold')
    srSocial_sbref = create_key('sub-{subject}/func/sub-{subject}_task-socialdoors_run-{item:02d}_sbref')

    srDoors = create_key('sub-{subject}/func/sub-{subject}_task-doors_run-{item:02d}_bold')
    srDoors_sbref = create_key('sub-{subject}/func/sub-{subject}_task-doors_run-{item:02d}_sbref')

    UGDG = create_key('sub-{subject}/func/sub-{subject}_task-ugdg_run-{item:02d}_bold')
    UGDG_sbref = create_key('sub-{subject}/func/sub-{subject}_task-ugdg_run-{item:02d}_sbref')

    info = {t1w: [],
            mag: [],
            phase: [],
            MID: [],
            MID_sbref: [],
            sharedreward: [],
            sharedreward_sbref: [],
            srSocial: [],
            srSocial_sbref: [],
            srDoors: [],
            srDoors_sbref: [],
            UGDG: [],
            UGDG_sbref: [],
            #nm: []
            }

    list_of_ids = [s.series_id for s in seqinfo]

    for s in seqinfo:
        if ('T1w-anat_mpg_07sag_iso' in s.protocol_name) and ('NORM' in s.image_type):
            info[t1w] = [s.series_id]
        if ('gre_field' in s.protocol_name) and ('NORM' in s.image_type):
            info[mag] = [s.series_id]
        if ('gre_field' in s.protocol_name) and ('P' in s.image_type):
            info[phase] = [s.series_id]
        #if ('Neuromel' in s.protocol_name) and ('*tse2d1_4' in s.sequence_name):
        #    info[nm] = [s.series_id]

        if (s.dim4 == 265 or s.dim4 == 398) and ('MID' in s.protocol_name) and ('MB' in s.image_type):
            info[MID].append(s.series_id)
            idx = list_of_ids.index(s.series_id)
            info[MID_sbref].append(list_of_ids[idx -1])

        if (s.dim4 >= 230 and s.dim4 <= 240) and ('shared' in s.protocol_name) and ('MB' in s.image_type):
            info[sharedreward].append(s.series_id)
            idx = list_of_ids.index(s.series_id)
            info[sharedreward_sbref].append(list_of_ids[idx -1])

        if (s.dim4 == 293) and ('social' in s.protocol_name) and ('MB' in s.image_type):
            info[srSocial] = [s.series_id]
            idx = list_of_ids.index(s.series_id)
            info[srSocial_sbref].append(list_of_ids[idx -1])

        if (s.dim4 == 293) and ('doors' in s.protocol_name) and ('MB' in s.image_type):
            info[srDoors] = [s.series_id]
            idx = list_of_ids.index(s.series_id)
            info[srDoors_sbref].append(list_of_ids[idx -1])

        if (s.dim4 == 225) and ('UGDG' in s.protocol_name) and ('MB' in s.image_type):
            info[UGDG].append(s.series_id)
            idx = list_of_ids.index(s.series_id)
            info[UGDG_sbref].append(list_of_ids[idx -1])

    return info

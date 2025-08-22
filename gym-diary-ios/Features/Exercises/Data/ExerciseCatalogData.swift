import Foundation

struct ExerciseCatalogData {
    static let jsonString = """
    {
      "muscleGroups": [
        "chest",
        "back",
        "delts",
        "arms",
        "forearms",
        "legs",
        "glutes",
        "calves",
        "core"
      ],
      "muscleSubgroups": {
        "chest": [
          "upper_chest",
          "mid_chest",
          "lower_chest",
          "serratus_anterior"
        ],
        "back": [
          "upper_back",
          "mid_back",
          "lower_back",
          "lats",
          "traps_upper",
          "traps_middle",
          "traps_lower",
          "rhomboids",
          "teres_major",
          "teres_minor",
          "erectors"
        ],
        "delts": [
          "front_deltoids",
          "side_deltoids",
          "rear_deltoids"
        ],
        "arms": [
          "biceps_long_head",
          "biceps_short_head",
          "triceps_long_head",
          "triceps_lateral_head",
          "triceps_medial_head",
          "brachialis"
        ],
        "forearms": [
          "forearm_flexors",
          "forearm_extensors",
          "brachioradialis"
        ],
        "legs": [
          "quadriceps_vastus_lateralis",
          "quadriceps_vastus_medialis",
          "quadriceps_vastus_intermedius",
          "quadriceps_rectus_femoris",
          "hamstrings_biceps_femoris",
          "hamstrings_semitendinosus",
          "hamstrings_semimembranosus",
          "adductors",
          "abductors"
        ],
        "glutes": [
          "gluteus_maximus",
          "gluteus_medius",
          "gluteus_minimus"
        ],
        "calves": [
          "gastrocnemius",
          "soleus",
          "tibialis_anterior"
        ],
        "core": [
          "rectus_abdominis",
          "external_obliques",
          "internal_obliques",
          "transverse_abdominis",
          "hip_flexors",
          "lower_back",
          "multifidus"
        ]
      },

      "attributes": [
        { "key": "equipment",     "displayName": "Equipment",     "type": "enum", "values": ["barbell","dumbbell","cable","machine","bodyweight","kettlebell","resistance_band"], "default": "bodyweight" },
        { "key": "bench_angle",   "displayName": "Bench Angle",   "type": "enum", "values": ["flat","incline","decline"], "default": "flat" },
        { "key": "grip_width",    "displayName": "Grip Width",    "type": "enum", "values": ["narrow","medium","wide"], "default": "medium" },
        { "key": "grip_type",     "displayName": "Grip Type",     "type": "enum", "values": ["overhand","underhand","neutral","mixed"], "default": "neutral" },
        { "key": "stance_width",  "displayName": "Stance Width",  "type": "enum", "values": ["narrow","medium","wide"], "default": "medium" },
        { "key": "foot_position", "displayName": "Foot Position", "type": "enum", "values": ["forward","neutral","backward"], "default": "neutral" },
        { "key": "bar_position",  "displayName": "Bar Position",  "type": "enum", "values": ["high","medium","low"], "default": "medium" },
        { "key": "hand_position", "displayName": "Hand Position", "type": "enum", "values": ["pronated","supinated","neutral"], "default": "neutral" },
        { "key": "handle_type",   "displayName": "Handle Type",   "type": "enum", "values": ["straight_bar","neutral_grip_bar","v_bar","rope","single_handle","lat_bar"], "default": "neutral_grip_bar" },
        { "key": "is_single_arm", "displayName": "Single Arm",    "type": "enum", "values": ["single_arm"], "default": null },
        { "key": "is_single_leg", "displayName": "Single Leg",    "type": "enum", "values": ["single_leg"], "default": null },
        { "key": "push_up_style", "displayName": "Push-up Style", "type": "enum", "values": ["standard","diamond","wide","archer","decline","incline","pike","one_arm","clap","spiderman","t_push_up"], "default": "standard" },
        { "key": "crunch_style", "displayName": "Crunch Style", "type": "enum", "values": ["standard","reverse","bicycle","toe_touch","cross_body","long_arm","vertical_leg","double_crunch","twisting","side_crunch"], "default": "standard" }
      ],

      "archetypes": [
        {
          "key": "bench_press",
          "displayName": "Bench Press",
          "primaryGroup": "chest",
          "primarySubgroups": ["mid_chest"],
          "secondarySubgroups": ["front_deltoids","triceps_lateral_head","triceps_long_head","serratus_anterior"],
          "primaryMuscle": "chest",
          "secondaryMuscles": ["front_deltoids","triceps","serratus_anterior"],
          "allowedAttributes": ["equipment","bench_angle","grip_width","grip_type"]
        },
        {
          "key": "chest_fly",
          "displayName": "Chest Fly",
          "primaryGroup": "chest",
          "primarySubgroups": ["mid_chest"],
          "secondarySubgroups": ["front_deltoids","serratus_anterior"],
          "primaryMuscle": "chest",
          "secondaryMuscles": ["front_deltoids"],
          "allowedAttributes": ["equipment","bench_angle"]
        },
        {
          "key": "push_up",
          "displayName": "Push-up",
          "primaryGroup": "chest",
          "primarySubgroups": ["mid_chest"],
          "secondarySubgroups": ["front_deltoids","triceps_lateral_head","core"],
          "primaryMuscle": "chest",
          "secondaryMuscles": ["front_deltoids","triceps","core"],
          "allowedAttributes": ["grip_width","push_up_style"]
        },
        {
          "key": "pull_up",
          "displayName": "Pull-up",
          "primaryGroup": "back",
          "primarySubgroups": ["lats"],
          "secondarySubgroups": ["rhomboids","traps_lower","rear_deltoids","brachialis","forearm_flexors","core"],
          "primaryMuscle": "back",
          "secondaryMuscles": ["lats","rear_deltoids","biceps","forearms","core"],
          "allowedAttributes": ["grip_width","grip_type"]
        },
        {
          "key": "chin_up",
          "displayName": "Chin-up",
          "primaryGroup": "back",
          "primarySubgroups": ["lats","biceps_short_head"],
          "secondarySubgroups": ["brachialis","forearm_flexors"],
          "primaryMuscle": "back",
          "secondaryMuscles": ["biceps","forearms"],
          "allowedAttributes": ["grip_width"]
        },
        {
          "key": "lat_pulldown",
          "displayName": "Lat Pulldown",
          "primaryGroup": "back",
          "primarySubgroups": ["lats"],
          "secondarySubgroups": ["rhomboids","traps_middle","rear_deltoids","brachialis","forearm_flexors"],
          "primaryMuscle": "back",
          "secondaryMuscles": ["lats","rear_deltoids","biceps"],
          "allowedAttributes": ["equipment","grip_width","grip_type","handle_type"]
        },
        {
          "key": "barbell_row",
          "displayName": "Barbell Row",
          "primaryGroup": "back",
          "primarySubgroups": ["mid_back","rhomboids"],
          "secondarySubgroups": ["lats","rear_deltoids","erectors","traps_middle"],
          "primaryMuscle": "back",
          "secondaryMuscles": ["mid_back","lats","rear_deltoids"],
          "allowedAttributes": ["equipment","grip_type","grip_width","bar_position"]
        },
        {
          "key": "seated_cable_row",
          "displayName": "Seated Cable Row",
          "primaryGroup": "back",
          "primarySubgroups": ["mid_back","rhomboids"],
          "secondarySubgroups": ["lats","rear_deltoids","traps_middle"],
          "primaryMuscle": "back",
          "secondaryMuscles": ["mid_back","lats","rear_deltoids"],
          "allowedAttributes": ["equipment","grip_type","handle_type"]
        },
        {
          "key": "t_bar_row",
          "displayName": "T‑Bar Row",
          "primaryGroup": "back",
          "primarySubgroups": ["mid_back"],
          "secondarySubgroups": ["lats","rear_deltoids","rhomboids"],
          "primaryMuscle": "back",
          "secondaryMuscles": ["mid_back","lats","rear_deltoids"],
          "allowedAttributes": ["equipment","grip_type"]
        },
        {
          "key": "face_pull",
          "displayName": "Face Pull",
          "primaryGroup": "back",
          "primarySubgroups": ["rear_deltoids"],
          "secondarySubgroups": ["traps_upper","traps_middle","rotator_cuff"],
          "primaryMuscle": "back",
          "secondaryMuscles": ["rear_deltoids","traps"],
          "allowedAttributes": ["equipment","handle_type","grip_type"]
        },
        {
          "key": "overhead_press",
          "displayName": "Overhead Press",
          "primaryGroup": "delts",
          "primarySubgroups": ["front_deltoids"],
          "secondarySubgroups": ["side_deltoids","upper_back","traps_upper","core"],
          "primaryMuscle": "delts",
          "secondaryMuscles": ["front_deltoids","side_deltoids","traps","core"],
          "allowedAttributes": ["equipment","grip_width","grip_type"]
        },
        {
          "key": "lateral_raise",
          "displayName": "Lateral Raise",
          "primaryGroup": "delts",
          "primarySubgroups": ["side_deltoids"],
          "secondarySubgroups": [],
          "primaryMuscle": "delts",
          "secondaryMuscles": [],
          "allowedAttributes": ["equipment","is_single_arm"]
        },
        {
          "key": "rear_delt_fly",
          "displayName": "Rear Delt Fly",
          "primaryGroup": "delts",
          "primarySubgroups": ["rear_deltoids"],
          "secondarySubgroups": ["traps_middle"],
          "primaryMuscle": "delts",
          "secondaryMuscles": ["rear_deltoids","traps"],
          "allowedAttributes": ["equipment","is_single_arm"]
        },
        {
          "key": "front_raise",
          "displayName": "Front Raise",
          "primaryGroup": "delts",
          "primarySubgroups": ["front_deltoids"],
          "secondarySubgroups": [],
          "primaryMuscle": "delts",
          "secondaryMuscles": ["front_deltoids"],
          "allowedAttributes": ["equipment","is_single_arm"]
        },
        {
          "key": "barbell_curl",
          "displayName": "Barbell Curl",
          "primaryGroup": "arms",
          "primarySubgroups": ["biceps_long_head","biceps_short_head"],
          "secondarySubgroups": ["brachialis","forearm_flexors"],
          "primaryMuscle": "arms",
          "secondaryMuscles": ["biceps","forearms"],
          "allowedAttributes": ["equipment","grip_type","grip_width"]
        },
        {
          "key": "dumbbell_curl",
          "displayName": "Dumbbell Curl",
          "primaryGroup": "arms",
          "primarySubgroups": ["biceps_long_head","biceps_short_head"],
          "secondarySubgroups": ["brachialis","forearm_flexors"],
          "primaryMuscle": "arms",
          "secondaryMuscles": ["biceps","forearms"],
          "allowedAttributes": ["equipment","is_single_arm"]
        },
        {
          "key": "hammer_curl",
          "displayName": "Hammer Curl",
          "primaryGroup": "arms",
          "primarySubgroups": ["brachialis"],
          "secondarySubgroups": ["biceps_long_head","brachioradialis"],
          "primaryMuscle": "arms",
          "secondaryMuscles": ["biceps","forearms"],
          "allowedAttributes": ["equipment","is_single_arm"]
        },
        {
          "key": "preacher_curl",
          "displayName": "Preacher Curl",
          "primaryGroup": "arms",
          "primarySubgroups": ["biceps_short_head"],
          "secondarySubgroups": ["brachialis"],
          "primaryMuscle": "arms",
          "secondaryMuscles": ["biceps"],
          "allowedAttributes": ["equipment","grip_type"]
        },
        {
          "key": "tricep_pushdown",
          "displayName": "Tricep Pushdown",
          "primaryGroup": "arms",
          "primarySubgroups": ["triceps_lateral_head","triceps_long_head"],
          "secondarySubgroups": [],
          "primaryMuscle": "arms",
          "secondaryMuscles": ["triceps"],
          "allowedAttributes": ["equipment","handle_type","grip_type"]
        },
        {
          "key": "skull_crusher",
          "displayName": "Skull Crusher",
          "primaryGroup": "arms",
          "primarySubgroups": ["triceps_long_head","triceps_lateral_head"],
          "secondarySubgroups": [],
          "primaryMuscle": "arms",
          "secondaryMuscles": ["triceps"],
          "allowedAttributes": ["equipment","grip_type"]
        },
        {
          "key": "overhead_triceps_extension",
          "displayName": "Overhead Triceps Extension",
          "primaryGroup": "arms",
          "primarySubgroups": ["triceps_long_head"],
          "secondarySubgroups": ["triceps_medial_head"],
          "primaryMuscle": "arms",
          "secondaryMuscles": ["triceps"],
          "allowedAttributes": ["equipment","is_single_arm","grip_type"]
        },
        {
          "key": "wrist_curl",
          "displayName": "Wrist Curl",
          "primaryGroup": "forearms",
          "primarySubgroups": ["forearm_flexors"],
          "secondarySubgroups": [],
          "primaryMuscle": "forearms",
          "secondaryMuscles": [],
          "allowedAttributes": ["equipment"]
        },
        {
          "key": "reverse_wrist_curl",
          "displayName": "Reverse Wrist Curl",
          "primaryGroup": "forearms",
          "primarySubgroups": ["forearm_extensors"],
          "secondarySubgroups": [],
          "primaryMuscle": "forearms",
          "secondaryMuscles": [],
          "allowedAttributes": ["equipment"]
        },
        {
          "key": "squat",
          "displayName": "Squat",
          "primaryGroup": "legs",
          "primarySubgroups": ["quadriceps_vastus_lateralis","quadriceps_rectus_femoris"],
          "secondarySubgroups": ["gluteus_maximus","hamstrings_biceps_femoris","erectors","core"],
          "primaryMuscle": "legs",
          "secondaryMuscles": ["quadriceps","glutes","hamstrings","core"],
          "allowedAttributes": ["equipment","stance_width","foot_position"]
        },
        {
          "key": "front_squat",
          "displayName": "Front Squat",
          "primaryGroup": "legs",
          "primarySubgroups": ["quadriceps_rectus_femoris","quadriceps_vastus_medialis"],
          "secondarySubgroups": ["gluteus_maximus","core","upper_back"],
          "primaryMuscle": "legs",
          "secondaryMuscles": ["quadriceps","glutes","core"],
          "allowedAttributes": ["equipment","stance_width"]
        },
        {
          "key": "deadlift",
          "displayName": "Deadlift",
          "primaryGroup": "legs",
          "primarySubgroups": ["hamstrings_biceps_femoris","hamstrings_semimembranosus"],
          "secondarySubgroups": ["gluteus_maximus","erectors","forearm_flexors","core"],
          "primaryMuscle": "legs",
          "secondaryMuscles": ["hamstrings","glutes","lower_back","core"],
          "allowedAttributes": ["equipment","stance_width","grip_type"]
        },
        {
          "key": "romanian_deadlift",
          "displayName": "Romanian Deadlift",
          "primaryGroup": "legs",
          "primarySubgroups": ["hamstrings_semitendinosus","hamstrings_biceps_femoris"],
          "secondarySubgroups": ["gluteus_maximus","erectors"],
          "primaryMuscle": "legs",
          "secondaryMuscles": ["hamstrings","glutes","lower_back"],
          "allowedAttributes": ["equipment","grip_type"]
        },
        {
          "key": "lunge",
          "displayName": "Lunge",
          "primaryGroup": "legs",
          "primarySubgroups": ["quadriceps_vastus_lateralis","quadriceps_vastus_medialis"],
          "secondarySubgroups": ["gluteus_maximus","adductors","core"],
          "primaryMuscle": "legs",
          "secondaryMuscles": ["quadriceps","glutes","core"],
          "allowedAttributes": ["equipment","is_single_leg","stance_width"]
        },
        {
          "key": "bulgarian_split_squat",
          "displayName": "Bulgarian Split Squat",
          "primaryGroup": "legs",
          "primarySubgroups": ["quadriceps_rectus_femoris","quadriceps_vastus_medialis"],
          "secondarySubgroups": ["gluteus_maximus","core"],
          "primaryMuscle": "legs",
          "secondaryMuscles": ["quadriceps","glutes","core"],
          "allowedAttributes": ["equipment","is_single_leg"]
        },
        {
          "key": "leg_press",
          "displayName": "Leg Press",
          "primaryGroup": "legs",
          "primarySubgroups": ["quadriceps_vastus_lateralis","quadriceps_vastus_medialis"],
          "secondarySubgroups": ["gluteus_maximus","hamstrings_biceps_femoris"],
          "primaryMuscle": "legs",
          "secondaryMuscles": ["quadriceps","glutes","hamstrings"],
          "allowedAttributes": ["equipment","stance_width","foot_position"]
        },
        {
          "key": "leg_extension",
          "displayName": "Leg Extension",
          "primaryGroup": "legs",
          "primarySubgroups": ["quadriceps_rectus_femoris","quadriceps_vastus_intermedius"],
          "secondarySubgroups": [],
          "primaryMuscle": "legs",
          "secondaryMuscles": ["quadriceps"],
          "allowedAttributes": ["equipment"]
        },
        {
          "key": "leg_curl",
          "displayName": "Leg Curl",
          "primaryGroup": "legs",
          "primarySubgroups": ["hamstrings_biceps_femoris","hamstrings_semitendinosus"],
          "secondarySubgroups": [],
          "primaryMuscle": "legs",
          "secondaryMuscles": ["hamstrings"],
          "allowedAttributes": ["equipment"]
        },
        {
          "key": "hip_thrust",
          "displayName": "Hip Thrust",
          "primaryGroup": "glutes",
          "primarySubgroups": ["gluteus_maximus"],
          "secondarySubgroups": ["hamstrings_biceps_femoris","erectors"],
          "primaryMuscle": "glutes",
          "secondaryMuscles": ["hamstrings","lower_back"],
          "allowedAttributes": ["equipment"]
        },
        {
          "key": "glute_bridge",
          "displayName": "Glute Bridge",
          "primaryGroup": "glutes",
          "primarySubgroups": ["gluteus_maximus"],
          "secondarySubgroups": ["erectors"],
          "primaryMuscle": "glutes",
          "secondaryMuscles": ["lower_back"],
          "allowedAttributes": ["equipment"]
        },
        {
          "key": "cable_kickback",
          "displayName": "Cable Kickback",
          "primaryGroup": "glutes",
          "primarySubgroups": ["gluteus_maximus","gluteus_medius"],
          "secondarySubgroups": [],
          "primaryMuscle": "glutes",
          "secondaryMuscles": [],
          "allowedAttributes": ["equipment","is_single_leg"]
        },
        {
          "key": "calf_raise_standing",
          "displayName": "Standing Calf Raise",
          "primaryGroup": "calves",
          "primarySubgroups": ["gastrocnemius"],
          "secondarySubgroups": [],
          "primaryMuscle": "calves",
          "secondaryMuscles": [],
          "allowedAttributes": ["equipment","is_single_leg"]
        },
        {
          "key": "calf_raise_seated",
          "displayName": "Seated Calf Raise",
          "primaryGroup": "calves",
          "primarySubgroups": ["soleus"],
          "secondarySubgroups": [],
          "primaryMuscle": "calves",
          "secondaryMuscles": [],
          "allowedAttributes": ["equipment"]
        },
        {
          "key": "crunch",
          "displayName": "Crunch",
          "primaryGroup": "core",
          "primarySubgroups": ["rectus_abdominis"],
          "secondarySubgroups": [],
          "primaryMuscle": "core",
          "secondaryMuscles": [],
          "allowedAttributes": ["equipment","crunch_style"]
        },
        {
          "key": "reverse_crunch",
          "displayName": "Reverse Crunch",
          "primaryGroup": "core",
          "primarySubgroups": ["rectus_abdominis"],
          "secondarySubgroups": ["hip_flexors"],
          "primaryMuscle": "core",
          "secondaryMuscles": ["hip_flexors"],
          "allowedAttributes": ["equipment"]
        },
        {
          "key": "bicycle_crunch",
          "displayName": "Bicycle Crunch",
          "primaryGroup": "core",
          "primarySubgroups": ["rectus_abdominis","external_obliques"],
          "secondarySubgroups": ["internal_obliques"],
          "primaryMuscle": "core",
          "secondaryMuscles": ["obliques"],
          "allowedAttributes": ["equipment"]
        },
        {
          "key": "plank",
          "displayName": "Plank",
          "primaryGroup": "core",
          "primarySubgroups": ["transverse_abdominis"],
          "secondarySubgroups": ["rectus_abdominis","gluteus_maximus","shoulders"],
          "primaryMuscle": "core",
          "secondaryMuscles": ["abs","glutes","shoulders"],
          "allowedAttributes": ["equipment"]
        },
        {
          "key": "hollow_hold",
          "displayName": "Hollow Hold",
          "primaryGroup": "core",
          "primarySubgroups": ["transverse_abdominis","rectus_abdominis"],
          "secondarySubgroups": [],
          "primaryMuscle": "core",
          "secondaryMuscles": [],
          "allowedAttributes": ["equipment"]
        },
        {
          "key": "hanging_leg_raise",
          "displayName": "Hanging Leg Raise",
          "primaryGroup": "core",
          "primarySubgroups": ["rectus_abdominis"],
          "secondarySubgroups": ["hip_flexors"],
          "primaryMuscle": "core",
          "secondaryMuscles": ["hip_flexors"],
          "allowedAttributes": ["grip_type","grip_width"]
        },
        {
          "key": "cable_crunch",
          "displayName": "Cable Crunch",
          "primaryGroup": "core",
          "primarySubgroups": ["rectus_abdominis"],
          "secondarySubgroups": ["external_obliques"],
          "primaryMuscle": "core",
          "secondaryMuscles": ["obliques"],
          "allowedAttributes": ["equipment","handle_type","grip_type"]
        },
        {
          "key": "ab_wheel_rollout",
          "displayName": "Ab Wheel Rollout",
          "primaryGroup": "core",
          "primarySubgroups": ["transverse_abdominis","rectus_abdominis"],
          "secondarySubgroups": ["lats","shoulders"],
          "primaryMuscle": "core",
          "secondaryMuscles": ["shoulders","lats"],
          "allowedAttributes": ["equipment"]
        },
        {
          "key": "russian_twist",
          "displayName": "Russian Twist",
          "primaryGroup": "core",
          "primarySubgroups": ["external_obliques","internal_obliques"],
          "secondarySubgroups": ["rectus_abdominis"],
          "primaryMuscle": "core",
          "secondaryMuscles": ["obliques"],
          "allowedAttributes": ["equipment","is_single_arm"]
        }
      ],

      "rules": [
        { "scope": "global", "target": "equipment", "require": ["equipment"], "errorMessage": "Select an equipment to continue." },

        { "scope": "global", "target": "bench_angle", "if": { "equipment": ["bodyweight","kettlebell","resistance_band"] }, "deny": { "bench_angle": ["flat","incline","decline"] }, "errorMessage": "Bench angle only applies with barbell, dumbbell, or machine." },

        { "scope": "global", "target": "grip_width", "if": { "equipment": ["barbell","dumbbell"] }, "allow": { "grip_width": ["narrow","medium","wide"] }, "errorMessage": "Grip width is available only with barbell or dumbbell." },
        { "scope": "global", "target": "grip_width", "if": { "equipment": ["machine","cable","bodyweight","kettlebell","resistance_band"] }, "deny": { "grip_width": ["narrow","medium","wide"] }, "errorMessage": "Grip width is not applicable for the selected equipment." },

        { "scope": "global", "target": "grip_type", "if": { "equipment": ["barbell","dumbbell","cable"] }, "allow": { "grip_type": ["overhand","underhand","neutral","mixed"] }, "errorMessage": "Invalid grip type for this equipment." },
        { "scope": "archetype", "archetype": "bench_press", "target": "equipment", "allow": { "equipment": ["barbell","dumbbell","machine"] }, "errorMessage": "Bench press requires barbell, dumbbell, or machine." },
        { "scope": "archetype", "archetype": "bench_press", "target": "bench_angle", "if": { "equipment": ["barbell","dumbbell","machine"] }, "allow": { "bench_angle": ["flat","incline","decline"] }, "errorMessage": "Selected bench angle is not valid for this equipment." },
        { "scope": "archetype", "archetype": "barbell_row", "target": "equipment", "allow": { "equipment": ["barbell"] }, "errorMessage": "Barbell row requires barbell." },
        { "scope": "archetype", "archetype": "seated_cable_row", "target": "equipment", "allow": { "equipment": ["cable","machine"] }, "errorMessage": "Seated cable row requires cable/machine." },
        { "scope": "archetype", "archetype": "t_bar_row", "target": "equipment", "allow": { "equipment": ["barbell","machine"] }, "errorMessage": "T‑Bar row requires landmine/barbell or machine." },
        { "scope": "archetype", "archetype": "face_pull", "target": "equipment", "allow": { "equipment": ["cable"] }, "errorMessage": "Face pull is a cable-only exercise." },
        { "scope": "archetype", "archetype": "lat_pulldown", "target": "handle_type", "if": { "equipment": ["cable","machine"] }, "allow": { "handle_type": ["straight_bar","neutral_grip_bar","v_bar","rope","single_handle","lat_bar"] }, "errorMessage": "Select a valid handle/attachment for lat pulldown." },
        { "scope": "archetype", "archetype": "overhead_press", "target": "grip_width", "if": { "equipment": ["barbell","dumbbell"] }, "allow": { "grip_width": ["narrow","medium","wide"] }, "errorMessage": "Grip width not valid for the selected overhead press equipment." },
        { "scope": "archetype", "archetype": "barbell_curl", "target": "equipment", "allow": { "equipment": ["barbell"] }, "errorMessage": "Barbell curl requires barbell." },
        { "scope": "archetype", "archetype": "preacher_curl", "target": "equipment", "allow": { "equipment": ["dumbbell","machine","barbell"] }, "errorMessage": "Preacher curl requires preacher bench (dumbbells, barbell or machine)." },
        { "scope": "archetype", "archetype": "tricep_pushdown", "target": "equipment", "allow": { "equipment": ["cable","machine"] }, "errorMessage": "Tricep pushdown requires cable/machine." },
        { "scope": "archetype", "archetype": "skull_crusher", "target": "equipment", "allow": { "equipment": ["barbell","dumbbell"] }, "errorMessage": "Skull crusher requires barbell or dumbbells." },
        { "scope": "archetype", "archetype": "squat", "target": "stance_width", "if": { "equipment": ["barbell","dumbbell","bodyweight"] }, "allow": { "stance_width": ["narrow","medium","wide"] }, "errorMessage": "Invalid stance width for the selected squat setup." },
        { "scope": "archetype", "archetype": "deadlift", "target": "stance_width", "if": { "equipment": ["barbell","dumbbell"] }, "allow": { "stance_width": ["narrow","medium","wide"] }, "errorMessage": "Invalid stance width for the selected deadlift setup." },
        { "scope": "archetype", "archetype": "calf_raise_standing", "target": "is_single_leg", "if": { "equipment": ["barbell","dumbbell","machine","bodyweight"] }, "allow": { "is_single_leg": ["single_leg"] }, "errorMessage": "Single-leg option only available for standing variations." },
        { "scope": "archetype", "archetype": "hanging_leg_raise", "target": "grip_type", "allow": { "grip_type": ["overhand","underhand","neutral"] }, "errorMessage": "Choose a valid bar grip for hanging leg raise." },
        { "scope": "archetype", "archetype": "cable_crunch", "target": "equipment", "allow": { "equipment": ["cable","machine"] }, "errorMessage": "Cable crunch requires cable/machine." },
        { "scope": "archetype", "archetype": "push_up", "target": "push_up_style", "allow": { "push_up_style": ["standard","diamond","wide","archer","decline","incline","pike","one_arm","clap","spiderman","t_push_up"] }, "errorMessage": "Select a valid push-up style." },
        { "scope": "archetype", "archetype": "crunch", "target": "crunch_style", "allow": { "crunch_style": ["standard","reverse","bicycle","toe_touch","cross_body","long_arm","vertical_leg","double_crunch","twisting","side_crunch"] }, "errorMessage": "Select a valid crunch style." }
      ]
    }
    """
}
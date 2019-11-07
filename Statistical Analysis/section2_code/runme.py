import os 
import yaml
from python_modules.label import Label
with open("configuration.yml", 'r') as f:
    try:
        configuration=yaml.safe_load(f)
    except yaml.YAMLError as exc:
        print(exc)

destination_file=os.path.join(configuration['destination_folder'],"%s_features.csv"%configuration['student_number'])
with open(destination_file,'w') as file:
    # Write header
    header=['label','index']+configuration['features']

    file.writelines('\t'.join(header)+'\n')


    # Write features
    all_data=list()

    label_names=configuration['labels']
    label_names.sort()
    for label_name in label_names:
        print("Processing %s..."%label_name)
        label=Label(label_name,configuration,file)
        all_data.append(label.get_label_dict())



print("All data:\n",all_data)
from python_modules.image_list import image_list
import yaml
from python_modules.image_list import image_list
from python_modules.label import Label
with open("configuration.yml", 'r') as f:
    try:
        configuration=yaml.safe_load(f)
    except yaml.YAMLError as exc:
        print(exc)

all_data=list()

label_names=configuration['labels']
for label_name in label_names:
    label=Label(label_name,configuration)
    all_data.append(label.get_label_dict())

print("All data:\n",all_data)
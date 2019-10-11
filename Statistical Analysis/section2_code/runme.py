from python_modules.image_list import image_list
import yaml

with open("configuration.yml", 'r') as f:
    try:
        configuration=yaml.safe_load(f)
    except yaml.YAMLError as exc:
        print(exc)

images=image_list(configuration)
print(images)
for image in images:
    pass
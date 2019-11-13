# Run the file to convert
# all pgm files in raw format genearted by GIMP
# into
# csv files delimited by TAB in text format



import numpy
from PIL import Image
import os
import yaml



def image_list(configuration):    
    image_list=list()    
    stduent=str(configuration["student_number"])
    for each_object in configuration["objects"]:
        for index in range(configuration["min_index"],configuration["max_index"]+1):
            index="{0:0=2d}".format(index)
            image="_".join([stduent,each_object,str(index)])
            image+=".pgm"
            image=os.path.join(configuration["image_directory"],image)
            image_list.append(image)


    return image_list

def read_image(pgm_image):
    if(os.path.exists(pgm_image)):
        image=Image.open(pgm_image)
        return numpy.array(image)
    else:
        raise Exception("File %s does not exist"%(pgm_image))


def transform_ndarray_to_01(ndarray):
    
    (rows, colums)=ndarray.shape

    for each_row in range(rows):
        for each_column in range(colums):
            if(ndarray[each_row,each_column]<128):
                ndarray[each_row,each_column]=1
            else:
                ndarray[each_row,each_column]=0
    return ndarray

def save_to_file(file_name,ndarray):
    if(os.path.exists(file_name)):
        os.remove(file_name)    
    numpy.savetxt(file_name,ndarray,delimiter="\t",fmt="%s")




with open("configuration.yml", 'r') as f:
    try:
        configuration=yaml.safe_load(f)
    except yaml.YAMLError as exc:
        print(exc)


# Get a list of pgm image paths
images=image_list(configuration)

# For each path
for image in images:

    # Print the image path
    print("Converting image: %s"%image)

    # Read the image data
    ndarray=read_image(image)

    # Transform all pixel with value 128 or higher to 0, other values to 1
    ndarray=transform_ndarray_to_01(ndarray)

    # Get the path of the file that should be generated
    filename, file_extension = os.path.splitext(image)
    csv_file=filename+".csv"

    # Write the data into the file
    print("Writing the following data into file %s"%csv_file)
    print(ndarray)
    save_to_file(csv_file,ndarray)
    print("File %s generated"%csv_file)
    print("----------------------------------------------------------------------\n")

print("\n%d csv files generated. Done"%len(images))
